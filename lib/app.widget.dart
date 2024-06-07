import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

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
          primary: const Color(0xFF448AFF),
        ),
        textTheme: TextTheme(
          //campos
          bodySmall: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(10)),
          bodyMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(12)),
          bodyLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(14)),
          //textos
          displaySmall: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(12)),
          displayMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(14)),
          displayLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: mediaQuery.textScaler.scale(16)),
          //botoes
          labelSmall: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(10)),
          labelMedium: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(12)),
          labelLarge: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: mediaQuery.textScaler.scale(14)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor: Colors.blueAccent, // <-- This works for fixed
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          foregroundColor: Colors.black,
          titleTextStyle: GoogleFonts.raleway(
            fontSize: mediaQuery.textScaler.scale(14),
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
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
