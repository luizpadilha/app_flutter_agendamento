import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/modules/login/login.module.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Modular.to.navigate(LoginModule.ROUTE);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var heightDisp = mediaQuery.size.height - mediaQuery.padding.top;
    var textTheme = Theme.of(context).textTheme;
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: heightDisp * 0.15,
            ),
            SizedBox(
              height: heightDisp * 0.60,
              child: Column(
                children: [
                  SizedBox(
                    width: mediaQuery.size.width * 0.60,
                    height: heightDisp * 0.30,
                    child: Image.asset(
                      fit: BoxFit.fitWidth,
                      'assets/app/splash.png',
                    ),
                  ),
                  AutoSizeText('AgendaPro',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge!.copyWith(
                      fontSize: mediaQuery.textScaler.scale(24),
                    ),
                  ),
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
                      color: Colors.white,
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