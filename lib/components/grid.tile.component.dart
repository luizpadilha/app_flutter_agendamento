import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GridTileComponent extends StatelessWidget {
  
  final IconData icon;
  final String nome;
  final void Function() onTap;
  
  const GridTileComponent({
    required this.icon,
    required this.nome,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  const Color(0xFF00C5BE)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: deviceSize.width * 0.12),
                  SizedBox(height: deviceSize.height * 0.02),
                  AutoSizeText(
                    nome,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: mediaQuery.textScaler.scale(16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
