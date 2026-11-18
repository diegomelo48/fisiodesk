import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/equipe.dart';
import '../models/projeto.dart';
import '../services/auth_service.dart';
import '../services/equipe_repository.dart';
import '../theme/app_theme.dart';

class ProjetoEditado {
  final String nome;
  final String descricao;
  final String categoria;
  final String responsavel;
  final String? emailResponsavel;
  final String prazo; // dd/MM/yyyy
  ProjetoEditado({
    required this.nome,
    required this.descricao,
    required this.categoria,
    required this.responsavel,
    required this.prazo,
    this.emailResponsavel,
  });
}

/// Equivalente a layout_editar_projeto.xml + abrirDialogEditar() de
/// DetalhesProjetoEtapaActivity.
Future<ProjetoEditado?> mostrarDialogEditarProjeto(
  BuildContext context,
  Projeto projeto,
) async {
  final nomeController = TextEditingController(text: projeto.nomeProjeto);
  final descricaoController = TextEditingController(text: projeto.descricao);
  final dateFormat = DateFormat('dd/MM/yyyy');

  String categoria = projeto.categoria;
  String? responsavelNome = projeto.responsavel;
  DateTime prazo = DateTime.now();
  try {
    prazo = dateFormat.parseStrict(projeto.prazo);
  } catch (_) {}

  final uidDono = AuthService().uidAtual;
  List<Equipe> equipe = [];
  if (uidDono != null) {
    equipe = await EquipeRepository().buscarEquipeUmaVez(uidDono);
  }

  if (!context.mounted) return null;

  return showDialog<ProjetoEditado>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Editar Projeto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categoria',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
                DropdownButton<String>(
                  isExpanded: true,
                  value: categoria,
                  items: kCategorias
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => categoria = v!),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome do Projeto'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descricaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 10),
                const Text('Responsável',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
                DropdownButton<String>(
                  isExpanded: true,
                  value: equipe.any((e) => e.nome == responsavelNome) ? responsavelNome : null,
                  hint: const Text('Selecione'),
                  items: equipe
                      .map((e) => DropdownMenuItem(value: e.nome, child: Text(e.nome)))
                      .toList(),
                  onChanged: (v) => setState(() => responsavelNome = v),
                ),
                const SizedBox(height: 10),
                const Text('Prazo',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textoPrincipal)),
                CalendarDatePicker(
                  initialDate: prazo,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
                  onDateChanged: (d) => setState(() => prazo = d),
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
                final descricao = descricaoController.text.trim();
                if (nome.isEmpty || descricao.isEmpty || responsavelNome == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Preencha todos os campos obrigatórios')));
                  return;
                }
                final resp = equipe.firstWhere((e) => e.nome == responsavelNome);
                Navigator.of(context).pop(ProjetoEditado(
                  nome: nome,
                  descricao: descricao,
                  categoria: categoria,
                  responsavel: responsavelNome!,
                  emailResponsavel: resp.email,
                  prazo: dateFormat.format(prazo),
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
