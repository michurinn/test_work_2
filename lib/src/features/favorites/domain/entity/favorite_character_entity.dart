import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:flutter/material.dart';

@immutable
class FavoriteCharacterEntity extends CharacterEntity {
  const FavoriteCharacterEntity({
    required super.id,
    required super.name,
    required super.status,
    required super.gender,
    required super.photoUrl,
  });
}
