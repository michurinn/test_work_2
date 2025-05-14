import 'dart:async';
import 'dart:developer';

import 'package:effective_test_work/src/database/sqlite_database.dart';
import 'package:effective_test_work/src/features/characters/data/dto/characters_dto.dart';
import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/characters/domain/repository/i_charatcers_repository.dart';
import 'package:effective_test_work/src/shared/request_operation.dart';

class CharactersLocalRepository implements ICharacterRepository {
  final SqliteDatabase db;

  CharactersLocalRepository({
    required this.db,
  });

  @override
  RequestOperation<CharactersDto> getCharacters([int page = 0]) async {
    throw UnimplementedError(
        'CharactersLocalRepository doesnt implement getCharacters method');
  }

  @override
  Stream<Iterable<CharacterEntity>> getCharactersStream() {
    return handle(
      () => db.getCharactersStream(),
    );
  }

  @override
  void insertCharacters(Iterable<CharacterEntity> data) {
    return handle(
      () => db.createCharacters(data),
    );
  }
}

T? handle<T>(Function fn) {
  return runZonedGuarded<T>(
    () => fn(),
    (error, stack) => log(error.toString(), name: 'Error'),
  );
}
