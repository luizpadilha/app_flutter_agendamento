import 'package:intl/intl.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';

class Agenda {
  String? id;
  Pessoa? pessoa;
  DateTime? horario;
  Servico? servico;

  Agenda({
    this.id,
    this.pessoa,
    this.horario,
    this.servico,
  });

  Agenda.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '', 
        pessoa = Pessoa.fromJson(json['pessoa']),
        horario = DateTime.parse(json['horario']),
        servico = Servico.fromJson(json['servico']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'pessoa':  pessoa?.toJson(),
        'horario': horario,
        'servico': servico?.toJson(),
      };

  @override
  String toString() {
    return '${pessoa!.nome} - ${DateFormat('HH:mm').format(horario!)}';
  }
}
