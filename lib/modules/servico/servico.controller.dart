import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/servico.dart';
import 'package:mybabernew/modules/servico/servico.repository.dart';

class ServicoController extends Store<List<Servico>> {
  final ServicoRepository repo = Modular.get();
  final descricaoController = TextEditingController();
  final precoController = TextEditingController();
  String id = '';

  ServicoController() : super([]);

  Future<void> buscarServicos() async {
    try {
      setLoading(true);
      List<Servico> servicos = await repo.getServicos();
      update(servicos);
    } on DioException catch (e, s) {
      log('Erro ao buscar servidores', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar servidores', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> salvarServicos() async {
    try {
      setLoading(true);
      await repo.salvarServicos(id, descricaoController.text,
          UtilBrasilFields.converterMoedaParaDouble(precoController.text));
    } on DioException catch (e, s) {
      log('Erro ao salvar serviço', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> removerServico(String idServico) async {
    try {
      setLoading(true);
      await repo.removerServico(idServico);
      await buscarServicos();
    } on DioException catch (e, s) {
      log('Erro ao remover serviço', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
