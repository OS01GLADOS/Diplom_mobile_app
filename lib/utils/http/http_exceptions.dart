class HttpException implements Exception {
  final _message;
  final _prefix;

  HttpException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class BadRequestException extends HttpException {
  BadRequestException([message]) : super(message, "Invalid Request: ");

  @override
  String toString() {
    return "$_message";
  }
}