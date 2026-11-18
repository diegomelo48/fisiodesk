import 'package:flutter/services.dart';

/// Reproduz a máscara de telefone `(XX) XXXXX-XXXX` implementada com
/// TextWatcher em CadastroActivity e no dialog_editar_perfil (PerfilFragment).
class TelefoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final length = digits.length;
    final buffer = StringBuffer();

    if (length > 0) {
      buffer.write('(');
      buffer.write(digits.substring(0, length < 2 ? length : 2));
      if (length >= 2) buffer.write(') ');
      if (length >= 3 && length <= 6) {
        buffer.write(digits.substring(2));
      } else if (length >= 7 && length <= 10) {
        buffer.write(digits.substring(2, 7));
        buffer.write('-');
        buffer.write(digits.substring(7));
      } else if (length > 10) {
        buffer.write(digits.substring(2, 7));
        buffer.write('-');
        buffer.write(digits.substring(7, length < 11 ? length : 11));
      }
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}
