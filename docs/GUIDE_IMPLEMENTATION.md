# Guide d'Implémentation - Application Mobile Inventaire GLPI

## Phase 1: Setup Backend GLPI (2-3 semaines)

### 1.1 Créer le plugin GLPI

```bash
cd /var/www/html/glpi/plugins
mkdir inventorymobile
cd inventorymobile
```

Structure du plugin:
```
inventorymobile/
├── setup.php
├── hook.php
├── inc/
│   ├── api.class.php
│   ├── campaign.class.php
│   ├── mission.class.php
│   ├── inventoryitem.class.php
│   ├── anomaly.class.php
│   └── config.class.php
├── front/
│   ├── campaign.php
│   ├── campaign.form.php
│   ├── mission.php
│   └── mission.form.php
├── locales/
│   ├── fr_FR.po
│   └── en_GB.po
└── sql/
    ├── install.sql
    └── uninstall.sql
```

### 1.2 Installer le schéma de base de données

```bash
mysql -u root -p glpi < database/schema_inventory_mobile.sql
```

### 1.3 Configurer les endpoints API

Dans `inc/api.class.php`, enregistrer les nouveaux endpoints:

```php
// Ajouter dans la méthode initApi()
$app->group('/inventory', function() use ($app) {
    // Campaigns
    $app->get('/campaigns', 'getCampaigns');
    $app->get('/campaigns/{id}', 'getCampaign');
    $app->post('/campaigns', 'createCampaign');
    
    // Missions
    $app->get('/missions/my-missions', 'getMyMissions');
    $app->get('/missions/{id}', 'getMission');
    $app->post('/missions/{id}/start', 'startMission');
    
    // Inventory
    $app->post('/scan', 'scanEquipment');
    $app->post('/equipment/update', 'updateEquipment');
    $app->post('/report-anomaly', 'reportAnomaly');
    
    // Sync
    $app->post('/sync/batch', 'syncBatch');
});
```

### 1.4 Configuration des droits

Dans GLPI Admin > Profils:
- Créer un profil "Technicien Inventaire Mobile"
- Droits: Lecture sur équipements, Écriture sur plugin inventorymobile
- Assigner aux utilisateurs techniciens

## Phase 2: Développement Application Flutter (4-6 semaines)

### 2.1 Initialiser le projet

```bash
flutter create glpi_inventory_mobile
cd glpi_inventory_mobile
```

### 2.2 Configuration initiale

**pubspec.yaml**: Déjà créé (voir `/flutter_app/pubspec.yaml`)

**Configuration API**: Créer `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-glpi-server.com/api';
  static const String appToken = 'YOUR_APP_TOKEN'; // À configurer dans GLPI
  
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  static const String userTokenKey = 'user_token';
  static const String sessionTokenKey = 'session_token';
}
```

### 2.3 Setup State Management (Riverpod)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2.4 Développer les features dans l'ordre

#### Semaine 1-2: Authentication
- [x] Écran de login
- [x] Gestion session GLPI
- [x] Sélection entité
- [x] Stockage sécurisé tokens

#### Semaine 2-3: Missions & Campaigns
- [x] Liste des missions
- [x] Détails mission
- [x] Téléchargement données offline
- [x] Démarrage mission

#### Semaine 3-4: Scan & Inventory
- [x] Scanner code-barres/QR
- [x] Recherche équipements
- [x] Formulaire inventaire
- [x] Prise de photos
- [x] Géolocalisation

#### Semaine 4-5: Offline & Sync
- [x] Base de données locale (Drift)
- [x] File d'attente sync
- [x] Gestion conflits
- [x] Indicateur statut sync

#### Semaine 5-6: Polish & Testing
- [x] Gestion erreurs
- [x] Optimisations performance
- [x] Tests unitaires
- [x] Tests d'intégration

## Phase 3: Intégration & Tests (2 semaines)

### 3.1 Tests unitaires Backend

```php
// tests/InventoryMobileApiTest.php
class InventoryMobileApiTest extends DbTestCase {
    public function testGetMyMissions() {
        // Test récupération missions
    }
    
    public function testScanEquipment() {
        // Test scan équipement
    }
    
    public function testSyncBatch() {
        // Test synchronisation
    }
}
```

### 3.2 Tests Flutter

```bash
# Tests unitaires
flutter test

# Tests d'intégration
flutter test integration_test/

# Tests de widgets
flutter test test/widgets/
```

### 3.3 Tests utilisateur (UAT)

1. **Scénario 1: Mission complète**
   - Technicien se connecte
   - Télécharge mission
   - Scanne 20 équipements
   - Ajoute photos
   - Signale 2 anomalies
   - Synchronise

2. **Scénario 2: Mode offline**
   - Perte de réseau
   - Inventaire de 10 équipements
   - Retour réseau
   - Synchronisation automatique

