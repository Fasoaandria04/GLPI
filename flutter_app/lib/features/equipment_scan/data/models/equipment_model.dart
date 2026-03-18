import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/equipment.dart';

part 'equipment_model.g.dart';

@JsonSerializable()
class EquipmentModel extends Equatable {
  final int id;
  final String name;
  
  @JsonKey(name: 'itemtype')
  final String itemType;
  
  @JsonKey(name: 'serial')
  final String? serialNumber;
  
  @JsonKey(name: 'otherserial')
  final String? inventoryNumber;
  
  @JsonKey(name: 'uuid')
  final String? uuid;
  
  @JsonKey(name: 'entities_id')
  final int? entityId;
  
  @JsonKey(name: 'locations_id')
  final int? locationId;
  
  @JsonKey(name: 'users_id')
  final int? userId;
  
  @JsonKey(name: 'groups_id')
  final int? groupId;
  
  @JsonKey(name: 'states_id')
  final int? stateId;
  
  @JsonKey(name: 'manufacturers_id')
  final int? manufacturerId;
  
  @JsonKey(name: 'computermodels_id')
  final int? modelId;
  
  @JsonKey(name: 'computertypes_id')
  final int? typeId;
  
  final String? comment;
  
  @JsonKey(name: 'contact')
  final String? contactName;
  
  @JsonKey(name: 'contact_num')
  final String? contactNumber;
  
  @JsonKey(name: 'date_mod')
  final String? dateModified;
  
  @JsonKey(name: 'date_creation')
  final String? dateCreation;
  
  // Relations (populated separately)
  final LocationModel? location;
  final UserModel? user;
  final StateModel? state;
  final ManufacturerModel? manufacturer;
  final ModelInfoModel? model;

  const EquipmentModel({
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
    this.location,
    this.user,
    this.state,
    this.manufacturer,
    this.model,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentModelToJson(this);

  Equipment toEntity() {
    return Equipment(
      id: id,
      name: name,
      itemType: EquipmentType.fromString(itemType),
      serialNumber: serialNumber,
      inventoryNumber: inventoryNumber,
      uuid: uuid,
      entityId: entityId,
      locationId: locationId,
      userId: userId,
      groupId: groupId,
      stateId: stateId,
      manufacturerId: manufacturerId,
      modelId: modelId,
      typeId: typeId,
      comment: comment,
      contactName: contactName,
      contactNumber: contactNumber,
      dateModified: dateModified != null ? DateTime.tryParse(dateModified!) : null,
      dateCreation: dateCreation != null ? DateTime.tryParse(dateCreation!) : null,
      locationName: location?.completename,
      userName: user?.name,
      stateName: state?.name,
      manufacturerName: manufacturer?.name,
      modelName: model?.name,
    );
  }

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
        location,
        user,
        state,
        manufacturer,
        model,
      ];
}

@JsonSerializable()
class ComputerModel extends EquipmentModel {
  @JsonKey(name: 'computermodels_id')
  final int? computerModelId;
  
  @JsonKey(name: 'computertypes_id')
  final int? computerTypeId;
  
  @JsonKey(name: 'operatingsystems_id')
  final int? operatingSystemId;
  
  final ComputerSpecsModel? specs;

  const ComputerModel({
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
    super.comment,
    super.contactName,
    super.contactNumber,
    super.dateModified,
    super.dateCreation,
    super.location,
    super.user,
    super.state,
    super.manufacturer,
    super.model,
    this.computerModelId,
    this.computerTypeId,
    this.operatingSystemId,
    this.specs,
  }) : super(itemType: 'Computer');

  factory ComputerModel.fromJson(Map<String, dynamic> json) =>
      _$ComputerModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ComputerModelToJson(this);

  @override
  List<Object?> get props => [...super.props, computerModelId, computerTypeId, operatingSystemId, specs];
}

@JsonSerializable()
class ComputerSpecsModel extends Equatable {
  @JsonKey(name: 'processor')
  final String? cpu;
  
  @JsonKey(name: 'memory')
  final String? ram;
  
  @JsonKey(name: 'storage')
  final String? storage;
  
  @JsonKey(name: 'os_name')
  final String? osName;
  
  @JsonKey(name: 'os_version')
  final String? osVersion;

  const ComputerSpecsModel({
    this.cpu,
    this.ram,
    this.storage,
    this.osName,
    this.osVersion,
  });

  factory ComputerSpecsModel.fromJson(Map<String, dynamic> json) =>
      _$ComputerSpecsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComputerSpecsModelToJson(this);

  @override
  List<Object?> get props => [cpu, ram, storage, osName, osVersion];
}

@JsonSerializable()
class LocationModel extends Equatable {
  final int id;
  final String name;
  final String? completename;
  final String? building;
  final String? room;
  
  @JsonKey(name: 'locations_id')
  final int? parentId;

  const LocationModel({
    required this.id,
    required this.name,
    this.completename,
    this.building,
    this.room,
    this.parentId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  @override
  List<Object?> get props => [id, name, completename, building, room, parentId];
}

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String name;
  final String? firstname;
  final String? realname;
  final String? phone;
  final String? email;

  const UserModel({
    required this.id,
    required this.name,
    this.firstname,
    this.realname,
    this.phone,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, name, firstname, realname, phone, email];
}

@JsonSerializable()
class StateModel extends Equatable {
  final int id;
  final String name;
  final String? completename;

  const StateModel({
    required this.id,
    required this.name,
    this.completename,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      _$StateModelFromJson(json);

  Map<String, dynamic> toJson() => _$StateModelToJson(this);

  @override
  List<Object?> get props => [id, name, completename];
}

@JsonSerializable()
class ManufacturerModel extends Equatable {
  final int id;
  final String name;

  const ManufacturerModel({
    required this.id,
    required this.name,
  });

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) =>
      _$ManufacturerModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManufacturerModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}

@JsonSerializable()
class ModelInfoModel extends Equatable {
  final int id;
  final String name;

  const ModelInfoModel({
    required this.id,
    required this.name,
  });

  factory ModelInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ModelInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelInfoModelToJson(this);

  @override
  List<Object?> get props => [id, name];
}
