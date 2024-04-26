enum TipoPeriodoGrafico {
  SEMANA,
  SEMESTRE1,
  SEMESTRE2;
}

extension TipoPeriodoGraficoExtension on TipoPeriodoGrafico {

  String get descricao {
    switch (this) {
      case TipoPeriodoGrafico.SEMANA:
        return 'Semana';
      case TipoPeriodoGrafico.SEMESTRE1:
        return '1º Semestre';
      case TipoPeriodoGrafico.SEMESTRE2:
        return '2º Semestre';
      default:
        return '';
    }
  }

}
