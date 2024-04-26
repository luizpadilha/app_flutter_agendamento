class Grafico {
  double? valor;
  String? descricao;

  Grafico({this.valor, this.descricao});

  Grafico.fromJson(Map<String, dynamic> json) {
    valor = json['valor'] as double;
    descricao = json['descricao'];
  }
}
