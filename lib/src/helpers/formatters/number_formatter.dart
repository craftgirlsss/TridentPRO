class NumberFormatter{
  static String formatCardNumber(String number) {
    return number.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trim();
  }
}