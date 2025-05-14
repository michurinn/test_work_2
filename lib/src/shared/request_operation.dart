import 'package:effective_test_work/src/shared/failure.dart';
import 'package:effective_test_work/src/shared/result.dart';

typedef RequestOperation<T> = Future<Result<T, Failure>>;
