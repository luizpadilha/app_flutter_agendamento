import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mybabernew/components/alert.component.dart';

class ImagePickerComponent extends StatelessWidget {
  final Function(File?) onFileChanged;
  final imagePicker = ImagePicker();
  final File? imageFile;
  final bool readOnly;

  ImagePickerComponent({
    super.key,
    required this.onFileChanged,
    required this.imageFile,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[200],
              child: CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey[300],
                backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
              ),
            ),
            if (!readOnly)
              Positioned(
                bottom: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: IconButton(
                    onPressed: () => _showOpcoesBottomSheet(context),
                    icon: Icon(
                      Icons.edit,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showOpcoesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Galeria',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  selecionarImage(ImageSource.gallery, context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  selecionarImage(ImageSource.camera, context);
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                title: Text(
                  'Remover',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  onFileChanged(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  selecionarImage(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        onFileChanged(File(pickedFile.path));
      }
    } catch (erro) {
      AlertComponent.show(
        context,
        title: "Ops!",
        subTitle: 'Não foi possível acessar a câmera. '
            'Para corrigir isso, vá até Configurações > Privacidade > Câmera e ative a permissão para este aplicativo',
        style: AlertStyle.error,
      );
    }
  }
}
