import 'app_failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final AppFailure failure;

  const Failure(this.failure);
}
