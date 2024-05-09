import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class BottomBarComponent extends StatefulWidget {
  const BottomBarComponent({Key? key}) : super(key: key);

  @override
  State<BottomBarComponent> createState() => _BottomBarComponentState();
}

int _currentIndex = 3;

class _BottomBarComponentState extends State<BottomBarComponent> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
        switch (index) {
          case 0:
            Modular.to.pushReplacementNamed(HomeModule.ROUTE);
            break;
          case 1:
            Modular.to.pushReplacementNamed(ServicoModule.ROUTE);
            break;
          case 2:
            Modular.to.pushReplacementNamed(PessoaModule.ROUTE);
            break;
          case 3:
            Modular.to.pushReplacementNamed(AgendaModule.ROUTE);
            break;
          case 4:
            Modular.to.pushReplacementNamed(GraficoModule.ROUTE);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.add_business), label: "Serviço"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "Pessoa"),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Agenda"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Gráficos"),
      ],
    );
  }
}
