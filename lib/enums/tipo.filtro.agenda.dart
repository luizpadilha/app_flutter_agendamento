enum TipoFiltroAgenda {
  PESSOA('Cliente');

  final String descricao;

  const TipoFiltroAgenda(
      this.descricao,
      );

  @override
  String toString() {
    return descricao;
  }
}
