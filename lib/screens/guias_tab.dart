import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'artigos_screen.dart';
import 'pdf_viewer_screen.dart';
import '../widgets/categoria_card.dart';

/// Equivalente a GuiasFragment / fragment_guias.xml.
class GuiasTab extends StatelessWidget {
  const GuiasTab({super.key});

  static const _painelUrl =
      'https://drive.google.com/file/d/16k2OzevFv0zwf3Fhv3HH8Bo7SCk8DfUI/view?usp=sharing';

  // URL usada em MetodosActivity para baixar o PDF antes de exibir.
  static const _metodosUrl =
      'https://drive.google.com/uc?export=download&id=1XzziKqkqW2EkPNbUJAedwCPOiTb_VCeT';

  Future<void> _abrirPainel(BuildContext context) async {
    final uri = Uri.parse(_painelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum navegador disponível para abrir o link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90, top: 10),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              CategoriaCard(
                imagemAsset: 'assets/images/tecnologia_movel.png',
                titulo: 'Guia do App',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PdfViewerScreen(
                    titulo: 'Guia do App',
                    assetPath: 'assets/pdf/Guia-FisioDesk.pdf',
                  ),
                )),
              ),
              CategoriaCard(
                imagemAsset: 'assets/images/img_metodos.png',
                titulo: 'Guia de aplicação Pedagógica',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PdfViewerScreen(
                    titulo: 'Guia de Aplicação',
                    assetPath: 'assets/pdf/Guia-aplicacao-pedagogica.pdf',
                  ),
                )),
              ),
              CategoriaCard(
                imagemAsset: 'assets/images/img_metodos.png',
                titulo: 'Métodos de Projeto em saúde',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const PdfViewerScreen(
                    titulo: 'Métodos',
                    networkUrl: _metodosUrl,
                  ),
                )),
              ),
              CategoriaCard(
                imagemAsset: 'assets/images/img_painel.png',
                titulo: 'Painel tecnológico',
                onTap: () => _abrirPainel(context),
              ),
              CategoriaCard(
                imagemAsset: 'assets/images/img_artigos.png',
                titulo: 'Artigos relacionados',
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ArtigosScreen(),
                )),
              ),
            ],
          ),
          Image.asset(
            'assets/images/bg_guias.png',
            width: 250,
            height: 280,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
