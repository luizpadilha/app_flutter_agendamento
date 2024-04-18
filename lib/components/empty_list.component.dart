import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width * 0.80,
      child: Padding(
        padding:
        const EdgeInsets.fromLTRB(15, 60, 15, 15),
        child: Column(
          children: [
            Image.asset(
              'assets/images/empty-list.png',
              width:
              MediaQuery.of(context).size.width / 3,
              // color: Colors.black87,
            ),
            const SizedBox(
              height: 20,
            ),
            AutoSizeText(
              "Não foram encontrados registros vinculado ao seu usuario",
              maxLines: 5,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                  fontSize: MediaQuery.of(context)
                      .textScaler
                      .scale(14),
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
