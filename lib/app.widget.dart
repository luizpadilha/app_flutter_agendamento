import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData(
      fontFamily: 'Lato',
    );
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp.router(
      title: 'My barber',
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.blueAccent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed, // Fixed
          backgroundColor: Colors.blueAccent, // <-- This works for fixed
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          foregroundColor: Colors.black,
          titleTextStyle: GoogleFonts.raleway(
            fontSize: mediaQuery.textScaler.scale(16),
            color: Colors.white,
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
