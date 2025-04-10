import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//get baseUrl => 'https://api.agendamento.padilha.dev.br';
//get baseUrl => 'http://192.168.0.114:8081';
get baseUrl => 'http://192.168.0.104:8081';


bool platformIsIos(BuildContext context) {
  return Theme.of(context).platform == TargetPlatform.iOS;
}

bool isTablet(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final larguraTela = mediaQuery.size.width;
  return larguraTela > 600;
}

const String KEY_USERLOGIN = "userlogin";
const String KEY_USERPASSWORD = "passwordlogin";
const String KEY_USERID = "useridlogin";
const String KEY_EXPIRYDATE = "expirylogin";

const colorPrimary = Color(0xFF2C3E50);
const colorSecond = Color(0xFF1ABC9C);
const colorTertiary = Color(0xFF95A5A6);

