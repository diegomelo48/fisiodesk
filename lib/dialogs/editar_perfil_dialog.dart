import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../widgets/telefone_formatter.dart';

class PerfilFormResult {
  final String nome;
  final String email;
  final String telefone;
  final String novaSenha;
  final File? novaFoto;
  PerfilFormResult({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.novaSenha,
    this.novaFoto,
  });
}

/// Equivalente a dialog_editar_perfil.xml + abrirDialogEdicao() de PerfilFragment.
Future<PerfilFormResult?> mostrarDialogEditarPerfil(
  BuildContext context,
  Usuario usuario,
) async {
  final nomeController = TextEditingController(text: usuario.nome);
  final emailController = TextEditingController(text: usuario.email);
  final telefoneController = TextEditingController(text: usuario.telefone);
  final senhaController = TextEditingController();
  File? novaFoto;

  return showDialog<PerfilFormResult>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Editar Perfil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final imagem = await picker.pickImage(source: ImageSource.gallery);
                    if (imagem != null) setState(() => novaFoto = File(imagem.path));
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: novaFoto != null
                        ? FileImage(novaFoto!)
                        : (usuario.fotoUrl != null && usuario.fotoUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(usuario.fotoUrl!) as ImageProvider
                            : null,
                    child: (novaFoto == null &&
                            (usuario.fotoUrl == null || usuario.fotoUrl!.isEmpty))
                        ? const Icon(Icons.add_a_photo, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [TelefoneFormatter()],
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: 'Nova senha (opcional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(PerfilFormResult(
                  nome: nomeController.text.trim(),
                  email: emailController.text.trim(),
                  telefone: telefoneController.text.trim(),
                  novaSenha: senhaController.text.trim(),
                  novaFoto: novaFoto,
                ));
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      });
    },
  );
}
