import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Tela genérica de PDF, equivalente a:
///   - GuiaAppActivity (pdfView.fromAsset("Guia-FisioDesk.pdf"))
///   - GuiaAplicacaoActivity (pdfView.fromAsset("Guia-aplicação-pedagogica.pdf"))
///   - MetodosActivity (baixa de uma URL antes de exibir)
class PdfViewerScreen extends StatelessWidget {
  final String titulo;

  /// Um dos dois deve ser informado.
  final String? assetPath;
  final String? networkUrl;

  const PdfViewerScreen({
    super.key,
    required this.titulo,
    this.assetPath,
    this.networkUrl,
  }) : assert(assetPath != null || networkUrl != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: networkUrl != null
          ? SfPdfViewer.network(networkUrl!)
          : SfPdfViewer.asset(assetPath!),
    );
  }
}
