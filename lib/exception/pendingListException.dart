class PendingListException implements Exception{
  String _msg;
  String _code;

  PendingListException(this._msg);
  PendingListException.withCode(this._msg,this._code);

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

  String get code => _code;

  set code(String value) {
    _code = value;
  }

}