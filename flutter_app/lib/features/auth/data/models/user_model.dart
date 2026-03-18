import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String name;
  final String? firstname;
  final String? realname;
  final String username;
  final String? email;
  final String? phone;
  final String? mobile;
  
  @JsonKey(name: 'api_token')
  final String? apiToken;
  
  @JsonKey(name: 'session_token')
  final String? sessionToken;
  
  final List<ProfileModel>? profiles;
  final List<EntityModel>? entities;
  
  @JsonKey(name: 'active_profile')
  final ProfileModel? activeProfile;
  
  @JsonKey(name: 'active_entity')
  final EntityModel? activeEntity;

  const UserModel({
    required this.id,
    required this.name,
    this.firstname,
    this.realname,
    required this.username,
    this.email,
    this.phone,
    this.mobile,
    this.apiToken,
    this.sessionToken,
    this.profiles,
    this.entities,
    this.activeProfile,
    this.activeEntity,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() {
    return User(
      id: id,
      name: name,
      firstname: firstname,
      realname: realname,
      username: username,
      email: email,
      phone: phone,
      mobile: mobile,
      apiToken: apiToken,
      sessionToken: sessionToken,
      profiles: profiles?.map((p) => p.toEntity()).toList(),
      entities: entities?.map((e) => e.toEntity()).toList(),
      activeProfile: activeProfile?.toEntity(),
      activeEntity: activeEntity?.toEntity(),
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      firstname: user.firstname,
      realname: user.realname,
      username: user.username,
      email: user.email,
      phone: user.phone,
      mobile: user.mobile,
      apiToken: user.apiToken,
      sessionToken: user.sessionToken,
      profiles: user.profiles?.map((p) => ProfileModel.fromEntity(p)).toList(),
      entities: user.entities?.map((e) => EntityModel.fromEntity(e)).toList(),
      activeProfile: user.activeProfile != null 
          ? ProfileModel.fromEntity(user.activeProfile!)
          : null,
      activeEntity: user.activeEntity != null
          ? EntityModel.fromEntity(user.activeEntity!)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        firstname,
        realname,
        username,
        email,
        phone,
        mobile,
        apiToken,
        sessionToken,
        profiles,
        entities,
        activeProfile,
        activeEntity,
      ];
}

@JsonSerializable()
class ProfileModel extends Equatable {
  final int id;
  final String name;
  final String? interface;
  
  @JsonKey(name: 'is_default')
  final bool? isDefault;

  const ProfileModel({
    required this.id,
    required this.name,
    this.interface,
    this.isDefault,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  Profile toEntity() {
    return Profile(
      id: id,
      name: name,
      interface: interface,
      isDefault: isDefault ?? false,
    );
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      name: profile.name,
      interface: profile.interface,
      isDefault: profile.isDefault,
    );
  }

  @override
  List<Object?> get props => [id, name, interface, isDefault];
}

@JsonSerializable()
class EntityModel extends Equatable {
  final int id;
  final String name;
  final String? completename;
  final int? level;
  
  @JsonKey(name: 'entities_id')
  final int? parentId;
  
  @JsonKey(name: 'is_recursive')
  final bool? isRecursive;

  const EntityModel({
    required this.id,
    required this.name,
    this.completename,
    this.level,
    this.parentId,
    this.isRecursive,
  });

  factory EntityModel.fromJson(Map<String, dynamic> json) =>
      _$EntityModelFromJson(json);

  Map<String, dynamic> toJson() => _$EntityModelToJson(this);

  Entity toEntity() {
    return Entity(
      id: id,
      name: name,
      completename: completename,
      level: level,
      parentId: parentId,
      isRecursive: isRecursive ?? false,
    );
  }

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      completename: entity.completename,
      level: entity.level,
      parentId: entity.parentId,
      isRecursive: entity.isRecursive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        completename,
        level,
        parentId,
        isRecursive,
      ];
}
