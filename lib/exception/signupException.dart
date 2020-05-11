class SignupException implements Exception{
  String _msg;

  SignupException(this._msg);

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

}