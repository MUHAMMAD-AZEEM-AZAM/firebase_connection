library myGlobals;

late String? _userID; // Your global variable

String? get userID => _userID;

set userID(String? value) {
  _userID = value;
  print(_userID);
}
