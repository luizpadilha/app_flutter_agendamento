import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:mybabernew/utils/util.dart';

class Servico {
  String? id;
  String descricao;
  double preco;
  TimeOfDay tempo;
  File? image;

  Servico._({
    this.id,
    required this.descricao,
    required this.preco,
    required this.tempo,
    required this.image,
  });

  static Future<Servico> fromJson(Map<String, dynamic> json) async {
    File? image = await converterBase64ToFile(json['imageBase64']);
    return Servico._(
      id: json['id'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: double.tryParse(json['preco'].toString()) ?? 0.0,
      tempo: TimeOfDay(
        hour: (json['tempoHora'] ?? 0) as int,
        minute: (json['tempoMinuto'] ?? 0) as int,
      ),
      image: image,
    );
  }

  // Método toJson
  Future<Map<String, dynamic>> toJson() async {
    String? imageBase64 = await converterFileToBase64(image);
    return {
      'id': id,
      'descricao': descricao.trim(),
      'preco': preco,
      'tempo': '${tempo.hour}:${tempo.minute}',
      'imageBase64': imageBase64,
    };
  }


  @override
  String toString() {
    return '${UtilBrasilFields.obterReal(preco!)} - ${descricao!}';
  }
}
