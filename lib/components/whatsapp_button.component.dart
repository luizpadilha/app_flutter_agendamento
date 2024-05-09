import 'package:flutter/material.dart';
import 'package:mybabernew/components/alert.component.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButton extends StatelessWidget {
  final String phoneNumber;
  final String mensagem;

  const WhatsAppButton({Key? key, required this.phoneNumber, required this.mensagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _launchWhatsApp(context);
      },
      icon: const Icon(
        Icons.phone,
        color: Colors.greenAccent,
      ),
    );
  }

  void _launchWhatsApp(BuildContext context) async {
    Uri url = Uri.parse('whatsapp://send?phone=55$phoneNumber&text=$mensagem');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      AlertComponent.show(context,
          title: "Ops!",
          subTitle: "Não foi possivel localizar o WhatsApp: $phoneNumber",
          style: AlertStyle.loading);
    }
  }
}
