class LoginFailureException implements Exception {
  String _message;
  LoginFailureException(this._message);
  String get message => _message;

  set message(String value) {
    _message = value;
  }
}