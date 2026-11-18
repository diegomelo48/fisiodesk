import 'package:flutter/material.dart';
import '../models/recurso_info.dart';
import '../screens/resource_screen.dart';
import '../widgets/categoria_card.dart';

/// Equivalente a CategoriasFragment / fragment_categorias.xml: grade com as
/// 10 categorias, cada uma navegando para a ResourceScreen correspondente.
class CategoriasTab extends StatelessWidget {
  const CategoriasTab({super.key});

  static const _ordem = [
    'tecnologia_movel',
    'tecnologia_assistiva',
    'gameterapia',
    'robotica',
    'realidade_virtual',
    'recursos_avaliacao',
    'cinesioterapia',
    'eletrotermoterapia',
    'produto_educacional',
    'recursos_cardio',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90, top: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          for (final chave in _ordem)
            if (recursosInfo[chave] != null)
              CategoriaCard(
                imagemAsset: recursosInfo[chave]!.imagemAsset,
                titulo: recursosInfo[chave]!.titulo,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ResourceScreen(recursoKey: chave),
                )),
              ),
        ],
      ),
    );
  }
}
