import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/equipe.dart';
import '../theme/app_theme.dart';

/// Equivalente a item_equipe.xml + EquipeAdapter (clique no email abre app
/// de email, clique no telefone abre discador, menu com editar/excluir).
class EquipeCard extends StatelessWidget {
  final Equipe equipe;
  final VoidCallback? onMenu;

  const EquipeCard({super.key, required this.equipe, this.onMenu});

  Future<void> _abrirEmail() async {
    final uri = Uri(scheme: 'mailto', path: equipe.email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _abrirDiscador() async {
    final uri = Uri(scheme: 'tel', path: equipe.telefone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipOval(
              child: equipe.fotoUrl != null && equipe.fotoUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: equipe.fotoUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const CircleAvatar(radius: 30),
                      errorWidget: (_, __, ___) =>
                          const CircleAvatar(radius: 30, child: Icon(Icons.person)),
                    )
                  : const CircleAvatar(radius: 30, child: Icon(Icons.person)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(equipe.nome,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoPrincipal)),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: _abrirEmail,
                    child: Text(equipe.email,
                        style: const TextStyle(fontSize: 16, color: AppColors.textoPrincipal)),
                  ),
                  InkWell(
                    onTap: _abrirDiscador,
                    child: Text(equipe.telefone,
                        style: const TextStyle(fontSize: 16, color: AppColors.textoPrincipal)),
                  ),
                ],
              ),
            ),
            if (onMenu != null)
              IconButton(icon: const Icon(Icons.more_vert), onPressed: onMenu),
          ],
        ),
      ),
    );
  }
}
