class User {
  String _username;
  String _authToken;
  User(this._username, this._authToken);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._authToken = obj["authToken"];
  }

  String get username => _username;
  String get authToken => _authToken;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["authToken"] = _authToken;

    return map;
  }
}