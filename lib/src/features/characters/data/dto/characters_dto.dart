import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:flutter/material.dart';

@immutable
class CharactersDto {
  final Iterable<CharacterEntity> characters;
  final int? nextPage;

  const CharactersDto({required this.characters, required this.nextPage});
}
