class User {
  String? username;
  String? token;
  String? userId;
  DateTime? expiresIn;

  User({this.username, this.token, this.userId, this.expiresIn});

  User.fromJson(Map<String, dynamic> json) {
    username = json['user'];
    token = json['token'];
    expiresIn = DateTime.now().add(
      Duration(
        seconds: json['expiresIn'] as int,
      ),
    );
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.username;
    data['expiresIn'] = this.expiresIn;
    data['token'] = this.token;
    return data;
  }
}
