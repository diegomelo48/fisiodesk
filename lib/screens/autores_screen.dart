import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

/// Equivalente a AutoresFragment / fragment_autores.xml, usando o conteúdo
/// de @string/julio, @string/luciana e @string/valeria.
class AutoresScreen extends StatelessWidget {
  const AutoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autores')),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Autores',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppColors.textoPrincipal),
                  ),
                  const SizedBox(height: 10),
                  _AutorTile(
                    nome: 'Júlio Cesar da Rocha Alves',
                    linhas: const [
                      'Mestre em Ensino em Saúde na Amazônia',
                      'Universidade do Estado do Pará (UEPA)',
                    ],
                    email: 'rocha_alvesjc@hotmail.com',
                  ),
                  _AutorTile(
                    nome: 'Luciana da Silva Alves',
                    linhas: const [
                      'Graduanda em Fisioterapia',
                      'Instituição: Universidade do Estado do Pará (UEPA)',
                    ],
                  ),
                  _AutorTile(
                    nome: 'Valéria Marques Ferreira Normando',
                    linhas: const [
                      'Doutora em Neurociências e Biologia Celular',
                      'Instituição: Universidade do Estado do Pará (UEPA)',
                    ],
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

class _AutorTile extends StatelessWidget {
  final String nome;
  final List<String> linhas;
  final String? email;

  const _AutorTile({required this.nome, required this.linhas, this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nome,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textoPrincipal, fontSize: 16)),
          for (final linha in linhas)
            Text(linha, style: const TextStyle(color: AppColors.textoPrincipal, fontSize: 16)),
          if (email != null)
            InkWell(
              onTap: () => launchUrl(Uri(scheme: 'mailto', path: email)),
              child: Text('E-mail: $email',
                  style: const TextStyle(
                      color: AppColors.azulLink,
                      fontSize: 16,
                      decoration: TextDecoration.underline)),
            ),
        ],
      ),
    );
  }
}
