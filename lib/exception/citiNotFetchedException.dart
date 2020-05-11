class CitiNotFetchedException implements Exception {
  String _message;
  CitiNotFetchedException(this._message);
  String get message => _message;
  set message(String value) {
    _message = value;
  }
}