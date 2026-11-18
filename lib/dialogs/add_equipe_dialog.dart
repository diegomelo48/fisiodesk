import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/equipe.dart';
import '../widgets/telefone_formatter.dart';

class EquipeFormResult {
  final String nome;
  final String email;
  final String telefone;
  final File? novaFoto;
  EquipeFormResult(this.nome, this.email, this.telefone, this.novaFoto);
}

/// Equivalente a dialog_add_equipe.xml + showAddOrEditDialog() de EquipeFragment.
Future<EquipeFormResult?> mostrarDialogAddEditarEquipe(
  BuildContext context, {
  Equipe? equipeExistente,
}) async {
  final nomeController = TextEditingController(text: equipeExistente?.nome ?? '');
  final emailController = TextEditingController(text: equipeExistente?.email ?? '');
  final telefoneController =
      TextEditingController(text: equipeExistente?.telefone ?? '');
  File? novaFoto;

  return showDialog<EquipeFormResult>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(equipeExistente != null ? 'Editar Equipe' : 'Adicionar Equipe'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final imagem = await picker.pickImage(source: ImageSource.gallery);
                    if (imagem != null) {
                      setState(() => novaFoto = File(imagem.path));
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: novaFoto != null
                        ? FileImage(novaFoto!)
                        : (equipeExistente?.fotoUrl != null &&
                                equipeExistente!.fotoUrl!.isNotEmpty)
                            ? CachedNetworkImageProvider(equipeExistente.fotoUrl!)
                                as ImageProvider
                            : null,
                    child: (novaFoto == null &&
                            (equipeExistente?.fotoUrl == null ||
                                equipeExistente!.fotoUrl!.isEmpty))
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
                final nome = nomeController.text.trim();
                final email = emailController.text.trim();
                final telefone = telefoneController.text.trim();
                if (nome.isEmpty || email.isEmpty || telefone.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
                  return;
                }
                Navigator.of(context)
                    .pop(EquipeFormResult(nome, email, telefone, novaFoto));
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      });
    },
  );
}
