import 'package:effective_test_work/src/features/characters/domain/entity/character_entity.dart';
import 'package:effective_test_work/src/shared/failure.dart';

sealed class CharactersState<T extends List<CharacterEntity>,
    E extends Failure> {
  abstract final T? data;
  abstract final E? failure;

  factory CharactersState.loading(T data) =>
      LoadingCharactersState<T, E>(data: data);
  factory CharactersState.data(T data) => LoadedCharactersState(data: data);
  factory CharactersState.error(E f) => ErrorCharactersState(failure: f);
}

final class LoadingCharactersState<T extends List<CharacterEntity>,
    E extends Failure> implements CharactersState<T, E> {
  @override
  final T data;

  LoadingCharactersState({required this.data});

  @override
  E? get failure => null;
}

final class LoadedCharactersState<T extends List<CharacterEntity>,
    E extends Failure> implements CharactersState<T, E> {
  @override
  final T data;

  LoadedCharactersState({required this.data});

  LoadedCharactersState update(Iterable<CharacterEntity> update) {
    return LoadedCharactersState(
      data: List.from(
        data..addAll(update),
      ),
    );
  }

  @override
  E? get failure => null;
}

final class ErrorCharactersState<T extends List<CharacterEntity>,
    E extends Failure> implements CharactersState<T, E> {
  @override
  final E failure;

  ErrorCharactersState({required this.failure});

  @override
  T? get data => null;
}

extension AddPage on CharactersState {
  CharactersState update(Iterable<CharacterEntity> update) {
    return switch (this) {
      LoadedCharactersState<List<CharacterEntity>, Failure>(:final data) =>
        LoadedCharactersState(
          data: List.from(
            data..addAll(update),
          ),
        ),
      _ => this,
    };
  }
}
