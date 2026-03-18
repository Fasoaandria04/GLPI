-- Schema pour Application Mobile Inventaire GLPI
-- Compatible avec GLPI 11.x

-- Table des campagnes d'inventaire
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_campaigns` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `entities_id` int unsigned NOT NULL DEFAULT 0,
  `is_recursive` tinyint NOT NULL DEFAULT 0,
  `date_begin` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'planned',
  `created_by` int unsigned NOT NULL DEFAULT 0,
  `date_creation` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  `comment` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `entities_id` (`entities_id`),
  KEY `created_by` (`created_by`),
  KEY `status` (`status`),
  KEY `date_begin` (`date_begin`),
  KEY `date_end` (`date_end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table du périmètre des campagnes (locations)
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_campaign_locations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `campaigns_id` int unsigned NOT NULL,
  `locations_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_location` (`campaigns_id`, `locations_id`),
  KEY `campaigns_id` (`campaigns_id`),
  KEY `locations_id` (`locations_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des types d'équipements inclus dans les campagnes
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_campaign_itemtypes` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `campaigns_id` int unsigned NOT NULL,
  `itemtype` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_itemtype` (`campaigns_id`, `itemtype`),
  KEY `campaigns_id` (`campaigns_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des missions assignées aux techniciens
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_missions` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `campaigns_id` int unsigned NOT NULL,
  `users_id` int unsigned NOT NULL COMMENT 'Technicien assigné',
  `entities_id` int unsigned NOT NULL DEFAULT 0,
  `status` varchar(50) NOT NULL DEFAULT 'assigned',
  `date_assigned` datetime DEFAULT NULL,
  `date_started` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  `total_equipment` int NOT NULL DEFAULT 0,
  `scanned_equipment` int NOT NULL DEFAULT 0,
  `new_equipment` int NOT NULL DEFAULT 0,
  `missing_equipment` int NOT NULL DEFAULT 0,
  `anomalies_count` int NOT NULL DEFAULT 0,
  `notes` text DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campaigns_id` (`campaigns_id`),
  KEY `users_id` (`users_id`),
  KEY `entities_id` (`entities_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des locations assignées aux missions
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_mission_locations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `missions_id` int unsigned NOT NULL,
  `locations_id` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mission_location` (`missions_id`, `locations_id`),
  KEY `missions_id` (`missions_id`),
  KEY `locations_id` (`locations_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des équipements inventoriés
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `missions_id` int unsigned NOT NULL,
  `items_id` int unsigned DEFAULT NULL COMMENT 'ID de l équipement dans GLPI',
  `itemtype` varchar(100) NOT NULL,
  `scan_method` varchar(50) NOT NULL COMMENT 'barcode, qr, manual, search',
  `scanned_value` varchar(255) DEFAULT NULL COMMENT 'Valeur scannée',
  `scanned_at` datetime NOT NULL,
  `scanned_by` int unsigned NOT NULL,
  `locations_id` int unsigned DEFAULT NULL,
  `gps_latitude` decimal(10, 8) DEFAULT NULL,
  `gps_longitude` decimal(11, 8) DEFAULT NULL,
  `physical_state` varchar(50) DEFAULT NULL COMMENT 'new, good, used, defective, to_reform',
  `is_anomaly` tinyint NOT NULL DEFAULT 0,
  `anomaly_type` varchar(50) DEFAULT NULL COMMENT 'missing, unknown, inconsistent, damaged',
  `notes` text DEFAULT NULL,
  `synced` tinyint NOT NULL DEFAULT 0,
  `sync_at` datetime DEFAULT NULL,
  `sync_error` text DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `missions_id` (`missions_id`),
  KEY `items_id_itemtype` (`items_id`, `itemtype`),
  KEY `scanned_by` (`scanned_by`),
  KEY `locations_id` (`locations_id`),
  KEY `is_anomaly` (`is_anomaly`),
  KEY `synced` (`synced`),
  KEY `scanned_at` (`scanned_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des photos d'équipements
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_photos` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitems_id` int unsigned NOT NULL,
  `filename` varchar(255) NOT NULL,
  `filepath` varchar(500) NOT NULL,
  `filesize` int unsigned DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `gps_latitude` decimal(10, 8) DEFAULT NULL,
  `gps_longitude` decimal(11, 8) DEFAULT NULL,
  `taken_at` datetime DEFAULT NULL,
  `uploaded` tinyint NOT NULL DEFAULT 0,
  `date_creation` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventoryitems_id` (`inventoryitems_id`),
  KEY `uploaded` (`uploaded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des équipements attendus (liste de référence)
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_expected_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `campaigns_id` int unsigned NOT NULL,
  `missions_id` int unsigned DEFAULT NULL,
  `items_id` int unsigned NOT NULL,
  `itemtype` varchar(100) NOT NULL,
  `locations_id` int unsigned DEFAULT NULL,
  `found` tinyint NOT NULL DEFAULT 0,
  `inventoryitems_id` int unsigned DEFAULT NULL COMMENT 'Lien vers item inventorié',
  `date_creation` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campaigns_id` (`campaigns_id`),
  `missions_id` (`missions_id`),
  KEY `items_id_itemtype` (`items_id`, `itemtype`),
  KEY `found` (`found`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des anomalies détaillées
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_anomalies` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `missions_id` int unsigned NOT NULL,
  `inventoryitems_id` int unsigned DEFAULT NULL,
  `anomaly_type` varchar(50) NOT NULL,
  `severity` varchar(20) NOT NULL DEFAULT 'medium' COMMENT 'low, medium, high',
  `description` text NOT NULL,
  `resolution` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'open' COMMENT 'open, in_progress, resolved, rejected',
  `resolved_by` int unsigned DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  `date_mod` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `missions_id` (`missions_id`),
  KEY `inventoryitems_id` (`inventoryitems_id`),
  KEY `anomaly_type` (`anomaly_type`),
  KEY `status` (`status`),
  KEY `severity` (`severity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table de synchronisation (log)
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_sync_logs` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `missions_id` int unsigned NOT NULL,
  `users_id` int unsigned NOT NULL,
  `sync_type` varchar(50) NOT NULL COMMENT 'full, partial, auto',
  `items_synced` int NOT NULL DEFAULT 0,
  `items_failed` int NOT NULL DEFAULT 0,
  `sync_status` varchar(50) NOT NULL,
  `error_message` text DEFAULT NULL,
  `sync_duration` int DEFAULT NULL COMMENT 'En secondes',
  `date_sync` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `missions_id` (`missions_id`),
  KEY `users_id` (`users_id`),
  KEY `date_sync` (`date_sync`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des conflits de synchronisation
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_sync_conflicts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `inventoryitems_id` int unsigned NOT NULL,
  `items_id` int unsigned NOT NULL,
  `itemtype` varchar(100) NOT NULL,
  `conflict_type` varchar(50) NOT NULL COMMENT 'concurrent_update, deleted, inconsistent',
  `mobile_data` text NOT NULL COMMENT 'JSON des données mobile',
  `server_data` text NOT NULL COMMENT 'JSON des données serveur',
  `resolution` varchar(50) DEFAULT NULL COMMENT 'use_mobile, use_server, merge, manual',
  `resolved` tinyint NOT NULL DEFAULT 0,
  `resolved_by` int unsigned DEFAULT NULL,
  `resolved_at` datetime DEFAULT NULL,
  `date_creation` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inventoryitems_id` (`inventoryitems_id`),
  KEY `items_id_itemtype` (`items_id`, `itemtype`),
  KEY `resolved` (`resolved`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des statistiques par mission
CREATE TABLE IF NOT EXISTS `glpi_plugin_inventorymobile_statistics` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `missions_id` int unsigned NOT NULL,
  `date` date NOT NULL,
  `equipment_scanned` int NOT NULL DEFAULT 0,
  `time_spent` int NOT NULL DEFAULT 0 COMMENT 'En minutes',
  `photos_taken` int NOT NULL DEFAULT 0,
  `anomalies_found` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mission_date` (`missions_id`, `date`),
  KEY `missions_id` (`missions_id`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Vues pour faciliter les requêtes

-- Vue: Progression des campagnes
CREATE OR REPLACE VIEW `glpi_plugin_inventorymobile_campaigns_progress` AS
SELECT 
  c.id,
  c.name,
  c.status,
  c.date_begin,
  c.date_end,
  COUNT(DISTINCT m.id) as total_missions,
  COUNT(DISTINCT CASE WHEN m.status = 'completed' THEN m.id END) as completed_missions,
  COALESCE(SUM(m.total_equipment), 0) as total_equipment,
  COALESCE(SUM(m.scanned_equipment), 0) as scanned_equipment,
  COALESCE(SUM(m.new_equipment), 0) as new_equipment,
  COALESCE(SUM(m.missing_equipment), 0) as missing_equipment,
  COALESCE(SUM(m.anomalies_count), 0) as total_anomalies,
  CASE 
    WHEN COALESCE(SUM(m.total_equipment), 0) > 0 
    THEN ROUND(COALESCE(SUM(m.scanned_equipment), 0) * 100.0 / SUM(m.total_equipment), 2)
    ELSE 0 
  END as completion_rate
FROM glpi_plugin_inventorymobile_campaigns c
LEFT JOIN glpi_plugin_inventorymobile_missions m ON m.campaigns_id = c.id
GROUP BY c.id;

-- Vue: Missions actives par technicien
CREATE OR REPLACE VIEW `glpi_plugin_inventorymobile_technician_missions` AS
SELECT 
  m.id,
  m.name,
  m.users_id as technician_id,
  CONCAT(u.firstname, ' ', u.realname) as technician_name,
  c.name as campaign_name,
  m.status,
  m.date_assigned,
  m.date_started,
  m.total_equipment,
  m.scanned_equipment,
  CASE 
    WHEN m.total_equipment > 0 
    THEN ROUND(m.scanned_equipment * 100.0 / m.total_equipment, 2)
    ELSE 0 
  END as completion_rate,
  m.anomalies_count
FROM glpi_plugin_inventorymobile_missions m
INNER JOIN glpi_users u ON u.id = m.users_id
INNER JOIN glpi_plugin_inventorymobile_campaigns c ON c.id = m.campaigns_id;

-- Index additionnels pour performances
CREATE INDEX idx_campaigns_status_dates ON glpi_plugin_inventorymobile_campaigns(status, date_begin, date_end);
CREATE INDEX idx_missions_user_status ON glpi_plugin_inventorymobile_missions(users_id, status);
CREATE INDEX idx_items_mission_sync ON glpi_plugin_inventorymobile_items(missions_id, synced);
CREATE INDEX idx_anomalies_mission_status ON glpi_plugin_inventorymobile_anomalies(missions_id, status);
