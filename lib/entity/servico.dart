import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Servico {
  String? id;
  String? descricao;
  double? preco;
  TimeOfDay? tempo;

  Servico({
    this.id,
    this.descricao,
    this.preco,
    this.tempo,
  });

  Servico.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        descricao = json['descricao'] ?? '',
        preco = double.tryParse(json['preco'].toString()) ?? 0.0,
        tempo = TimeOfDay(hour: (json['tempoHora'] ?? 0) as int, minute: (json['tempoMinuto'] ?? 0) as int);

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao!.trim(),
        'preco': preco,
        'tempo': '${tempo!.hour}:${tempo!.minute}',
      };

  @override
  String toString() {
    return '${UtilBrasilFields.obterReal(preco!)} - ${descricao!}';
  }
}
