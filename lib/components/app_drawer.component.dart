import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mybabernew/modules/agenda/agenda.module.dart';
import 'package:mybabernew/modules/config/config.module.dart';
import 'package:mybabernew/modules/home/home.module.dart';
import 'package:mybabernew/modules/login/login.module.dart';
import 'package:mybabernew/modules/pessoa/pessoa.module.dart';
import 'package:mybabernew/modules/servico/servico.module.dart';

class AppDrawerComponent extends StatelessWidget {
  const AppDrawerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem Vindo'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
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
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Modular.to.pushNamedAndRemoveUntil(LoginModule.ROUTE, (route) => route.isFirst, arguments: true);
            },
          ),
        ],
      ),
    );
  }
}
