class PhoneDisplayFormatter {
  /// Formata um telefone salvo apenas com números para exibição.
  /// Ex: 11999998888 → (11) 99999-8888
  static String format(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      return '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 6)}-${digits.substring(6)}';
    }

    if (digits.length == 11) {
      return '(${digits.substring(0, 2)}) '
          '${digits.substring(2, 7)}-${digits.substring(7)}';
    }

    return phone;
  }
}
