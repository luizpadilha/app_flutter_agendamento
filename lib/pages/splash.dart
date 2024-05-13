import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';
import 'package:mybabernew/modules/login/login.module.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Modular.to.pushReplacementNamed(LoginModule.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      color: const Color(0xFF55AFE7),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.20, bottom: size.height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Lottie.asset(
              'assets/json/splashAnimation.json',
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: size.height * 0.30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Padilha', style: textTheme.bodyLarge),
                Text('software', style: textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
