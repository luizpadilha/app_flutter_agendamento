class Config {
  String? id;

  Config({
    this.id,
  });

  Config.fromJson(Map<String, dynamic> json) : id = json['id'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
