import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/campaign.dart';

part 'campaign_model.g.dart';

@JsonSerializable()
class CampaignModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  
  @JsonKey(name: 'entities_id')
  final int entityId;
  
  @JsonKey(name: 'date_begin')
  final String dateBegin;
  
  @JsonKey(name: 'date_end')
  final String dateEnd;
  
  final String status;
  
  @JsonKey(name: 'created_by')
  final int createdBy;
  
  @JsonKey(name: 'date_creation')
  final String dateCreation;
  
  @JsonKey(name: 'date_mod')
  final String? dateModification;
  
  // Scope
  @JsonKey(name: 'locations_id')
  final List<int>? locationIds;
  
  @JsonKey(name: 'equipment_types')
  final List<String>? equipmentTypes;
  
  // Progress
  @JsonKey(name: 'total_equipment')
  final int? totalEquipment;
  
  @JsonKey(name: 'scanned_equipment')
  final int? scannedEquipment;
  
  @JsonKey(name: 'completion_rate')
  final double? completionRate;

  const CampaignModel({
    required this.id,
    required this.name,
    this.description,
    required this.entityId,
    required this.dateBegin,
    required this.dateEnd,
    required this.status,
    required this.createdBy,
    required this.dateCreation,
    this.dateModification,
    this.locationIds,
    this.equipmentTypes,
    this.totalEquipment,
    this.scannedEquipment,
    this.completionRate,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignModelToJson(this);

  Campaign toEntity() {
    return Campaign(
      id: id,
      name: name,
      description: description,
      entityId: entityId,
      dateBegin: DateTime.parse(dateBegin),
      dateEnd: DateTime.parse(dateEnd),
      status: CampaignStatus.fromString(status),
      createdBy: createdBy,
      dateCreation: DateTime.parse(dateCreation),
      dateModification: dateModification != null 
          ? DateTime.parse(dateModification!) 
          : null,
      locationIds: locationIds,
      equipmentTypes: equipmentTypes,
      totalEquipment: totalEquipment ?? 0,
      scannedEquipment: scannedEquipment ?? 0,
      completionRate: completionRate ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        entityId,
        dateBegin,
        dateEnd,
        status,
        createdBy,
        dateCreation,
        dateModification,
        locationIds,
        equipmentTypes,
        totalEquipment,
        scannedEquipment,
        completionRate,
      ];
}

@JsonSerializable()
class MissionModel extends Equatable {
  final int id;
  final String name;
  
  @JsonKey(name: 'campaign_id')
  final int campaignId;
  
  @JsonKey(name: 'technician_id')
  final int technicianId;
  
  @JsonKey(name: 'technician_name')
  final String? technicianName;
  
  @JsonKey(name: 'entities_id')
  final int entityId;
  
  @JsonKey(name: 'locations_id')
  final List<int>? assignedLocationIds;
  
  final String status;
  
  @JsonKey(name: 'date_assigned')
  final String dateAssigned;
  
  @JsonKey(name: 'date_started')
  final String? dateStarted;
  
  @JsonKey(name: 'date_completed')
  final String? dateCompleted;
  
  // Progress
  @JsonKey(name: 'total_equipment')
  final int totalEquipment;
  
  @JsonKey(name: 'scanned_equipment')
  final int scannedEquipment;
  
  @JsonKey(name: 'new_equipment')
  final int newEquipment;
  
  @JsonKey(name: 'missing_equipment')
  final int missingEquipment;
  
  @JsonKey(name: 'anomalies_count')
  final int anomaliesCount;
  
  final String? notes;

  const MissionModel({
    required this.id,
    required this.name,
    required this.campaignId,
    required this.technicianId,
    this.technicianName,
    required this.entityId,
    this.assignedLocationIds,
    required this.status,
    required this.dateAssigned,
    this.dateStarted,
    this.dateCompleted,
    required this.totalEquipment,
    required this.scannedEquipment,
    required this.newEquipment,
    required this.missingEquipment,
    required this.anomaliesCount,
    this.notes,
  });

  factory MissionModel.fromJson(Map<String, dynamic> json) =>
      _$MissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MissionModelToJson(this);

  Mission toEntity() {
    return Mission(
      id: id,
      name: name,
      campaignId: campaignId,
      technicianId: technicianId,
      technicianName: technicianName,
      entityId: entityId,
      assignedLocationIds: assignedLocationIds,
      status: MissionStatus.fromString(status),
      dateAssigned: DateTime.parse(dateAssigned),
      dateStarted: dateStarted != null ? DateTime.parse(dateStarted!) : null,
      dateCompleted: dateCompleted != null ? DateTime.parse(dateCompleted!) : null,
      totalEquipment: totalEquipment,
      scannedEquipment: scannedEquipment,
      newEquipment: newEquipment,
      missingEquipment: missingEquipment,
      anomaliesCount: anomaliesCount,
      notes: notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        campaignId,
        technicianId,
        technicianName,
        entityId,
        assignedLocationIds,
        status,
        dateAssigned,
        dateStarted,
        dateCompleted,
        totalEquipment,
        scannedEquipment,
        newEquipment,
        missingEquipment,
        anomaliesCount,
        notes,
      ];
}

@JsonSerializable()
class InventoryItemModel extends Equatable {
  final int? id;
  
  @JsonKey(name: 'mission_id')
  final int missionId;
  
  @JsonKey(name: 'equipment_id')
  final int? equipmentId;
  
  @JsonKey(name: 'equipment_type')
  final String equipmentType;
  
  @JsonKey(name: 'scan_method')
  final String scanMethod;
  
  @JsonKey(name: 'scanned_at')
  final String scannedAt;
  
  @JsonKey(name: 'location_id')
  final int? locationId;
  
  @JsonKey(name: 'gps_latitude')
  final double? gpsLatitude;
  
  @JsonKey(name: 'gps_longitude')
  final double? gpsLongitude;
  
  @JsonKey(name: 'physical_state')
  final String? physicalState;
  
  final String? notes;
  
  @JsonKey(name: 'is_anomaly')
  final bool isAnomaly;
  
  @JsonKey(name: 'anomaly_type')
  final String? anomalyType;
  
  @JsonKey(name: 'photo_paths')
  final List<String>? photoPaths;
  
  @JsonKey(name: 'synced')
  final bool synced;
  
  @JsonKey(name: 'sync_error')
  final String? syncError;

  const InventoryItemModel({
    this.id,
    required this.missionId,
    this.equipmentId,
    required this.equipmentType,
    required this.scanMethod,
    required this.scannedAt,
    this.locationId,
    this.gpsLatitude,
    this.gpsLongitude,
    this.physicalState,
    this.notes,
    this.isAnomaly = false,
    this.anomalyType,
    this.photoPaths,
    this.synced = false,
    this.syncError,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        missionId,
        equipmentId,
        equipmentType,
        scanMethod,
        scannedAt,
        locationId,
        gpsLatitude,
        gpsLongitude,
        physicalState,
        notes,
        isAnomaly,
        anomalyType,
        photoPaths,
        synced,
        syncError,
      ];
}
