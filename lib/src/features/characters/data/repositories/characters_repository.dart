import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:effective_test_work/src/database/sqlite_database.dart';
import 'package:effective_test_work/src/features/characters/data/dto/characters_dto.dart';
import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/characters/domain/repository/i_charatcers_repository.dart';
import 'package:effective_test_work/src/shared/extensions/get_next_page_numner.dart';
import 'package:effective_test_work/src/shared/failure.dart';
import 'package:effective_test_work/src/shared/request_operation.dart';
import 'package:effective_test_work/src/shared/result.dart';

class CharactersRepository implements ICharacterRepository {
  final Dio dio;
  final SqliteDatabase db;

  CharactersRepository({
    required this.dio,
    required this.db,
  });

  @override
  RequestOperation<CharactersDto> getCharacters([int page = 0]) async {
    try {
      final response =
          await dio.get('character', queryParameters: {'page': page});
      return Result.ok(
        CharactersDto(
          characters: (response.data['results'] as List)
              .map<CharacterEntity>((e) => CharacterEntity.fromJson(e)),
          nextPage:
              response.data['info']['next'].toString().getNextPageNumber(),
        ),
      );
    } on Exception catch (e) {
      return Result.error(
        Failure(
          description: e.toString(),
        ),
      );
    }
  }

  @override
  Stream<Iterable<CharacterEntity>> getCharactersStream() {
    return handle(() => db.getCharactersStream());
  }

  @override
  void insertCharacters(Iterable<CharacterEntity> data) {
    db.createCharacters(data);
  }
}

T? handle<T>(Function fn) {
  return runZonedGuarded<T>(
    () => fn(),
    (error, stack) => log(error.toString(), name: 'Error'),
  );
}
