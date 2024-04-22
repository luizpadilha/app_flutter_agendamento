import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/app.module.dart';
import 'package:mybabernew/app.widget.dart';

void main() {
  return runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
