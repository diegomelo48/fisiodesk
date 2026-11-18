import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Equivalente a SobreFragment / fragment_sobre.xml.
class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o APP')),
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
          const Center(
            child: Text(
              '©Copyright - 2024 - 2025',
              style: TextStyle(
                  color: AppColors.textoPrincipal,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Assistente para projetos tecnológicos em Fisioterapia e reabilitação.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.textoPrincipal,
                  fontStyle: FontStyle.italic,
                  fontSize: 15),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Secao(
                    titulo: 'Sobre o Aplicativo',
                    texto:
                        'Produto educacional do PPG Doutorado Ensino em Saúde na Amazônia - UEPA',
                  ),
                  _Secao(
                    titulo: 'Objetivos do Aplicativo',
                    texto:
                        'Fornecer um recurso digital de assistência para criação de projetos '
                        'tecnológicos em atividades de ensino, pesquisa e inovação na área de '
                        'Fisioterapia e reabilitação.',
                  ),
                  _Secao(
                    titulo: 'Público-alvo',
                    texto:
                        'Grupos de pesquisa, alunos e docentes com atuação na área de tecnologia '
                        'e reabilitação.',
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

class _Secao extends StatelessWidget {
  final String titulo;
  final String texto;
  const _Secao({required this.titulo, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF008000), fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(texto,
              textAlign: TextAlign.justify,
              style: const TextStyle(color: AppColors.textoPrincipal, fontSize: 15)),
        ],
      ),
    );
  }
}
