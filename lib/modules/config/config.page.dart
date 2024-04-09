import 'package:flutter/material.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';

class ConfigPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Config Page')),
      body: Center(
        child: Text('This is CONFIG page'),
      ),
      bottomNavigationBar: const BottomBarComponent(),
    );
  }
}
