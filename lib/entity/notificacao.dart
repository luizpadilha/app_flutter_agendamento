class Notificacao {
  String? id;
  String? titulo;
  String? descricao;

  Notificacao({this.id, this.titulo, this.descricao});

  Notificacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    return data;
  }
}
