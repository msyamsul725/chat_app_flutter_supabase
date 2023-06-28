class UserData {
  final int? id;

  final String? username;

  UserData({this.id, this.username, l});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        username: json['username'],
      );
}
