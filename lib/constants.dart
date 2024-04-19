import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const BASE_URL = String.fromEnvironment('BASE_URL',
    defaultValue: "https://chamados.webpublico.com.br");

const BASE_URL_HOMOLOGACAO = String.fromEnvironment('BASE_URL',
    defaultValue: "http://192.168.0.104:8081");

const bool isProduction = bool.fromEnvironment('dart.vm.product');

get baseUrl => isProduction ? BASE_URL : BASE_URL_HOMOLOGACAO;


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

const String KEY_USERLOGIN = "userlogin";
const String KEY_USERPASSWORD = "passwordlogin";
const String KEY_USERID = "useridlogin";
const String KEY_EXPIRYDATE = "expirylogin";
const String KEY_TOKEN = "tokenlogin";
