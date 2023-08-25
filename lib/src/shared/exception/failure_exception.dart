import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure_exception.freezed.dart';

/// Represents all possible app failures

@freezed
class Failure with _$Failure implements Exception {
  const Failure._();

  /// Represents the case where the expected data is empty or null.
  const factory Failure.empty() = _EmptyFailure;

  /// Represents the case where the data has an invalid format.
  const factory Failure.unprocessableEntity({required String message}) =
      _UnprocessableEntityFailure;

  /// Represents the situation where an authentication request is invalid.
  const factory Failure.unauthorized() = _UnauthorizedFailure;

  /// Represents the case of a user request error (status code 400).
  const factory Failure.badRequest() = _BadRequestFailure;

  /// Represents the case where a resource is not found on the server.
  const factory Failure.notFound() = _NotFoundFailure;

  /// Represents an error occurring from the server side.
  const factory Failure.serverError() = _ServerErrorFailure;

  /// Represents the case of no internet connection.
  const factory Failure.noInternetConnection() = _NoInternetConnectionFailure;

  /// Represents the case where a request exceeds the allowed timeout.
  const factory Failure.timeout() = _TimeoutFailure;

  String get error => this is _UnprocessableEntityFailure
      ? (this as _UnprocessableEntityFailure).message
      : '$this';
}
