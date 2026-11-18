import 'package:flutter/material.dart';
import '../models/recurso_info.dart';
import '../theme/app_theme.dart';
import '../widgets/saiba_mais_text.dart';

/// Tela única que substitui as 10 telas quase idênticas do Android
/// (RoboticaActivity, GameterapiaActivity, CinesioterapiaActivity,
/// EletrotermoterapiaActivity, ProdutoEducacionalActivity,
/// RealidadeVirtualActivity, RecursosAvaliacaoActivity, RecursosCardioActivity,
/// TecnologiaAssistivaActivity, TecnologiaMovelActivity), todas com o mesmo
/// layout de card + "Saiba mais" clicável.
class ResourceScreen extends StatefulWidget {
  final String recursoKey;
  const ResourceScreen({super.key, required this.recursoKey});

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final info = recursosInfo[widget.recursoKey];
    if (info == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recurso')),
        body: const Center(child: Text('Recurso não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(info.titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        info.imagemAsset,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        info.descricaoResumo,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: AppColors.textoPrincipal),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => setState(() => _expandido = !_expandido),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Saiba mais',
                            style: TextStyle(
                              color: AppColors.textoPrincipal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Icon(_expandido
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
                if (_expandido)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SaibaMaisText(textoComTagsBold: info.textoSaibaMais),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
