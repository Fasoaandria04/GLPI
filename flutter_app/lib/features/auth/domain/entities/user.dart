import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String? firstname;
  final String? realname;
  final String username;
  final String? email;
  final String? phone;
  final String? mobile;
  final String? apiToken;
  final String? sessionToken;
  final List<Profile>? profiles;
  final List<Entity>? entities;
  final Profile? activeProfile;
  final Entity? activeEntity;

  const User({
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

  String get displayName {
    if (firstname != null && realname != null) {
      return '$firstname $realname';
    }
    return name;
  }

  bool get hasMultipleEntities => entities != null && entities!.length > 1;
  bool get hasMultipleProfiles => profiles != null && profiles!.length > 1;

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

class Profile extends Equatable {
  final int id;
  final String name;
  final String? interface;
  final bool isDefault;

  const Profile({
    required this.id,
    required this.name,
    this.interface,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, name, interface, isDefault];
}

class Entity extends Equatable {
  final int id;
  final String name;
  final String? completename;
  final int? level;
  final int? parentId;
  final bool isRecursive;

  const Entity({
    required this.id,
    required this.name,
    this.completename,
    this.level,
    this.parentId,
    this.isRecursive = false,
  });

  String get displayName => completename ?? name;

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
