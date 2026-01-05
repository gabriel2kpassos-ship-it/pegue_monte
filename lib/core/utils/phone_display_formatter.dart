class PhoneDisplayFormatter {
  static String format(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (digits.length < 10) return phone;

    final ddd = digits.substring(0, 2);
    final prefix = digits.substring(2, digits.length == 11 ? 7 : 6);
    final suffix = digits.substring(digits.length == 11 ? 7 : 6);

    return '($ddd) $prefix-$suffix';
  }
}
