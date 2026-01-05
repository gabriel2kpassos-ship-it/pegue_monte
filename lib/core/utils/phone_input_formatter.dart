import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = '';

    if (digitsOnly.isNotEmpty) {
      formatted += '(';
      formatted += digitsOnly.substring(0, digitsOnly.length.clamp(0, 2));
    }

    if (digitsOnly.length > 2) {
      formatted += ') ';
      formatted += digitsOnly.substring(2, digitsOnly.length.clamp(2, 7));
    }

    if (digitsOnly.length > 7) {
      formatted += '-';
      formatted += digitsOnly.substring(7, digitsOnly.length.clamp(7, 11));
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
