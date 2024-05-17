import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

get baseUrl => 'https://api.agendamento.padilha.dev.br';
//get baseUrl => 'http://localhost:8081';


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

const String KEY_USERLOGIN = "userlogin";
const String KEY_USERPASSWORD = "passwordlogin";
const String KEY_USERID = "useridlogin";
const String KEY_EXPIRYDATE = "expirylogin";
const String KEY_EXPIRYTOKENDATE = "expirytoken";
const String KEY_TOKEN = "tokenlogin";
