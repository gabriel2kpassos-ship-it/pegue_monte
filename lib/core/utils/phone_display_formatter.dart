String formatPhone(String phone) {
  if (phone.length != 11) return phone;

  return '(${phone.substring(0, 2)}) '
      '${phone.substring(2, 7)}-'
      '${phone.substring(7)}';
}
