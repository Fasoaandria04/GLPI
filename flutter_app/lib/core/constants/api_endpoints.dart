/// API Endpoints pour GLPI Inventory Mobile
class ApiEndpoints {
  // Base
  static const String baseUrl = '/api';
  static const String apiVersion = 'v1';

  // Authentication
  static const String initSession = '/initSession';
  static const String killSession = '/killSession';
  static const String getMyProfiles = '/getMyProfiles';
  static const String getActiveProfile = '/getActiveProfile';
  static const String changeActiveProfile = '/changeActiveProfile';
  static const String getMyEntities = '/getMyEntities';
  static const String getActiveEntities = '/getActiveEntities';
  static const String changeActiveEntities = '/changeActiveEntities';
  static const String getFullSession = '/getFullSession';

  // Inventory Campaigns
  static const String campaigns = '/inventory/campaigns';
  static String getCampaign(int id) => '/inventory/campaigns/$id';
  static String getCampaignMissions(int id) => '/inventory/campaigns/$id/missions';
  static String getCampaignProgress(int id) => '/inventory/campaigns/$id/progress';

  // Missions
  static const String missions = '/inventory/missions';
  static const String myMissions = '/inventory/missions/my-missions';
  static String getMission(int id) => '/inventory/missions/$id';
  static String startMission(int id) => '/inventory/missions/$id/start';
  static String completeMission(int id) => '/inventory/missions/$id/complete';
  static String getMissionEquipmentList(int id) => '/inventory/missions/$id/equipment-list';
  static String syncMissionData(int id) => '/inventory/missions/$id/sync-data';

  // Equipment & Inventory
  static const String scanEquipment = '/inventory/scan';
  static const String verifyEquipment = '/inventory/equipment/verify';
  static const String updateEquipment = '/inventory/equipment/update';
  static const String createEquipment = '/inventory/equipment/create';
  static const String addPhoto = '/inventory/equipment/add-photo';
  static const String searchEquipment = '/inventory/search';
  static const String reportAnomaly = '/inventory/report-anomaly';

  // Computers (GLPI native)
  static const String computers = '/Computer';
  static String getComputer(int id) => '/Computer/$id';
  
  // Monitors
  static const String monitors = '/Monitor';
  static String getMonitor(int id) => '/Monitor/$id';

  // Printers
  static const String printers = '/Printer';
  static String getPrinter(int id) => '/Printer/$id';

  // Network Equipment
  static const String networkEquipments = '/NetworkEquipment';
  static String getNetworkEquipment(int id) => '/NetworkEquipment/$id';

  // Phones
  static const String phones = '/Phone';
  static String getPhone(int id) => '/Phone/$id';

  // Peripherals
  static const String peripherals = '/Peripheral';
  static String getPeripheral(int id) => '/Peripheral/$id';

  // Locations
  static const String locations = '/Location';
  static String getLocation(int id) => '/Location/$id';

  // Users
  static const String users = '/User';
  static String getUser(int id) => '/User/$id';

  // Groups
  static const String groups = '/Group';
  static String getGroup(int id) => '/Group/$id';

  // Manufacturers
  static const String manufacturers = '/Manufacturer';
  
  // Computer Models
  static const String computerModels = '/ComputerModel';

  // States
  static const String states = '/State';

  // Synchronization
  static const String syncBatch = '/inventory/sync/batch';
  static const String validateSync = '/inventory/sync/validate';
  static const String syncConflicts = '/inventory/sync/conflicts';
  static const String resolveSyncConflict = '/inventory/sync/resolve-conflict';

  // Reports
  static String campaignReport(int id) => '/inventory/reports/campaign/$id';
  static String missionReport(int id) => '/inventory/reports/mission/$id';
  static String technicianReport(int id) => '/inventory/reports/technician/$id';
  static String exportCampaign(int id) => '/inventory/exports/campaign/$id';

  // Documents
  static const String documents = '/Document';
  static String uploadDocument = '/Document';

  // Search
  static String search(String itemType) => '/search/$itemType';
  
  // List items with criteria
  static String listItems(String itemType) => '/$itemType';
}
