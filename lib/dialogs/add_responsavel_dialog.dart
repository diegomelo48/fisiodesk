import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/usuario.dart';

/// Equivalente ao dialog_add_responsavel.xml + mostrarDialogEditarResponsavel()
/// de EtapasActivity: junta usuários de "Usuarios" e de "Equipe/*" num único
/// spinner para escolher o responsável pela etapa.
class ResponsavelSelecionado {
  final String nome;
  final String email;
  final String? fotoUrl;
  final String uid;
  ResponsavelSelecionado(this.nome, this.email, this.fotoUrl, this.uid);
}

Future<ResponsavelSelecionado?> mostrarDialogSelecionarResponsavel(
    BuildContext context) async {
  final refUsuarios = FirebaseDatabase.instance.ref('Usuarios');
  final refEquipe = FirebaseDatabase.instance.ref('Equipe');

  final List<Usuario> candidatos = [];

  final snapUsuarios = await refUsuarios.get();
  if (snapUsuarios.exists) {
    final map = Map<dynamic, dynamic>.from(snapUsuarios.value as Map);
    for (final v in map.values) {
      candidatos.add(Usuario.fromMap(Map<dynamic, dynamic>.from(v as Map)));
    }
  }

  final snapEquipe = await refEquipe.get();
  if (snapEquipe.exists) {
    final map = Map<dynamic, dynamic>.from(snapEquipe.value as Map);
    for (final porDono in map.values) {
      final membros = Map<dynamic, dynamic>.from(porDono as Map);
      for (final membro in membros.values) {
        final m = Map<dynamic, dynamic>.from(membro as Map);
        candidatos.add(Usuario(
          uid: m['uid'] ?? '',
          nome: m['nome'] ?? '',
          email: m['email'] ?? '',
          telefone: m['telefone'] ?? '',
          fotoUrl: m['fotoUrl'],
        ));
      }
    }
  }

  if (!context.mounted) return null;

  String? selecionado = candidatos.isNotEmpty ? candidatos.first.nome : null;

  return showDialog<ResponsavelSelecionado>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Selecionar Responsável'),
          content: candidatos.isEmpty
              ? const Text('Nenhum responsável encontrado.')
              : DropdownButton<String>(
                  isExpanded: true,
                  value: selecionado,
                  items: candidatos
                      .map((u) => DropdownMenuItem(value: u.nome, child: Text(u.nome)))
                      .toList(),
                  onChanged: (v) => setState(() => selecionado = v),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: candidatos.isEmpty
                  ? null
                  : () {
                      final usuario =
                          candidatos.firstWhere((u) => u.nome == selecionado);
                      Navigator.of(context).pop(ResponsavelSelecionado(
                          usuario.nome, usuario.email, usuario.fotoUrl, usuario.uid));
                    },
              child: const Text('Salvar'),
            ),
          ],
        );
      });
    },
  );
}