3. **Scénario 3: Multi-entités**
   - Utilisateur avec accès à 3 entités
   - Changement d'entité
   - Vérification isolation des données

## Phase 4: Déploiement (1 semaine)

### 4.1 Backend Production

```bash
# Backup base de données
mysqldump -u root -p glpi > backup_before_inventorymobile.sql

# Installation plugin
cd /var/www/html/glpi/plugins
git clone <repo> inventorymobile
chown -R www-data:www-data inventorymobile

# Installation via interface GLPI
# Configuration > Plugins > Inventory Mobile > Installer
```

### 4.2 Build Application Mobile

**Android:**
```bash
# Build APK de test
flutter build apk --debug

# Build APK de production
flutter build apk --release --split-per-abi

# Build App Bundle (Google Play)
flutter build appbundle --release
```

**iOS:**
```bash
# Build iOS
flutter build ios --release

# Archive pour App Store
xcodebuild -workspace ios/Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           archive
```

### 4.3 Distribution

**Option 1: Distribution directe (APK)**
- Héberger APK sur serveur interne
- Partager lien de téléchargement
- Activation "Sources inconnues" sur Android

**Option 2: Google Play (Privé)**
- Créer compte Google Play Console
- Upload App Bundle
- Configuration distribution privée
- Inviter utilisateurs par email

**Option 3: MDM (Mobile Device Management)**
- Intégration avec MDM d'entreprise
- Déploiement automatique sur appareils managés

## Phase 5: Formation & Documentation (1 semaine)

### 5.1 Formation Administrateurs

**Contenu (4h):**
1. Présentation architecture
2. Création campagnes
3. Assignation missions
4. Suivi progression
5. Gestion anomalies
6. Export rapports

### 5.2 Formation Techniciens

**Contenu (2h):**
1. Installation application
2. Connexion et sélection entité
3. Consultation missions
4. Scan équipements
5. Ajout photos et notes
6. Signalement anomalies
7. Synchronisation
8. Gestion offline

### 5.3 Documentation

Créer:
- Manuel administrateur (PDF)
- Manuel technicien (PDF)
- Vidéos tutorielles (2-3 min chacune)
- FAQ
- Guide dépannage

## Maintenance & Évolutions

### Monitoring

**Backend:**
```sql
-- Requêtes de monitoring
SELECT * FROM glpi_plugin_inventorymobile_campaigns_progress;

SELECT technician_name, COUNT(*) as missions, 
       SUM(scanned_equipment) as total_scanned
FROM glpi_plugin_inventorymobile_technician_missions
WHERE status = 'completed'
GROUP BY technician_id;

SELECT DATE(date_sync), COUNT(*) as syncs, 
       AVG(sync_duration) as avg_duration
FROM glpi_plugin_inventorymobile_sync_logs
GROUP BY DATE(date_sync)
ORDER BY date_sync DESC;
```

**Mobile:**
- Firebase Analytics (optionnel)
- Crash reporting (Sentry/Crashlytics)
- Logs application

### Évolutions futures

**Phase 2:**
- [ ] Scan NFC
- [ ] Reconnaissance OCR
- [ ] Signatures électroniques
- [ ] Export PDF local
- [ ] Mode multi-techniciens (équipe)

**Phase 3:**
- [ ] IA pour détection anomalies
- [ ] Prédiction durée missions
- [ ] Optimisation parcours
- [ ] Dashboard temps réel
- [ ] Notifications push

## Checklist de déploiement

### Backend
- [ ] Plugin installé et activé
- [ ] Base de données créée
- [ ] API endpoints testés
- [ ] Droits utilisateurs configurés
- [ ] App Token généré
- [ ] HTTPS activé
- [ ] Backup configuré

### Mobile
- [ ] Application buildée
- [ ] Tests validés
- [ ] Configuration production
- [ ] Certificats signés
- [ ] Stores configurés (si applicable)
- [ ] Documentation créée

### Utilisateurs
- [ ] Comptes techniciens créés
- [ ] Profils assignés
- [ ] Formation effectuée
- [ ] Appareils configurés
- [ ] Support disponible

## Support & Contact

- **Support technique**: support@example.com
- **Documentation**: https://docs.example.com/inventory-mobile
- **Hotline**: +33 X XX XX XX XX
- **Heures support**: Lun-Ven 9h-18h

## Coûts estimés

### Développement
- Backend (plugin GLPI): 10-15 jours
- Frontend (Flutter): 20-30 jours
- Tests: 5-10 jours
- **Total**: 35-55 jours-homme

### Infrastructure
- Serveur GLPI: existant
- Backup: existant
- Distribution app: 0€ (APK) ou 25€/an (Google Play)

### Formation
- Formateurs: 2 jours
- Techniciens: 2h par personne

### Maintenance annuelle
- Support: 5-10 jours/an
- Évolutions: selon besoins
- Hosting: inclus dans infra GLPI
