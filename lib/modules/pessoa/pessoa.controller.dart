import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:mybabernew/entity/pessoa.dart';
import 'package:mybabernew/modules/pessoa/pessoa.repository.dart';

class PessoaController extends Store<List<Pessoa>> {
  final PessoaRepository repo = Modular.get();
  final nomeController = TextEditingController();
  final numeroController = TextEditingController();
  String id = '';

  PessoaController() : super([]);

  Future<void> buscarPessoas() async {
    try {
      setLoading(true);
      List<Pessoa> pessoas = await repo.getPessoas();
      update(pessoas);
    } on DioException catch (e, s) {
      log('Erro ao buscar pessoas', error: e, stackTrace: s);
      rethrow;
    } on Exception catch (e) {
      log('Erro ao buscar pessoas', error: e);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> salvarPessoas() async {
    try {
      setLoading(true);
      await repo.salvarPessoas(id, nomeController.text, numeroController.text);
    } on DioException catch (e, s) {
      log('Erro ao salvar pessoa', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> removerPessoa(String idServico) async {
    try {
      setLoading(true);
      await repo.removerPessoa(idServico);
      await buscarPessoas();
    } on DioException catch (e, s) {
      log('Erro ao remover pessoa', error: e, stackTrace: s);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
  
}
