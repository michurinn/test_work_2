import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/entity/favorite_character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/repositories/i_favorite_repository.dart';

class FavoriteModel {
  final IFavoriteRepository _repository;

  FavoriteModel(
    this._repository,
  );

  Stream<Iterable<FavoriteCharacterEntity>> getFavoritesStream() {
    return _repository.getFavoritesStream();
  }

  void addFavorites(CharacterEntity entity) {
    _repository.addToFavorites(entity);
  }
  void deleteFavorite(int id){
    _repository.deleteFavorite(id);
  }
}
