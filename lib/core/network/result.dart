sealed class Result<T> {}

class Success<T> extends Result<T> {
  Success(this.value);
  final T value;
}

class ErrorState<T> extends Result<T> {
  ErrorState(this.error);
  final String error;
}
