import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/bottom_bar.component.dart';
import 'package:mybabernew/pages/home.page.dart';

class ScaffoldComponent extends StatelessWidget {
  final String labelAppBar;
  final Widget widgetAppBar;
  final bool isDrawer;
  final bool isBottomBar;
  final bool extendBody;
  final bool isActionHome;
  final bool isActionVoltar;
  final Widget body;
  final List<Widget>? actions;
  final void Function()? onPressedFloatingActionButton;
  final void Function()? onTapGestureDetector;

  ScaffoldComponent({
    required this.labelAppBar,
    required this.widgetAppBar,
    required this.body,
    this.isDrawer = false,
    this.isActionHome = false,
    this.extendBody = false,
    this.isActionVoltar = false,
    this.isBottomBar = false,
    this.actions,
    this.onPressedFloatingActionButton,
    this.onTapGestureDetector,
    super.key,
  });

  void _onTapGestureDetectorPadrao(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var deviceSize = mediaQuery.size;
    return GestureDetector(
      onTap: () {
        if (onTapGestureDetector == null) {
          _onTapGestureDetectorPadrao(context);
        } else {
          onTapGestureDetector!();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: deviceSize.height * 0.07,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: deviceSize.height * 0.035,
                child: widgetAppBar,
              ),
              SizedBox(width: deviceSize.width * 0.01),
              Flexible(
                child: AutoSizeText(
                  labelAppBar,
                  minFontSize: mediaQuery.textScaler.scale(12),
                  maxFontSize: mediaQuery.textScaler.scale(16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          actions: actions,
          leading: isActionHome
              ? _actionHome(deviceSize)
              : isActionVoltar
                  ? _actionVoltar(deviceSize)
                  : isDrawer
                      ? _actionDrawer(deviceSize)
                      : null,
        ),
        drawer: isDrawer ? const AppDrawerComponent() : null,
        bottomNavigationBar: isBottomBar ? const BottomBarComponent() : null,
        extendBody: extendBody,
        body: body,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _actionHome(var deviceSize) {
    return IconButton(
      icon: const Icon(Icons.home),
      onPressed: () {
        Modular.to.pushReplacementNamed(HomePage.ROUTE, arguments: null);
      },
    );
  }

  Widget? _actionVoltar(var deviceSize) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_sharp),
      onPressed: () {
        Modular.to.pop();
      },
    );
  }

  Widget? _actionDrawer(var deviceSize) {
    return Builder(builder: (context) {
      return IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      );
    });
  }
}
