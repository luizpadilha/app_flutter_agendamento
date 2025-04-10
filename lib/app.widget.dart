import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/constants.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class AppWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData(
      fontFamily: 'Lato',
    );
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'Agende Fácil',
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: colorPrimary,
          secondary: colorSecond,
          tertiary: colorTertiary,
        ),
        textTheme: TextTheme(
          //campos
          bodySmall: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(12)),
          bodyMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(14)),
          bodyLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(16)),
          //textos
          displaySmall: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(12)),
          displayMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(14)),
          displayLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(16)),
          //botoes
          labelSmall: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(12)),
          labelMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(14)),
          labelLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(16)),
          //Titulos
          titleSmall: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(14)),
          titleMedium: GoogleFonts.roboto(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(18)),
          titleLarge: GoogleFonts.roboto(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(20)),

        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor: colorPrimary, // <-- This works for fixed
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: const AppBarTheme(
          color: colorPrimary,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: Modular.routerConfig,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('BR')],
    ); //added by extension
  }
}
