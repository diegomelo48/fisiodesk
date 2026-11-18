import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class _LinkUtil {
  final String titulo;
  final String url;
  const _LinkUtil(this.titulo, this.url);
}

/// Equivalente a LinksFragment / fragment_links.xml.
class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  static const _links = [
    _LinkUtil('Busca de patentes INPI (Instituto Nacional da Propriedade Industrial)',
        'https://busca.inpi.gov.br/pePI/'),
    _LinkUtil('Google patentes (Base de patentes do Google)', 'https://patents.google.com/'),
    _LinkUtil('Escopo de patente WIPO (World Intellectual Property Organization)',
        'https://patentscope.wipo.int/search/en/search.jsf'),
    _LinkUtil('EduCAPES (Portal de objetos educacionais)', 'https://educapes.capes.gov.br/'),
    _LinkUtil('PubMed (Base de literatura biomédica e de ciências da vida)',
        'https://pubmed.ncbi.nlm.nih.gov/'),
    _LinkUtil('BVS (Biblioteca Virtual em Saúde)', 'https://bvsalud.org/'),
    _LinkUtil('ABNT / NBR (Associação Brasileira de Normas Técnicas)',
        'https://www.abntcatalogo.com.br/default.aspx?O=1'),
    _LinkUtil('LGPD (Lei Geral de Proteção de Dados)',
        'https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/L13709compilado.htm'),
    _LinkUtil('Lei de patentes', 'https://www.planalto.gov.br/ccivil_03/leis/l9279.htm'),
    _LinkUtil('Lei dos softwares', 'https://www.planalto.gov.br/ccivil_03/leis/l9609.htm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Links Úteis')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Center(
            child: Image.asset(
              'assets/images/bg.png',
              width: 140,
              height: 140,
              errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Links Úteis',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoPrincipal,
                          fontSize: 15),
                    ),
                  ),
                  for (final link in _links)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('•  ${link.titulo}',
                              style: const TextStyle(
                                  color: AppColors.textoPrincipal, fontSize: 15)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () => launchUrl(Uri.parse(link.url),
                                mode: LaunchMode.externalApplication),
                            child: Text(link.url,
                                style: const TextStyle(
                                    color: AppColors.azulLink,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline)),
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
