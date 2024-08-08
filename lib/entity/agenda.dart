import 'package:intl/intl.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';

class Agenda {
  String? id;
  Pessoa pessoa;
  DateTime horario;
  Servico servico;

  Agenda._({
    this.id,
    required this.pessoa,
    required this.horario,
    required this.servico,
  });

  static Future<Agenda> fromJson(Map<String, dynamic> json) async {
    return Agenda._(
      id: json['id'] ?? '',
      pessoa: Pessoa.fromJson(json['pessoa']),
      horario: DateTime.parse(json['horario']),
      servico: await Servico.fromJson(json['servico']),
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
      'id': id,
      'pessoa': pessoa.toJson(),
      'horario': horario,
      'servico': await servico.toJson(),
    };
  }

  @override
  String toString() {
    return '${pessoa.nome} - ${DateFormat('HH:mm').format(horario)}';
  }
}
