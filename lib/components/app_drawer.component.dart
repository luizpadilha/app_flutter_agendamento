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

class AppDrawerComponent extends StatelessWidget {
  const AppDrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildItens(context),
          ],
        ),
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
                  backgroundImage: AssetImage('assets/images/user-defalut.jpg'),
                ),
                Text(user.username!, style: textTheme.bodyMedium,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItens(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Modular.to.pushReplacementNamed(HomeModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit_note_sharp),
            title: const Text('Config'),
            onTap: () {
              Modular.to.pushReplacementNamed(ConfigModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Serviço'),
            onTap: () {
              Modular.to.pushReplacementNamed(ServicoModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Pessoa'),
            onTap: () {
              Modular.to.pushReplacementNamed(PessoaModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Agenda'),
            onTap: () {
              Modular.to.pushReplacementNamed(AgendaModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Gráficos'),
            onTap: () {
              Modular.to.pushReplacementNamed(GraficoModule.ROUTE);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Modular.to.pushNamedAndRemoveUntil(
                  LoginModule.ROUTE, (route) => route.isFirst,
                  arguments: true);
            },
          ),
        ],
      ),
    );
  }
}
