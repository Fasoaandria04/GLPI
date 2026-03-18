# GLPI Inventory Mobile

Application mobile Flutter pour l'assistance aux techniciens pendant l'inventaire sur terrain, intégrée avec GLPI 11.

## Description

Cette application permet aux techniciens de:
- Consulter leurs missions d'inventaire
- Scanner les codes-barres/QR codes des équipements
- Mettre à jour les informations d'inventaire
- Prendre des photos des équipements
- Géolocaliser les équipements
- Signaler des anomalies
- Travailler en mode hors-ligne avec synchronisation automatique

## Prérequis

- Flutter SDK 3.0 ou supérieur
- Dart 3.0 ou supérieur
- Android Studio / Xcode
- Serveur GLPI 11.x avec plugin Inventory Mobile installé

## Installation

### 1. Cloner le repository

```bash
git clone <repository-url>
cd flutter_app
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Générer le code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configuration

Créer le fichier `lib/core/config/env.dart`:

```dart
class Env {
  static const String glpiBaseUrl = 'https://your-glpi-server.com';
  static const String glpiAppToken = 'YOUR_APP_TOKEN';
}
```

## Lancer l'application

### Mode debug

```bash
# Android
flutter run

# iOS
flutter run -d ios
```

### Build production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## Architecture

L'application suit l'architecture Clean Architecture avec les couches suivantes:

```
lib/
├── core/               # Configuration, constantes, utils
├── features/           # Fonctionnalités organisées par domaine
│   ├── auth/          # Authentification
│   ├── inventory_campaign/  # Campagnes et missions
│   ├── equipment_scan/      # Scan et inventaire
│   ├── sync/          # Synchronisation
│   └── reporting/     # Rapports
└── shared/            # Widgets et services partagés
```

Chaque feature est organisée en 3 couches:
- **presentation**: UI (screens, widgets, providers)
- **domain**: Logique métier (entities, usecases)
- **data**: Accès données (models, repositories, datasources)

## Fonctionnalités principales

### Authentification
- Connexion avec token API GLPI
- Sélection d'entité
- Gestion multi-profils
- Stockage sécurisé des credentials

### Missions
- Liste des missions assignées
- Détails de mission avec liste d'équipements
- Démarrage/pause/fin de mission
- Suivi de progression

### Scan & Inventaire
- Scan code-barres/QR code
- Saisie manuelle
- Recherche d'équipements
- Formulaire de vérification
- Prise de photos
- Géolocalisation GPS
- Notes et observations

### Mode hors-ligne
- Stockage local avec Drift/Hive
- File d'attente de synchronisation
- Synchronisation automatique/manuelle
- Gestion des conflits
- Indicateur de statut

### Reporting
- Statistiques de mission
- Équipements scannés
- Anomalies détectées
- Export de données

## State Management

L'application utilise **Riverpod** pour la gestion d'état:

```dart
// Provider example
@riverpod
class MissionNotifier extends _$MissionNotifier {
  @override
  Future<List<Mission>> build() async {
    return ref.read(missionRepositoryProvider).getMyMissions();
  }

  Future<void> startMission(int missionId) async {
    // Implementation
  }
}
```

## Gestion des données

### Local Storage
- **Hive**: Cache léger (settings, user data)
- **Drift**: Base de données SQL (offline data, sync queue)
- **flutter_secure_storage**: Credentials sécurisés

### Synchronisation
```dart
// Sync process
1. Detect network change
2. Queue pending operations
3. Process queue in order
4. Handle conflicts
5. Update local data
6. Notify UI
```

## Tests

### Tests unitaires
```bash
flutter test
```

### Tests de widgets
```bash
flutter test test/widgets/
```

### Tests d'intégration
```bash
flutter test integration_test/
```

### Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Déploiement

### Android

**Debug APK:**
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

**Release APK:**
```bash
flutter build apk --release --split-per-abi
# Output: build/app/outputs/flutter-apk/app-{arch}-release.apk
```

**App Bundle (Google Play):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS

**Build:**
```bash
flutter build ios --release
```

**Archive pour App Store:**
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace \
           -scheme Runner \
           -configuration Release \
           archive \
           -archivePath build/Runner.xcarchive
```

## Configuration Android

### Permissions (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### Min SDK: 21 (Android 5.0)
### Target SDK: 33 (Android 13)

## Configuration iOS

### Info.plist
```xml
<key>NSCameraUsageDescription</key>
<string>L'application a besoin d'accéder à la caméra pour scanner les codes-barres</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>L'application a besoin de votre localisation pour géolocaliser les équipements</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>L'application a besoin d'accéder aux photos</string>
```

### Min iOS Version: 12.0

## Troubleshooting

### Problème de build
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Problème de permissions
Vérifier que toutes les permissions sont déclarées dans AndroidManifest.xml / Info.plist

### Problème de synchronisation
Vérifier:
1. Connexion réseau
2. Configuration API GLPI
3. Token valide
4. Logs: `flutter logs`

## Support

- Documentation: [docs/](../docs/)
- Issues: GitHub Issues
- Email: support@example.com

## License

Propriétaire - Tous droits réservés

## Auteurs

- Équipe de développement GLPI Mobile

## Changelog

### Version 1.0.0 (2024-xx-xx)
- Version initiale
- Authentification GLPI
- Scan code-barres/QR
- Mode offline
- Synchronisation
- Gestion missions
- Photos et GPS
