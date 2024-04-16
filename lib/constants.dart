import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const BASE_URL = String.fromEnvironment('BASE_URL',
    defaultValue: "https://chamados.webpublico.com.br");

const BASE_URL_HOMOLOGACAO = String.fromEnvironment('BASE_URL',
    defaultValue: "http://localhost:8081");

const bool isProduction = bool.fromEnvironment('dart.vm.product');

get baseUrl => isProduction ? BASE_URL : BASE_URL_HOMOLOGACAO;


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}
