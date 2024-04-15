import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/exceptions/http_exception.dart';
import 'package:mybabernew/modules/agenda/agenda.repository.dart';

class AgendaController extends Store<List<Agenda>> {
  final AgendaRepository repo = Modular.get();

  Servico? servico;
  Pessoa? pessoa;
  DateTime horario = DateTime.now();
  String id = '';
  DateTime dataInicial = DateTime.now();

  AgendaController() : super([]);

  Future<void> buscarAgendas() async {
    try {
      setLoading(true);
      List<Agenda> agendas = await repo.getAgendas(dataInicial);
      update(agendas);
    } on DioException catch (e, s) {
      log('Erro ao buscar agenda', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar agenda', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> salvarAgendas() async {
    try {
      setLoading(true);
      await repo.salvarAgendas(id, horario, pessoa!, servico!);
    } on DioException catch (e, s) {
      log('Erro ao salvar agenda', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> removerAgenda(String idAgenda) async {
    try {
      setLoading(true);
      await repo.removerAgenda(idAgenda);
      await buscarAgendas();
    } on DioException catch (e, s) {
      log('Erro ao remover agenda', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void atualizarPagina() {
    update(state, force: true);
  }
}
