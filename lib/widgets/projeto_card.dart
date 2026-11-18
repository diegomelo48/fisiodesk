import 'package:flutter/material.dart';
import '../models/projeto.dart';
import '../theme/app_theme.dart';

/// Equivalente a item_projeto.xml + ProjetoAdapter (sem a lógica de
/// PopupMenu/exclusão, que fica a cargo de quem usa o card via [onMenu]).
class ProjetoCard extends StatelessWidget {
  final Projeto projeto;
  final VoidCallback? onTap;
  final VoidCallback? onMenu;

  const ProjetoCard({
    super.key,
    required this.projeto,
    this.onTap,
    this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  iconeAssetParaCategoria(projeto.categoria),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projeto.nomeProjeto,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Categoria: ${projeto.categoria}',
                        style: const TextStyle(fontSize: 15, color: Colors.grey)),
                    Text('Prazo: ${projeto.prazo}',
                        style: const TextStyle(fontSize: 15, color: Colors.grey)),
                  ],
                ),
              ),
              if (onMenu != null)
                IconButton(icon: const Icon(Icons.more_vert), onPressed: onMenu),
            ],
          ),
        ),
      ),
    );
  }
}
