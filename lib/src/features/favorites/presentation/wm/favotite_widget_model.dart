import 'dart:async';
import 'dart:collection';

import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favorite_model.dart';
import 'package:effective_test_work/src/features/favorites/presentation/wm/favorite_state.dart';
import 'package:effective_test_work/src/shared/wm.dart';
import 'package:flutter/material.dart';

class FavoriteWidgetModel<M extends FavoriteModel> implements Wm {
  final M model;

  late final ValueNotifier<FavoriteState> stateNotifier = ValueNotifier(
    FavoriteState.loading(),
  );
  late final StreamSubscription favoritesSubscription;

  @override
  initWm() {
    favoritesSubscription = model.getFavoritesStream().listen(
      (data) {
        stateNotifier.value = FavoriteState.data(
          UnmodifiableListView(data),
        );
      },
    );
  }

  @override
  disposeWm() {
    favoritesSubscription.cancel();
    stateNotifier.dispose();
  }

  void addFavorite(CharacterEntity entity) {
    model.addFavorites(entity);
  }

  void deleteFavorite(int id) {
    model.deleteFavorite(id);
  }

  FavoriteWidgetModel({required this.model});

  @override
  void deactivate() {}

  @override
  void reassemble() {}
}
