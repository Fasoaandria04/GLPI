import 'package:equatable/equatable.dart';

enum EquipmentType {
  computer,
  monitor,
  printer,
  networkEquipment,
  phone,
  peripheral,
  unknown;

  static EquipmentType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'computer':
        return EquipmentType.computer;
      case 'monitor':
        return EquipmentType.monitor;
      case 'printer':
        return EquipmentType.printer;
      case 'networkequipment':
        return EquipmentType.networkEquipment;
      case 'phone':
        return EquipmentType.phone;
      case 'peripheral':
        return EquipmentType.peripheral;
      default:
        return EquipmentType.unknown;
    }
  }

  String toGlpiType() {
    switch (this) {
      case EquipmentType.computer:
        return 'Computer';
      case EquipmentType.monitor:
        return 'Monitor';
      case EquipmentType.printer:
        return 'Printer';
      case EquipmentType.networkEquipment:
        return 'NetworkEquipment';
      case EquipmentType.phone:
        return 'Phone';
      case EquipmentType.peripheral:
        return 'Peripheral';
      case EquipmentType.unknown:
        return 'Unknown';
    }
  }

  String get displayName {
    switch (this) {
      case EquipmentType.computer:
        return 'Ordinateur';
      case EquipmentType.monitor:
        return 'Écran';
      case EquipmentType.printer:
        return 'Imprimante';
      case EquipmentType.networkEquipment:
        return 'Équipement réseau';
      case EquipmentType.phone:
        return 'Téléphone';
      case EquipmentType.peripheral:
        return 'Périphérique';
      case EquipmentType.unknown:
        return 'Inconnu';
    }
  }
}

class Equipment extends Equatable {
  final int id;
  final String name;
  final EquipmentType itemType;
  final String? serialNumber;
  final String? inventoryNumber;
  final String? uuid;
  final int? entityId;
  final int? locationId;
  final int? userId;
  final int? groupId;
  final int? stateId;
  final int? manufacturerId;
  final int? modelId;
  final int? typeId;
  final String? comment;
  final String? contactName;
  final String? contactNumber;
  final DateTime? dateModified;
  final DateTime? dateCreation;
  
  // Related objects names (for display)
  final String? locationName;
  final String? userName;
  final String? stateName;
  final String? manufacturerName;
  final String? modelName;

  const Equipment({
    required this.id,
    required this.name,
    required this.itemType,
    this.serialNumber,
    this.inventoryNumber,
    this.uuid,
    this.entityId,
    this.locationId,
    this.userId,
    this.groupId,
    this.stateId,
    this.manufacturerId,
    this.modelId,
    this.typeId,
    this.comment,
    this.contactName,
    this.contactNumber,
    this.dateModified,
    this.dateCreation,
    this.locationName,
    this.userName,
    this.stateName,
    this.manufacturerName,
    this.modelName,
  });

  String get displayName => name;

  String get fullDescription {
    final parts = <String>[];
    if (manufacturerName != null) parts.add(manufacturerName!);
    if (modelName != null) parts.add(modelName!);
    if (serialNumber != null) parts.add('S/N: $serialNumber');
    return parts.join(' - ');
  }

  bool get hasLocation => locationId != null && locationId! > 0;
  bool get hasUser => userId != null && userId! > 0;
  bool get hasSerialNumber => serialNumber != null && serialNumber!.isNotEmpty;
  bool get hasInventoryNumber => inventoryNumber != null && inventoryNumber!.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        name,
        itemType,
        serialNumber,
        inventoryNumber,
        uuid,
        entityId,
        locationId,
        userId,
        groupId,
        stateId,
        manufacturerId,
        modelId,
        typeId,
        comment,
        contactName,
        contactNumber,
        dateModified,
        dateCreation,
        locationName,
        userName,
        stateName,
        manufacturerName,
        modelName,
      ];
}

class Computer extends Equipment {
  final String? cpu;
  final String? ram;
  final String? storage;
  final String? osName;
  final String? osVersion;

  const Computer({
    required super.id,
    required super.name,
    super.serialNumber,
    super.inventoryNumber,
    super.uuid,
    super.entityId,
    super.locationId,
    super.userId,
    super.groupId,
    super.stateId,
    super.manufacturerId,
    super.modelId,
    super.typeId,
    super.comment,
    super.contactName,
    super.contactNumber,
    super.dateModified,
    super.dateCreation,
    super.locationName,
    super.userName,
    super.stateName,
    super.manufacturerName,
    super.modelName,
    this.cpu,
    this.ram,
    this.storage,
    this.osName,
    this.osVersion,
  }) : super(itemType: EquipmentType.computer);

  String get specifications {
    final specs = <String>[];
    if (cpu != null) specs.add('CPU: $cpu');
    if (ram != null) specs.add('RAM: $ram');
    if (storage != null) specs.add('Stockage: $storage');
    if (osName != null) {
      specs.add(osVersion != null ? '$osName $osVersion' : osName!);
    }
    return specs.join(' | ');
  }

  @override
  List<Object?> get props => [...super.props, cpu, ram, storage, osName, osVersion];
}
