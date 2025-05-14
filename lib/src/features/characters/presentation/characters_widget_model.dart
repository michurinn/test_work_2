import 'dart:async';
import 'dart:developer';

import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_model.dart';
import 'package:effective_test_work/src/features/characters/presentation/characters_state.dart';
import 'package:effective_test_work/src/shared/failure.dart';
import 'package:effective_test_work/src/shared/result.dart';
import 'package:effective_test_work/src/shared/wm.dart';
import 'package:flutter/material.dart';

class CharactersWidgetModel<M extends CharactersModel> implements Wm {
  final M model;
  /// Хранит состояние избранных, для отображения иконки лайка на общем экране
  final ValueNotifier<Iterable<int>> _favorites = ValueNotifier([]);
  ValueNotifier<Iterable<int>> get favoritesListenable => _favorites;
  /// Флаг, что используется локальный источник данных
  final ValueNotifier<bool> useLocalData;
  /// Стейты общего экрана
  late final ValueNotifier<CharactersState> stateNotifier = ValueNotifier(
    CharactersState.loading([]),
  );
  /// Подписка на изменения списка Избранных из БД, для отображения лайков
  late StreamSubscription? favSub;
  /// Подписка на содержимое локально сохраненых пресонажей, если используется локальное хранилище
  late StreamSubscription? charSub;
  /// Используется для подгрузки следующей страницы
  late final ScrollController scrollController;

  

  CharactersWidgetModel({
    required this.model,
    required this.useLocalData,
  });

  @override
  initWm() {
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.offset ==
            scrollController.position.maxScrollExtent) {
          fetchData();
        }
      });
    if (useLocalData.value) {
      subscribeToDatabase();
    }
    useLocalData.addListener(
      () => useLocalData.value ? subscribeToDatabase() : unsubscribeFromDb(),
    );

    favSub = model.getFavoritesIds().listen(
      (event) => _favorites.value = event,
      onError: (error) {
        stateNotifier.value = CharactersState.error(
          Failure(
            description: error.toString(),
          ),
        );
      },
    );
    fetchData().ignore();
  }

  void subscribeToDatabase() {
    charSub = model.getCharactersStream().listen((event) {
      stateNotifier.value = LoadedCharactersState(
        data: event.toList(),
      );
    }, onError: (e) {
      stateNotifier.value = CharactersState.error(
        Failure(
          description: e.toString(),
        ),
      );
    });
  }

  void unsubscribeFromDb() {
    charSub?.cancel();
  }

  @override
  disposeWm() {
    charSub?.cancel();
    favSub?.cancel();
    _favorites.dispose();
    stateNotifier.dispose();
  }

  Future<void> fetchData() async {
    if (useLocalData.value) {
      /// При отображении локального хранилища не отправляются запросы
      return;
    } else {
      final previousData = stateNotifier.value.data ?? [];
      final response = switch (await model.getCharacters()) {
        ResultOk(:final data) =>
          LoadedCharactersState(data: previousData).update(data.characters),
        ResultError(:final err) => CharactersState.error(err),
        _ => null,
      };
      if (response != null) {
        stateNotifier.value = response;
      }
    }
  }

  void addFavorite(CharacterEntity entity) {
    model.addFavorites(entity);
  }

  @override
  void deactivate() {
    log('Deactivated');
  }

  @override
  void reassemble() {
    log('Reassembled');
  }
}
