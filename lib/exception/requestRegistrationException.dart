class RequestRegistrationException implements Exception{
  String _msg;
  String _code;

  RequestRegistrationException(this._msg);
  RequestRegistrationException.withCode(this._msg,this._code);

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get code => _code;

  set code(String value) {
    _code = value;
  }

}