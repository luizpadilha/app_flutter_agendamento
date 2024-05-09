enum TipoPeriodoGrafico {
  SEMANA('Semana'),
  SEMESTRE1('1º Semestre'),
  SEMESTRE2('2º Semestre');

  final String descricao;

  const TipoPeriodoGrafico(
    this.descricao,
  );

  @override
  String toString() {
    return descricao;
  }
}
