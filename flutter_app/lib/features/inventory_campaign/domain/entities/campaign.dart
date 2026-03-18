import 'package:equatable/equatable.dart';

enum CampaignStatus {
  planned,
  inProgress,
  completed,
  cancelled;

  static CampaignStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return CampaignStatus.planned;
      case 'in_progress':
      case 'inprogress':
        return CampaignStatus.inProgress;
      case 'completed':
        return CampaignStatus.completed;
      case 'cancelled':
        return CampaignStatus.cancelled;
      default:
        return CampaignStatus.planned;
    }
  }

  String get displayName {
    switch (this) {
      case CampaignStatus.planned:
        return 'Planifiée';
      case CampaignStatus.inProgress:
        return 'En cours';
      case CampaignStatus.completed:
        return 'Terminée';
      case CampaignStatus.cancelled:
        return 'Annulée';
    }
  }
}

class Campaign extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int entityId;
  final DateTime dateBegin;
  final DateTime dateEnd;
  final CampaignStatus status;
  final int createdBy;
  final DateTime dateCreation;
  final DateTime? dateModification;
  final List<int>? locationIds;
  final List<String>? equipmentTypes;
  final int totalEquipment;
  final int scannedEquipment;
  final double completionRate;

  const Campaign({
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
    required this.totalEquipment,
    required this.scannedEquipment,
    required this.completionRate,
  });

  bool get isActive => status == CampaignStatus.inProgress;
  bool get isCompleted => status == CampaignStatus.completed;
  bool get isPending => status == CampaignStatus.planned;

  int get remainingEquipment => totalEquipment - scannedEquipment;

  String get progressPercentage => '${(completionRate * 100).toStringAsFixed(1)}%';

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

enum MissionStatus {
  assigned,
  inProgress,
  paused,
  completed;

  static MissionStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'assigned':
        return MissionStatus.assigned;
      case 'in_progress':
      case 'inprogress':
        return MissionStatus.inProgress;
      case 'paused':
        return MissionStatus.paused;
      case 'completed':
        return MissionStatus.completed;
      default:
        return MissionStatus.assigned;
    }
  }

  String get displayName {
    switch (this) {
      case MissionStatus.assigned:
        return 'Assignée';
      case MissionStatus.inProgress:
        return 'En cours';
      case MissionStatus.paused:
        return 'En pause';
      case MissionStatus.completed:
        return 'Terminée';
    }
  }
}

class Mission extends Equatable {
  final int id;
  final String name;
  final int campaignId;
  final int technicianId;
  final String? technicianName;
  final int entityId;
  final List<int>? assignedLocationIds;
  final MissionStatus status;
  final DateTime dateAssigned;
  final DateTime? dateStarted;
  final DateTime? dateCompleted;
  final int totalEquipment;
  final int scannedEquipment;
  final int newEquipment;
  final int missingEquipment;
  final int anomaliesCount;
  final String? notes;

  const Mission({
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

  bool get isActive => status == MissionStatus.inProgress;
  bool get isCompleted => status == MissionStatus.completed;
  bool get isPending => status == MissionStatus.assigned;
  bool get isPaused => status == MissionStatus.paused;

  double get completionRate {
    if (totalEquipment == 0) return 0.0;
    return scannedEquipment / totalEquipment;
  }

  String get progressPercentage => '${(completionRate * 100).toStringAsFixed(1)}%';

  int get remainingEquipment => totalEquipment - scannedEquipment;

  bool get hasAnomalies => anomaliesCount > 0 || missingEquipment > 0;

  Duration? get duration {
    if (dateStarted == null) return null;
    final end = dateCompleted ?? DateTime.now();
    return end.difference(dateStarted!);
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
