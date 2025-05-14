import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/domain/entity/favorite_character_entity.dart';

abstract interface class IFavoriteRepository {
  Stream<Iterable<FavoriteCharacterEntity>> getFavoritesStream();
  Stream<Iterable<int>> getFavoritesIds();
  void addToFavorites(CharacterEntity entity);
  void deleteFavorite(int id);
}
