import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Equivalente aos MaterialCardView repetidos em fragment_categorias.xml e
/// fragment_guias.xml (imagem + linha + título em negrito).
class CategoriaCard extends StatelessWidget {
  final String imagemAsset;
  final String titulo;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.imagemAsset,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 140,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagemAsset,
                width: 70,
                height: 70,
                errorBuilder: (_, __, ___) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 1,
                color: AppColors.textoPrincipal,
              ),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoPrincipal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
