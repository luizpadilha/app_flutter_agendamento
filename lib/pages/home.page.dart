import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class HomePage extends StatefulWidget {
  static const String ROUTE = "/home/";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = MediaQuery.of(context).size;
    return ScaffoldComponent(
      isDrawer: true,
      isActionHome: false,
      isActionVoltar: false,
      widgetAppBar: const Icon(Icons.home),
      labelAppBar: 'Home',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Modular.to.pushNamedAndRemoveUntil(
                LoginModule.ROUTE, (route) => route.isFirst,
                arguments: true);
          },
        ),
      ],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10.0),
              itemCount: itensHome.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: GestureDetector(
                      onTap: () {
                        Modular.to.pushReplacementNamed(itensHome[index].rota);
                      },
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
                              CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color(0xFF4E5965),
                                  child: Icon(
                                    itensHome[index].icon,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                              ),
                              SizedBox(height: deviceSize.height * 0.02),
                              AutoSizeText(
                                itensHome[index].nome,
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
              }),
        ],
      ),
    );
  }

  List<ItemHome> itensHome = [
    ItemHome(
      icon: Icons.schedule,
      nome: 'Agenda',
      rota: AgendaModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.people,
      nome: 'Pessoas',
      rota: PessoaModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.add_business,
      nome: 'Serviços',
      rota: ServicoModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.bar_chart,
      nome: 'Gráficos',
      rota: GraficoModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.settings,
      nome: 'Configurações',
      rota: ConfigModule.ROUTE,
    ),
  ];
}

class ItemHome {
  IconData icon;
  String nome;
  String rota;

  ItemHome({
    required this.icon,
    required this.nome,
    required this.rota,
  });
}
