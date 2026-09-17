/// A user-presentable failure.
///
/// Screens render [message] (and optionally [hint]) rather than a raw
/// exception string, which keeps stack traces out of the UI.
class AppFailure implements Exception {
  const AppFailure(this.message, {this.hint, this.cause});

  final String message;
  final String? hint;
  final Object? cause;

  @override
  String toString() => 'AppFailure($message)';
}

class DataFailure extends AppFailure {
  const DataFailure(super.message, {super.hint, super.cause});
}

class ContentFailure extends AppFailure {
  const ContentFailure(super.message, {super.hint, super.cause});
}
