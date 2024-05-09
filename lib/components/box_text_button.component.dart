import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoxTextButtonComponenet extends StatelessWidget {
  String label;
  IconData icon;
  Function() onPressed;

  BoxTextButtonComponenet({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: SizedBox.expand(
        child: TextButton(
          onPressed: () {
            onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
