class Pessoa {
  String? id;
  String? nome;
  String? numero;

  Pessoa({
    this.id,
    this.nome,
    this.numero,
  });

  Pessoa.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        nome = json['nome'] ?? '',
        numero = json['numero'] ?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome!.trim(),
    'numero': numero,
  };

  @override
  String toString() {
    return '${numero!} - ${nome!}';
  }
}
