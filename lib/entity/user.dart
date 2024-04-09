class User {
  String? username;
  String? token;
  String? userId;
  int? expiresIn;

  User({this.username, this.expiresIn});

  User.fromJson(Map<String, dynamic> json) {
    username = json['user'];
    token = json['token'];
    expiresIn = json['expiresIn'];
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
