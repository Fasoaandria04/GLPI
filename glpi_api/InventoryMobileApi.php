<?php

/**
 * API REST Custom pour Application Mobile Inventaire GLPI
 * À intégrer dans plugins/inventorymobile/inc/api.class.php
 */

namespace GlpiPlugin\InventoryMobile;

use Session;
use CommonGLPI;
use Html;

class Api extends CommonGLPI {

    /**
     * Get technician missions
     * GET /api/inventory/missions/my-missions
     */
    public static function getMyMissions() {
        global $DB;

        Session::checkLoginUser();
        $userId = Session::getLoginUserID();
        
        $query = "SELECT m.*,
                         c.name as campaign_name,
                         c.status as campaign_status,
                         c.date_end as campaign_end_date
                  FROM glpi_plugin_inventorymobile_missions m
                  INNER JOIN glpi_plugin_inventorymobile_campaigns c ON c.id = m.campaigns_id
                  WHERE m.users_id = $userId
                  AND m.status IN ('assigned', 'in_progress', 'paused')
                  ORDER BY m.date_assigned DESC";
        
        $result = $DB->query($query);
        $missions = [];
        
        while ($data = $DB->fetchAssoc($result)) {
            $missions[] = self::formatMission($data);
        }
        
        return $missions;
    }

    /**
     * Get mission details with equipment list
     * GET /api/inventory/missions/{id}
     */
    public static function getMission($missionId) {
        global $DB;

        Session::checkLoginUser();
        
        // Verify access rights
        $mission = self::loadMission($missionId);
        if (!$mission || !self::canAccessMission($mission)) {
            return ['error' => 'Mission not found or access denied', 'code' => 404];
        }
        
        // Get mission details
        $missionData = self::formatMission($mission);
        
        // Get assigned locations
        $query = "SELECT l.id, l.name, l.completename, l.building, l.room
                  FROM glpi_locations l
                  INNER JOIN glpi_plugin_inventorymobile_mission_locations ml 
                    ON ml.locations_id = l.id
                  WHERE ml.missions_id = $missionId";
        
        $result = $DB->query($query);
        $locations = [];
        while ($data = $DB->fetchAssoc($result)) {
            $locations[] = $data;
        }
        $missionData['locations'] = $locations;
        
        return $missionData;
    }

    /**
     * Get equipment list for mission
     * GET /api/inventory/missions/{id}/equipment-list
     */
    public static function getMissionEquipmentList($missionId) {
        global $DB;

        Session::checkLoginUser();
        
        $mission = self::loadMission($missionId);
        if (!$mission || !self::canAccessMission($mission)) {
            return ['error' => 'Access denied', 'code' => 403];
        }
        
        // Get expected equipment
        $query = "SELECT e.*,
                         i.itemtype,
                         i.items_id,
                         CASE i.itemtype
                           WHEN 'Computer' THEN c.name
                           WHEN 'Monitor' THEN m.name
                           WHEN 'Printer' THEN p.name
                           WHEN 'NetworkEquipment' THEN n.name
                           WHEN 'Phone' THEN ph.name
                           WHEN 'Peripheral' THEN pe.name
                         END as item_name,
                         l.completename as location_name,
                         e.found,
                         inv.scanned_at
                  FROM glpi_plugin_inventorymobile_expected_items e
                  LEFT JOIN glpi_computers c ON e.itemtype = 'Computer' AND e.items_id = c.id
                  LEFT JOIN glpi_monitors m ON e.itemtype = 'Monitor' AND e.items_id = m.id
                  LEFT JOIN glpi_printers p ON e.itemtype = 'Printer' AND e.items_id = p.id
                  LEFT JOIN glpi_networkequipments n ON e.itemtype = 'NetworkEquipment' AND e.items_id = n.id
                  LEFT JOIN glpi_phones ph ON e.itemtype = 'Phone' AND e.items_id = ph.id
                  LEFT JOIN glpi_peripherals pe ON e.itemtype = 'Peripheral' AND e.items_id = pe.id
                  LEFT JOIN glpi_locations l ON e.locations_id = l.id
                  LEFT JOIN glpi_plugin_inventorymobile_items inv ON inv.id = e.inventoryitems_id
                  WHERE e.missions_id = $missionId
                  ORDER BY e.found ASC, l.completename, item_name";
        
        $result = $DB->query($query);
        $equipment = [];
        
        while ($data = $DB->fetchAssoc($result)) {
            $equipment[] = [
                'id' => $data['items_id'],
                'itemtype' => $data['itemtype'],
                'name' => $data['item_name'],
                'location' => $data['location_name'],
                'found' => (bool)$data['found'],
                'scanned_at' => $data['scanned_at']
            ];
        }
        
        return $equipment;
    }

