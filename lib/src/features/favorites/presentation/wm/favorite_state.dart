import 'dart:collection';

import 'package:effective_test_work/src/features/favorites/domain/entity/favorite_character_entity.dart';
import 'package:effective_test_work/src/shared/failure.dart';

sealed class FavoriteState<T extends UnmodifiableListView<FavoriteCharacterEntity>,
    E extends Failure> {
  ///FavoriteState._({this.data, this.failure});
  abstract final T? data;
  abstract final E? failure;

  factory FavoriteState.loading() => LoadingFavoriteState<T, E>();
  factory FavoriteState.data(T data) => LoadedFavoriteState(data: data);
  factory FavoriteState.error(E f) => ErrorFavoriteState(failure: f);
}

final class LoadingFavoriteState<T extends UnmodifiableListView<FavoriteCharacterEntity>,
    E extends Failure> implements FavoriteState<T, E> {
  @override
  T? get data => null;

  @override
  E? get failure => null;
}

final class LoadedFavoriteState<T extends UnmodifiableListView<FavoriteCharacterEntity>,
    E extends Failure> implements FavoriteState<T, E> {
  @override
  final T data;

  LoadedFavoriteState({required this.data});

  @override
  E? get failure => null;
}

final class ErrorFavoriteState<T extends UnmodifiableListView<FavoriteCharacterEntity>,
    E extends Failure> implements FavoriteState<T, E> {
  @override
  final E failure;

  ErrorFavoriteState({required this.failure});

  @override
  T? get data => null;
}
