enum TipoFiltroAgenda {
  PESSOA('Pessoa');

  final String descricao;

  const TipoFiltroAgenda(
      this.descricao,
      );

  @override
  String toString() {
    return descricao;
  }
}
