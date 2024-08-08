import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//get baseUrl => 'https://api.agendamento.padilha.dev.br';
//get baseUrl => 'http://192.168.0.114:8081';
get baseUrl => 'http://192.168.0.104:8081';


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

const String KEY_USERLOGIN = "userlogin";
const String KEY_USERPASSWORD = "passwordlogin";
const String KEY_USERID = "useridlogin";
const String KEY_EXPIRYDATE = "expirylogin";
const String KEY_EXPIRYTOKENDATE = "expirytoken";
const String KEY_TOKEN = "tokenlogin";
