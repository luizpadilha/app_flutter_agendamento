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
    Timer(const Duration(seconds: 4), () {
      Modular.to.navigate(LoginModule.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      color: const Color(0xFFAAFDFF),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: size.height * 0.40,
              child: Lottie.asset(
                'assets/json/splashAnimation.json',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            SizedBox(
              height: size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Padilha', style: textTheme.bodyLarge),
                  Text('software', style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
