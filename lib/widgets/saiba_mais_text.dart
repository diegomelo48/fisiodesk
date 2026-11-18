import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Renderiza um texto com marcação simples `<b>...</b>` (como vinha em
/// strings.xml) em negrito, preservando as quebras de linha.
class SaibaMaisText extends StatelessWidget {
  final String textoComTagsBold;
  const SaibaMaisText({super.key, required this.textoComTagsBold});

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'<b>(.*?)</b>', dotAll: true);
    int cursor = 0;

    for (final match in regex.allMatches(textoComTagsBold)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: textoComTagsBold.substring(cursor, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      cursor = match.end;
    }
    if (cursor < textoComTagsBold.length) {
      spans.add(TextSpan(text: textoComTagsBold.substring(cursor)));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textoPrincipal,
          fontSize: 15,
          height: 1.4,
        ),
        children: spans,
      ),
    );
  }
}
