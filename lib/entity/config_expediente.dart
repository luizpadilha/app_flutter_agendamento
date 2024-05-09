import 'package:flutter/material.dart';
import 'package:mybabernew/enums/dia_semana.dart';
import 'package:mybabernew/utils/time_day_util.dart';

class ConfigExpediente {
  String? id;
  String? idConfig;
  DiaSemana? diaSemana;
  TimeOfDay? inicioExpediente;
  TimeOfDay? finalExpediente;
  TimeOfDay? inicioAlmoco;
  TimeOfDay? finalAlmoco;

  ConfigExpediente({
    this.id,
    this.inicioExpediente,
    this.finalExpediente,
    this.inicioAlmoco,
    this.finalAlmoco,
  });

  ConfigExpediente.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        idConfig = json['idConfig'] ?? '',
        diaSemana = DiaSemana.stringToDiaSemana(json['diaSemana']),
        inicioExpediente = TimeDayUtil.converterTimeOfDay(json['inicioExpediente'] as String),
        finalExpediente = TimeDayUtil.converterTimeOfDay(json['finalExpediente'] as String),
        inicioAlmoco = TimeDayUtil.converterTimeOfDay(json['inicioAlmoco'] as String),
        finalAlmoco = TimeDayUtil.converterTimeOfDay(json['finalAlmoco'] as String);

  Map<String, dynamic> toJson() => {
    'id': id,
    'idConfig': idConfig,
    'diaSemana': diaSemana,
    'inicioExpediente': inicioExpediente,
    'finalExpediente': finalExpediente,
    'inicioAlmoco': inicioAlmoco,
    'finalAlmoco': finalAlmoco,
  };

}
