class Horarios {
  String? horario;
  bool? disponivel;

  Horarios({this.horario, this.disponivel});

  Horarios.fromJson(Map<String, dynamic> json) {
    horario = json['horario'] as String;
    disponivel = json['disponivel'] as bool;
  }
}
