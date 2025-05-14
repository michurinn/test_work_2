import 'dart:developer';

import 'package:effective_test_work/src/features/characters/data/dto/characters_dto.dart';
import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/characters/domain/mixin/characters_paginator.dart';
import 'package:effective_test_work/src/features/characters/domain/repository/i_charatcers_repository.dart';
import 'package:effective_test_work/src/features/favorites/domain/repositories/i_favorite_repository.dart';
import 'package:effective_test_work/src/shared/request_operation.dart';
import 'package:effective_test_work/src/shared/result.dart';

class CharactersModel with CharactersPaginator {
  final ICharacterRepository _repository;
  final IFavoriteRepository _favoriteRepository;
  CharactersModel({
    required ICharacterRepository repository,
    required IFavoriteRepository favoriteRepository,
  })  : _repository = repository,
        _favoriteRepository = favoriteRepository;

  RequestOperation<CharactersDto> getCharacters() async {
    final result = await _repository.getCharacters(nextPage);
    if (result is ResultOk && result.data?.nextPage != null) {
      nextPage = result.data!.nextPage!;
      _repository.insertCharacters(result.data!.characters);
      // log('Next page updated: $nextPage',
      //     name: 'CharactersPaginator', level: 2000);
    }

    return result;
  }

  Stream<Iterable<CharacterEntity>> getCharactersStream() {
    return _repository.getCharactersStream();
  }

  Stream<Iterable<int>> getFavoritesIds() {
    return _favoriteRepository.getFavoritesIds();
  }

  Future<void> readDataToDatabase() async {
    final result = await _repository.getCharacters(nextPage);
    // if (result is ResultOk && result.data?.nextPage != null) {
    //    log('Next page updated: $nextPage',
    //       name: 'CharactersPaginator', level: 2000);
    // }
    if (result is ResultOk && result.data?.characters != null) {
      _repository.insertCharacters(result.data!.characters);
    }
  }

  void addFavorites(CharacterEntity entity) {
    _favoriteRepository.addToFavorites(entity);
  }
}
