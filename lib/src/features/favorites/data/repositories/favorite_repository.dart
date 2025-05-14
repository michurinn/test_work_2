import 'dart:async';
import 'dart:developer';

import 'package:effective_test_work/src/database/sqlite_database.dart';
import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/entity/favorite_character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/repositories/i_favorite_repository.dart';

class FavoriteRepository implements IFavoriteRepository {
  final SqliteDatabase db;

  FavoriteRepository({required this.db});

  @override
  Stream<Iterable<FavoriteCharacterEntity>> getFavoritesStream() {
    return handle(() => db.getFavoritesStream().stream);
  }

  @override
  void addToFavorites(CharacterEntity entity) {
    return handle(
      () => db.addFavorite(entity),
    );
  }

  @override
  void deleteFavorite(int id) {
    return handle(
      () => db.deleteFavorite(id),
    );
  }

  @override
  Stream<Iterable<int>> getFavoritesIds() {
    return handle(
      () => db.getFavoritesIds(),
    );
  }
}

T? handle<T>(Function fn) {
  return runZonedGuarded<T>(
    () => fn(),
    (error, stack) => log(error.toString()),
  );
}
