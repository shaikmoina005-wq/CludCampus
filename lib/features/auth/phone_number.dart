/// Indian mobile numbers as E.164 (`+91` plus 10 digits starting 6–9).
String? indianE164(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 12 && digits.startsWith('91')) {
    digits = digits.substring(2);
  } else if (digits.length == 11 && digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(digits)) return null;
  return '+91$digits';
}

/// `9876501001` → `+91 98765 01001`.
String prettyIndianMobile(String nationalOrE164) {
  final digits = nationalOrE164.replaceAll(RegExp(r'\D'), '');
  final national = digits.length >= 10
      ? digits.substring(digits.length - 10)
      : digits;
  if (national.length != 10) return '+91 $nationalOrE164';
  return '+91 ${national.substring(0, 5)} ${national.substring(5)}';
}
