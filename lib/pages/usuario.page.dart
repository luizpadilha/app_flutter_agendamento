import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mybabernew/components/app_drawer.component.dart';
import 'package:mybabernew/components/text.form.field.component.dart';
import 'package:mybabernew/entity/user.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  User user = GetIt.instance.get<User>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuário')),
      drawer: const AppDrawerComponent(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextFormFieldComponent(
              readOnly: true,
              controller: TextEditingController(text: user.username!),
              keyboardType: TextInputType.text,
              label: 'Nome',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
