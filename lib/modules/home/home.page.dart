import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:mybabernew/components/carregando.component.dart';
import 'package:mybabernew/components/icon.button.component.dart';
import 'package:mybabernew/components/list.tile.component.dart';
import 'package:mybabernew/components/pop.scope.component.dart';
import 'package:mybabernew/components/scaffold.component.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/home/home.controller.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';
import 'package:mybabernew/modules/viewobject/home.dart';

class HomePage extends StatefulWidget {
  final HomeController controller;

  const HomePage({
    required this.controller,
  });

  static const String ROUTE = "/home/";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  User user = GetIt.instance.get<User>();
  late Future _future;
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _future = _carregarDados(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _lastOrientation ??= MediaQuery.of(context).orientation;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentOrientation = MediaQuery.of(context).orientation;
      if (_lastOrientation != currentOrientation) {
        _lastOrientation = currentOrientation;
        controller.atualizarPagina();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _future = _carregarDados(context);
    }
  }

  HomeController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    var heightCardProgressoImv = isLandscape ? deviceSize.height * 0.45 : deviceSize.height * 0.28;
    var heightColummProgressoImv = isLandscape ? deviceSize.height * 0.53 : deviceSize.height * 0.32;

    return PopScopeComponent(
      child: ScaffoldComponent(
        isHome: true,
        isDrawer: false,
        isActionHome: false,
        isActionVoltar: false,
        widgetTitleAppBar: InkWell(
          child: Row(
            children: [
              Flexible(
                child: AutoSizeText(
                  style: textTheme.titleMedium,
                  'Olá, ${user.username} ',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Icon(Icons.arrow_forward_ios_outlined, size: deviceSize.height * 0.025),
            ],
          ),
          onTap: () {
            Modular.to.pushNamed('/usuario/');
          },
        ),
        titleAppBar:  "Olá, ${user.username}",
        actions: [
          IconButtonComponent(
            icon: Icons.exit_to_app,
            iconColor: Colors.white,
            onPressed: () {
              Modular.to.pushNamedAndRemoveUntil(
                  LoginModule.ROUTE, (route) => route.isFirst,
                  arguments: true);
            },
          ),
        ],
        body: FutureBuilder(
          future: _future,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Carregando(inverterCor: true));
            } else {
              return Padding(
                padding: EdgeInsets.all(deviceSize.width * 0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TripleBuilder<HomeController, Home>(
                        store: controller,
                        builder: (ctx, triple) {
                          var state = triple.state;
                          return triple.isLoading
                              ? const Center(child: Carregando(inverterCor: true))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //possivel grafico/progresso
                                    Expanded(
                                      child: ListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        children: itensHome.map((item) {
                                          return ListTileComponent(
                                            icon: item.icon,
                                            titulo: item.titulo,
                                            subTitulo: item.subTitulo,
                                            function: () => Modular.to.pushNamed(item.rota).then((_) async {
                                              await _carregarDados(context);
                                            }),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _carregarDados(BuildContext context) async {
    try {
      controller.setLoading(true);
      return await controller.initPage();
    } catch (erro) {
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Erro ao carregar tela",
          style: AlertStyle.error);
    } finally {
      controller.setLoading(false);
    }
  }

  List<ItemHome> itensHome = [
    ItemHome(
      icon: Icons.schedule,
      titulo: 'Agenda',
      subTitulo: 'Gerencie seus horários',
      rota: AgendaModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.people,
      titulo: 'Clientes',
      subTitulo: 'Gerencie sua lista de clientes',
      rota: PessoaModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.add_business,
      titulo: 'Serviços',
      subTitulo: 'Controle e cadastre seus serviços',
      rota: ServicoModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.bar_chart,
      titulo: 'Gráficos',
      subTitulo: 'Visualize estatísticas e métricas',
      rota: GraficoModule.ROUTE,
    ),
    ItemHome(
      icon: Icons.settings,
      titulo: 'Configurações',
      subTitulo: 'Personalize o aplicativo',
      rota: ConfigModule.ROUTE,
    ),
  ];
}

class ItemHome {
  IconData icon;
  String titulo;
  String subTitulo;
  String rota;

  ItemHome({
    required this.icon,
    required this.titulo,
    required this.subTitulo,
    required this.rota,
  });
}
