import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  /// Formata o telefone enquanto o usuário digita.
  /// Padrão: (99) 99999-9999 ou (99) 9999-9999
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = digitsOnly;

    if (digitsOnly.length >= 2) {
      formatted = '(${digitsOnly.substring(0, 2)})';
    }

    if (digitsOnly.length > 2 && digitsOnly.length <= 6) {
      formatted += ' ${digitsOnly.substring(2)}';
    } else if (digitsOnly.length > 6 && digitsOnly.length <= 10) {
      formatted +=
          ' ${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length > 10) {
      formatted +=
          ' ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
