import 'package:flutter/material.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/components/map.component.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MAP Page')),
      body: MapComponent(),
      bottomNavigationBar: const BottomBarComponent(),
    );
  }
}
