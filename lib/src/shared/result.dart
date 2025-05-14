import 'package:effective_test_work/src/shared/failure.dart';

abstract class Result<T, E extends Failure> {
  abstract final T? data;
  abstract final E? error;

  factory Result.ok(T data) => ResultOk(result: data) ;

  factory Result.error(E error) => ResultError(err: error) ;
}

final class ResultOk<T, E extends Failure> implements Result<T,E> {
  ResultOk({required this.result});
  final T result;
  @override
  T get data => result;

  @override
  E? get error => null;
}

final class ResultError<T, E extends Failure> implements Result<T,E> {
  ResultError({required this.err});
  final E err;
  @override
  E get error => err;

  @override
  T? get data => null;
}
