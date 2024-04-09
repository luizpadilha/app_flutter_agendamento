import 'package:brasil_fields/brasil_fields.dart';

class Servico {
  String? id;
  String? descricao;
  double? preco;

  Servico({
    this.id,
    this.descricao,
    this.preco,
  });

  Servico.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        descricao = json['descricao'] ?? '',
        preco = double.tryParse(json['preco'].toString()) ?? 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao!.trim(),
        'preco': preco,
      };

  @override
  String toString() {
    return '${UtilBrasilFields.obterReal(preco!)} - ${descricao!}';
  }
}
