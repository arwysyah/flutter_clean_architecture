/// Generic exception class for handling custom exceptions.
abstract class ApiException implements Exception {
  final String? _prefix;
  final String? _message;

  ApiException(this._prefix, this._message);

  @override
  String toString() => '$_prefix :$_message}';
}

/// Exception class for unauthorized access errors.
class UnAuthorizedExceptions extends ApiException {
  final dynamic errorBody;

  UnAuthorizedExceptions(this.errorBody) : super('UnAuthorized', '$errorBody');
}

/// Exception class for network-related errors.
class NetworkException extends ApiException {
  final String? message;
  NetworkException(this.message) : super('Network Error', message);
}

/// Exception class for handling specific request errors with status codes.
class ErrorRequestException extends ApiException {
  final int errorCode;
  final dynamic errorBody;
  ErrorRequestException(this.errorCode, this.errorBody)
      : super('Error $errorCode', '$errorBody');
}
