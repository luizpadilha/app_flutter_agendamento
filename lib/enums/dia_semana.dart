enum DiaSemana {
  DOMINGO('Domingo'),
  SEGUNDA('Segunda-Feira'),
  TERCA('Terça-Feira'),
  QUARTA('Quarta-Feira'),
  QUINTA('Quinta-Feira'),
  SEXTA('Sexta-Feira'),
  SABADO('Sábado');

  final String descricao;

  const DiaSemana(
    this.descricao,
  );

  @override
  String toString() {
    return descricao;
  }

  static DiaSemana stringToDiaSemana(String dia) {
    return DiaSemana.values.firstWhere((e) => e.name == dia);
  }
}
