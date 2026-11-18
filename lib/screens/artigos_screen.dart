import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class _Artigo {
  final String titulo;
  final String url;
  const _Artigo(this.titulo, this.url);
}

/// Equivalente a ArtigosActivity / activity_artigos.xml.
class ArtigosScreen extends StatelessWidget {
  const ArtigosScreen({super.key});

  static const _artigos = [
    _Artigo(
      'Modelo consensual de projeto tecnológicos para área da saúde:',
      'https://sistemascmc.ifam.edu.br/educitec/index.php/educitec/article/view/1761',
    ),
    _Artigo(
      'Vídeo educacional como recurso de ensino em projetos para área da Saúde:',
      'https://periodicos.sbu.unicamp.br/ojs/index.php/riesup/article/view/8665621',
    ),
    _Artigo(
      'Análise de patentes de softwares na área de fisioterapia e reabilitação:',
      'https://drive.google.com/file/d/1-FRVaq9tblvmeTjVpPS8O9BDHu5WqpmM/view?usp=sharing',
    ),
    _Artigo(
      'Estudo de inovação tecnológica em fisioterapia e reabilitação por grupos de pesquisa:',
      'https://drive.google.com/file/d/1Y0gqkJZr_7Bt-MIFZQymgy19enh8QNHP/view?usp=sharing',
    ),
    _Artigo(
      'Panorama da produção tecnológica em fisioterapia e reabilitação:',
      'https://ojs.studiespublicacoes.com.br/ojs/index.php/cadped/article/view/15024',
    ),
    _Artigo(
      'Análise tecnológica de patentes na área de fisioterapia e reabilitação',
      'https://periodicos.utfpr.edu.br/rts/article/view/18475',
    ),
  ];

  Future<void> _abrir(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artigos')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final artigo in _artigos)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artigo.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textoPrincipal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => _abrir(artigo.url),
                            child: Text(
                              artigo.url,
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.azulLink,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
