
abstract class Result<T> {
  const Result();

  factory Result.success(T value) = Success<T>;

  factory Result.failure(Exception exception) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failure<T>;
}

// success
class Success<T> extends Result<T> {
  final T value;

  Success(this.value);
}

// failure with exception
class Failure<T> extends Result<T> {
  final Exception exception;

  Failure(this.exception);
}
