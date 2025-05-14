import 'package:flutter/material.dart';

@immutable
class CharacterEntity {
  final int id;
  final String name;
  final Status status;
  final Gender gender;
  final String photoUrl;

  const CharacterEntity(
      {required this.id,
      required this.name,
      required this.status,
      required this.gender,
      required this.photoUrl});

  factory CharacterEntity.fromJson(Map<String, dynamic> json) {
    return CharacterEntity(
      gender: Gender.values.firstWhere(
        (element) =>
            element.name.toLowerCase() ==
            json['gender'].toString().toLowerCase(),
      ),
      id: json['id'],
      name: json['name'],
      photoUrl: json['image'],
      status: Status.values.firstWhere(
        (element) =>
            element.name.toLowerCase() ==
            json['status'].toString().toLowerCase(),
      ),
    );
  }
}

enum Status { dead, alive, unknown }

enum Gender { female, male, genderless, unknown }
