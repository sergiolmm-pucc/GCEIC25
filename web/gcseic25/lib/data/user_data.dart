class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() => _instance;

  UserData._internal();

  String? username;
  String? email;
}