class User {
  String? username;
  String? token;
  String? userId;
  DateTime? userExpiresIn;
  DateTime? tokenExpiresIn;

  User({this.username, this.token, this.userId, this.userExpiresIn, this.tokenExpiresIn});

  User.fromJson(Map<String, dynamic> json) {
    username = json['user'];
    token = json['token'];
    userExpiresIn = DateTime.now().add(
      const Duration(
        hours: 20,
      ),
    );
    tokenExpiresIn = DateTime.now().add(
      Duration(
        seconds: json['expiresIn'] as int,
      ),
    );
    userId = json['userId'];
  }

}
