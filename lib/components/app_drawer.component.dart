import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/entity/user.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/graficos/graficos.module.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class AppDrawerComponent extends StatefulWidget {
  const AppDrawerComponent({super.key});

  @override
  State<AppDrawerComponent> createState() => _AppDrawerComponentState();
}

class _AppDrawerComponentState extends State<AppDrawerComponent> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    return Drawer(
      width: deviceSize.width * 0.80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          Expanded(
            child: buildItens(context),
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    User user = GetIt.instance.get<User>();
    var textTheme = Theme.of(context).textTheme;
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          Modular.to.pushReplacementNamed('/usuario/');
        },
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage('assets/icons/usuario.png'),
                ),
                AutoSizeText(
                  user.username!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildItens(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      children: _childrens(),
    );
  }

  List<Widget> _childrens() {
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;
    List<Widget> retorno = itensDrawer.map((item) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: deviceSize.height * 0.07,
            width: deviceSize.width * 0.70,
            child: ListTile(
              leading:  CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF4E5965),
                child: Icon(
                  item.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(item.nome),
              onTap: () {
                Navigator.pop(context);
                Modular.to.pushReplacementNamed(item.rota);
              },
            ),
          ),
          const Divider(),
        ],
      );
    }).toList();
    retorno.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: deviceSize.height * 0.08,
            width: deviceSize.width * 0.70,
            child: ListTile(
              leading:  const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF4E5965),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: const Text('Sair'),
              onTap: () {
                Modular.to.pushNamedAndRemoveUntil(
                    LoginModule.ROUTE, (route) => route.isFirst,
                    arguments: true);
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
    return retorno;
  }

  List<ItemDrawer> itensDrawer = [
    ItemDrawer(
      icon: Icons.home,
      nome: 'Home',
      rota: HomeModule.ROUTE,
    ),
    ItemDrawer(
      icon: Icons.schedule,
      nome: 'Agenda',
      rota: AgendaModule.ROUTE,
    ),
    ItemDrawer(
      icon: Icons.people,
      nome: 'Clientes',
      rota: PessoaModule.ROUTE,
    ),
    ItemDrawer(
      icon: Icons.add_business,
      nome: 'Serviços',
      rota: ServicoModule.ROUTE,
    ),
    ItemDrawer(
      icon: Icons.bar_chart,
      nome: 'Gráficos',
      rota: GraficoModule.ROUTE,
    ),
    ItemDrawer(
      icon: Icons.settings,
      nome: 'Configurações',
      rota: ConfigModule.ROUTE,
    ),
  ];
}

class ItemDrawer {
  IconData icon;
  String nome;
  String rota;

  ItemDrawer({
    required this.icon,
    required this.nome,
    required this.rota,
  });
}
