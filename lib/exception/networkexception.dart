class NetworkFailureException implements Exception{
  String _msg;

  NetworkFailureException(this._msg);

  String get msg => _msg;

  set msg(String value) {
    _msg = value;
  }

}