    /**
     * Start mission
     * POST /api/inventory/missions/{id}/start
     */
    public static function startMission($missionId) {
        global $DB;

        Session::checkLoginUser();
        
        $mission = self::loadMission($missionId);
        if (!$mission || !self::canAccessMission($mission)) {
            return ['error' => 'Access denied', 'code' => 403];
        }
        
        if ($mission['status'] !== 'assigned') {
            return ['error' => 'Mission already started', 'code' => 400];
        }
        
        $now = date('Y-m-d H:i:s');
        $DB->update('glpi_plugin_inventorymobile_missions', [
            'status' => 'in_progress',
            'date_started' => $now,
            'date_mod' => $now
        ], ['id' => $missionId]);
        
        return ['success' => true, 'date_started' => $now];
    }

    /**
     * Scan equipment
     * POST /api/inventory/scan
     * Body: {
     *   "mission_id": 1,
     *   "scan_value": "ABC123",
     *   "scan_method": "barcode",
     *   "latitude": 48.8566,
     *   "longitude": 2.3522
     * }
     */
    public static function scanEquipment($data) {
        global $DB;

        Session::checkLoginUser();
        $userId = Session::getLoginUserID();
        
        $missionId = $data['mission_id'] ?? null;
        $scanValue = $data['scan_value'] ?? null;
        $scanMethod = $data['scan_method'] ?? 'manual';
        $latitude = $data['latitude'] ?? null;
        $longitude = $data['longitude'] ?? null;
        
        if (!$missionId || !$scanValue) {
            return ['error' => 'Missing required fields', 'code' => 400];
        }
        
        // Search for equipment by serial number or inventory number
        $equipment = self::searchEquipmentByCode($scanValue);
        
        if (!$equipment) {
            return [
                'found' => false,
                'scan_value' => $scanValue,
                'message' => 'Equipment not found in database'
            ];
        }
        
        // Check if already scanned in this mission
        $existing = $DB->request([
            'FROM' => 'glpi_plugin_inventorymobile_items',
            'WHERE' => [
                'missions_id' => $missionId,
                'items_id' => $equipment['id'],
                'itemtype' => $equipment['itemtype']
            ],
            'LIMIT' => 1
        ])->current();
        
        if ($existing) {
            return [
                'found' => true,
                'already_scanned' => true,
                'equipment' => self::formatEquipment($equipment),
                'scanned_at' => $existing['scanned_at']
            ];
        }
        
        // Record scan
        $now = date('Y-m-d H:i:s');
        $DB->insert('glpi_plugin_inventorymobile_items', [
            'missions_id' => $missionId,
            'items_id' => $equipment['id'],
            'itemtype' => $equipment['itemtype'],
            'scan_method' => $scanMethod,
            'scanned_value' => $scanValue,
            'scanned_at' => $now,
            'scanned_by' => $userId,
            'gps_latitude' => $latitude,
            'gps_longitude' => $longitude,
            'synced' => 1,
            'sync_at' => $now,
            'date_creation' => $now
        ]);
        
        // Update mission counters
        $DB->query("UPDATE glpi_plugin_inventorymobile_missions 
                    SET scanned_equipment = scanned_equipment + 1,
                        date_mod = '$now'
                    WHERE id = $missionId");
        
        // Mark as found in expected items
        $DB->update('glpi_plugin_inventorymobile_expected_items', [
            'found' => 1,
            'inventoryitems_id' => $DB->insertId()
        ], [
            'missions_id' => $missionId,
            'items_id' => $equipment['id'],
            'itemtype' => $equipment['itemtype']
        ]);
        
        return [
            'found' => true,
            'already_scanned' => false,
            'equipment' => self::formatEquipment($equipment),
            'inventory_item_id' => $DB->insertId()
        ];
    }

    /**
     * Update equipment information
     * POST /api/inventory/equipment/update
     */
    public static function updateEquipment($data) {
        global $DB;

        Session::checkLoginUser();
        
        $inventoryItemId = $data['inventory_item_id'] ?? null;
        $locationId = $data['location_id'] ?? null;
        $physicalState = $data['physical_state'] ?? null;
        $notes = $data['notes'] ?? null;
        
        if (!$inventoryItemId) {
            return ['error' => 'Missing inventory_item_id', 'code' => 400];
        }
        
        $updates = ['date_mod' => date('Y-m-d H:i:s')];
        
        if ($locationId !== null) $updates['locations_id'] = $locationId;
        if ($physicalState !== null) $updates['physical_state'] = $physicalState;
        if ($notes !== null) $updates['notes'] = $notes;
        
        $DB->update('glpi_plugin_inventorymobile_items', $updates, [
            'id' => $inventoryItemId
        ]);
        
        return ['success' => true];
    }

    /**
     * Report anomaly
     * POST /api/inventory/report-anomaly
     */
    public static function reportAnomaly($data) {
        global $DB;

        Session::checkLoginUser();
        
        $missionId = $data['mission_id'] ?? null;
        $inventoryItemId = $data['inventory_item_id'] ?? null;
        $anomalyType = $data['anomaly_type'] ?? 'other';
        $description = $data['description'] ?? '';
        $severity = $data['severity'] ?? 'medium';
        
        if (!$missionId || !$description) {
            return ['error' => 'Missing required fields', 'code' => 400];
        }
        
        $now = date('Y-m-d H:i:s');
        
        $DB->insert('glpi_plugin_inventorymobile_anomalies', [
            'missions_id' => $missionId,
            'inventoryitems_id' => $inventoryItemId,
            'anomaly_type' => $anomalyType,
            'severity' => $severity,
            'description' => $description,
            'status' => 'open',
            'date_creation' => $now
        ]);
        
        // Update counters
        $DB->query("UPDATE glpi_plugin_inventorymobile_missions 
                    SET anomalies_count = anomalies_count + 1,
                        date_mod = '$now'
                    WHERE id = $missionId");
        
        if ($inventoryItemId) {
            $DB->update('glpi_plugin_inventorymobile_items', [
                'is_anomaly' => 1,
                'anomaly_type' => $anomalyType
            ], ['id' => $inventoryItemId]);
        }
        
        return ['success' => true, 'anomaly_id' => $DB->insertId()];
    }

    /**
     * Batch synchronization
     * POST /api/inventory/sync/batch
     */
    public static function syncBatch($data) {
        global $DB;

        Session::checkLoginUser();
        $userId = Session::getLoginUserID();
        
        $missionId = $data['mission_id'] ?? null;
        $items = $data['items'] ?? [];
        
        if (!$missionId || empty($items)) {
            return ['error' => 'Missing data', 'code' => 400];
        }
        
        $startTime = time();
        $synced = 0;
        $failed = 0;
        $errors = [];
        
        foreach ($items as $item) {
            try {
                // Insert or update inventory item
                $result = self::syncInventoryItem($missionId, $item, $userId);
                if ($result['success']) {
                    $synced++;
                } else {
                    $failed++;
                    $errors[] = $result['error'];
                }
            } catch (\Exception $e) {
                $failed++;
                $errors[] = $e->getMessage();
            }
        }
        
        $duration = time() - $startTime;
        
        // Log sync
        $DB->insert('glpi_plugin_inventorymobile_sync_logs', [
            'missions_id' => $missionId,
            'users_id' => $userId,
            'sync_type' => 'batch',
            'items_synced' => $synced,
            'items_failed' => $failed,
            'sync_status' => $failed > 0 ? 'partial' : 'success',
            'error_message' => !empty($errors) ? json_encode($errors) : null,
            'sync_duration' => $duration,
            'date_sync' => date('Y-m-d H:i:s')
        ]);
        
        return [
            'success' => true,
            'synced' => $synced,
            'failed' => $failed,
            'errors' => $errors,
            'duration' => $duration
        ];
    }

    // ===== Helper Methods =====

    private static function loadMission($missionId) {
        global $DB;
        
        $result = $DB->request([
            'FROM' => 'glpi_plugin_inventorymobile_missions',
            'WHERE' => ['id' => $missionId],
            'LIMIT' => 1
        ]);
        
        return $result->current();
    }

    private static function canAccessMission($mission) {
        $userId = Session::getLoginUserID();
        
        // Check if user is assigned to this mission
        if ($mission['users_id'] == $userId) {
            return true;
        }
        
        // Check if user has admin rights
        if (Session::haveRight('plugin_inventorymobile', READ)) {
            return true;
        }
        
        return false;
    }

    private static function formatMission($data) {
        return [
            'id' => (int)$data['id'],
            'name' => $data['name'],
            'campaign_id' => (int)$data['campaigns_id'],
            'campaign_name' => $data['campaign_name'] ?? null,
            'technician_id' => (int)$data['users_id'],
            'entity_id' => (int)$data['entities_id'],
            'status' => $data['status'],
            'date_assigned' => $data['date_assigned'],
            'date_started' => $data['date_started'],
            'date_completed' => $data['date_completed'],
            'total_equipment' => (int)$data['total_equipment'],
            'scanned_equipment' => (int)$data['scanned_equipment'],
            'new_equipment' => (int)$data['new_equipment'],
            'missing_equipment' => (int)$data['missing_equipment'],
            'anomalies_count' => (int)$data['anomalies_count'],
            'notes' => $data['notes']
        ];
    }

    private static function searchEquipmentByCode($code) {
        global $DB;
        
        $itemTypes = ['Computer', 'Monitor', 'Printer', 'NetworkEquipment', 'Phone', 'Peripheral'];
        
        foreach ($itemTypes as $itemType) {
            $table = getTableForItemType($itemType);
            
            $result = $DB->request([
                'FROM' => $table,
                'WHERE' => [
                    'OR' => [
                        'serial' => $code,
                        'otherserial' => $code,
                        'uuid' => $code
                    ]
                ],
                'LIMIT' => 1
            ])->current();
            
            if ($result) {
                $result['itemtype'] = $itemType;
                return $result;
            }
        }
        
        return null;
    }

    private static function formatEquipment($data) {
        return [
            'id' => (int)$data['id'],
            'name' => $data['name'],
            'itemtype' => $data['itemtype'],
            'serial' => $data['serial'] ?? null,
            'otherserial' => $data['otherserial'] ?? null,
            'locations_id' => $data['locations_id'] ?? null,
            'users_id' => $data['users_id'] ?? null,
            'states_id' => $data['states_id'] ?? null
        ];
    }

    private static function syncInventoryItem($missionId, $item, $userId) {
        global $DB;
        
        $now = date('Y-m-d H:i:s');
        
        $data = [
            'missions_id' => $missionId,
            'items_id' => $item['equipment_id'] ?? null,
            'itemtype' => $item['equipment_type'],
            'scan_method' => $item['scan_method'],
            'scanned_value' => $item['scanned_value'] ?? null,
            'scanned_at' => $item['scanned_at'],
            'scanned_by' => $userId,
            'locations_id' => $item['location_id'] ?? null,
            'gps_latitude' => $item['gps_latitude'] ?? null,
            'gps_longitude' => $item['gps_longitude'] ?? null,
            'physical_state' => $item['physical_state'] ?? null,
            'is_anomaly' => $item['is_anomaly'] ? 1 : 0,
            'anomaly_type' => $item['anomaly_type'] ?? null,
            'notes' => $item['notes'] ?? null,
            'synced' => 1,
            'sync_at' => $now,
            'date_creation' => $item['scanned_at'],
            'date_mod' => $now
        ];
        
        $DB->insert('glpi_plugin_inventorymobile_items', $data);
        
        return ['success' => true, 'id' => $DB->insertId()];
    }
}
