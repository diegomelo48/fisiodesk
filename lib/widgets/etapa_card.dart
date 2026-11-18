import 'package:flutter/material.dart';
import '../models/etapa.dart';
import '../models/projeto.dart';
import '../theme/app_theme.dart';

/// Equivalente a item_etapa.xml + EtapaAdapter (sem a lógica de
/// PopupMenu/exclusão nem o cache de nome de projeto - ambos ficam a cargo
/// de quem usa o card).
class EtapaCard extends StatelessWidget {
  final Etapa etapa;
  final String? nomeProjeto;
  final VoidCallback? onTap;
  final VoidCallback? onMenu;

  const EtapaCard({
    super.key,
    required this.etapa,
    this.nomeProjeto,
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
                  iconeAssetParaEtapa(etapa.nomeEtapa),
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
                      etapa.nomeEtapa,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nomeProjeto ?? 'Carregando...',
                      style: const TextStyle(fontSize: 18, color: AppColors.textoPrincipal),
                    ),
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
