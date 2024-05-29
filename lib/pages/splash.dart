import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
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
    Timer(const Duration(seconds: 5), () {
      Modular.to.navigate(LoginModule.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var heightDisp = mediaQuery.size.height - mediaQuery.padding.top;
    return Material(
      child: Container(
        color: const Color(0xFFFFFFFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: heightDisp * 0.25,
            ),
            SizedBox(
              height: heightDisp * 0.50,
              child: Column(
                children: [
                  Image.asset(
                    'assets/app/splash.png',
                    height: heightDisp * 0.40,
                  ),
                  Text('Agende Fácil',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: mediaQuery.textScaler.scale(18))),
                ],
              ),
            ).animate(
              delay: const Duration(microseconds: 600),
            ).fade(
              delay: const Duration(microseconds: 100),
            ).slide(
              begin: const Offset(0.5, 0),
              duration: const Duration(microseconds: 200),
              curve: Curves.easeOut,
              delay: const Duration(microseconds: 100),
            ).animate(
              onPlay: (controller) => controller.repeat(),
            ).shimmer(
              duration: 2400.ms,
            ),
            SizedBox(
              height: heightDisp * 0.10,
            ),
            SizedBox(
              height: heightDisp * 0.10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Padilha Software© 2024', style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: mediaQuery.textScaler.scale(14))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}