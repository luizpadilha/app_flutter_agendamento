import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/agenda.dart';
import 'package:mybabernew/entity/horarios.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/enums/tipo.filtro.agenda.dart';
import 'package:mybabernew/modules/agenda/agenda.repository.dart';
import 'package:mybabernew/modules/pessoa/pessoa.controller.dart';
import 'package:mybabernew/modules/servico/servico.controller.dart';

class AgendaController extends Store<List<Agenda>> {
  final ServicoController servicoController = Modular.get();
  final PessoaController pessoaController = Modular.get();
  final AgendaRepository repo = Modular.get();

  Servico? servico;
  Pessoa? pessoa;
  DateTime? horario;
  DateTime data = DateTime.now();
  String id = '';
  DateTime dataInicial = DateTime.now();
  List<Servico> servicos = [];
  List<Pessoa> pessoas = [];
  List<Horarios> horarios = [];
  TipoFiltroAgenda? tipoFiltroAgenda;

  AgendaController() : super([]);

  Future<void> initForm() async {
    await atualizarPessoas();
    servicos = await servicoController.buscarServicosSemState();
    horarios = [];
  }

  Future<void> init() async {
    await atualizarPessoas();
    pessoa = null;
    tipoFiltroAgenda = null;
    dataInicial = DateTime.now();
    await buscarAgendas();
  }

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

  Future<void> buscarAgendasByPessoa() async {
    try {
      setLoading(true);
      List<Agenda> agendas = await repo.getAgendasByPessoa(pessoa!);
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
      await repo.salvarAgendas(id, horario!, pessoa!, servico!);
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

  void atribuirHorario(Horarios horarioVo) {
    try {
      setLoading(true);
      List<String> partes = horarioVo.horario!.split(':');
      int hour = int.parse(partes[0]);
      int minute = int.parse(partes[1]);
      this.horario = DateTime(
        data.year,
        data.month,
        data.day,
        hour,
        minute,
      );
    } finally {
      setLoading(false);
    }
  }

  bool isHorarioSelecionado(Horarios horarioVo) {
    if (horario == null) return false;
    List<String> partes = horarioVo.horario!.split(':');
    int hour = int.parse(partes[0]);
    int minute = int.parse(partes[1]);

    int minuteH = horario!.minute;
    int hourH = horario!.hour;

    return (hour == hourH && minute == minuteH);
  }

  void atualizarPagina() {
    update(state, force: true);
  }

  Future<void> atualizarPessoas() async {
    pessoas = await pessoaController.buscarPessoasSemState();
  }

  Future<void> atribuirPessoa(String idPessoa) async {
    pessoa = await pessoaController.buscarPessoa(idPessoa);
  }

  Future<void> buscarHorarios() async {
    try {
      setLoading(true);
      if (servico == null || servico!.id == null) return;
      horarios = await repo.getHorarios(servico!.id!, data);
      log('buscou');
    } on DioException catch (e, s) {
      log('Erro ao buscar horarios', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar horarios', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
