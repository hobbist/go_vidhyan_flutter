class UserInformation{
  String _name;
  String _mobileNumber;
  String get name => _name;
  int _framSize;

  set name(String name) =>_name = name;
  String get mobileNumber => _mobileNumber;
  set mobileNumber(String mobileNumber) => _mobileNumber = mobileNumber;
  int get framSize => _framSize;
  set framSize(int framSize) =>_framSize = framSize;
}