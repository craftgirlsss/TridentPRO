class NumberFormatter {
  static String formatCardNumber(String number) {
    return number.replaceAllMapped(
        RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trim();
  }

  static String formatPrice(String price, {required String currency}) {
    double? value = double.tryParse(price);

    if (value == null) {
      // Handle cases where the string is not a valid double.
      print("Warning: '$price' is not a valid number.");
      return price; // Or throw an error, or return a default.
    }

    // Convert the currency code to uppercase for case-insensitive comparison
    final String upperCaseCurrency = currency.toUpperCase();

    if (upperCaseCurrency.contains("JPY")) {
      // For JPY, format to 3 decimal places
      return value.toStringAsFixed(3);
    } else {
      // For other currencies, format to 5 decimal places
      return value.toStringAsFixed(5);
    }
  }
}


class PriceParts {
  final String? first;  // First 3 "digits" (excluding decimal)
  final String? second; // Next 2 "digits" (excluding decimal)
  final String? third;  // Last "digit" (excluding decimal)

  PriceParts({this.first, this.second, this.third});

  @override
  String toString() {
    return 'PriceParts(first: $first, second: $second, third: $third)';
  }
}

String formatPrice(String price, {required String currency}) {
  double? value = double.tryParse(price);

  if (value == null) {
    print("Warning: '$price' is not a valid number for formatting.");
    return price; // Return original string or handle error as per app logic
  }

  final String upperCaseCurrency = currency.toUpperCase();

  if (upperCaseCurrency.contains("JPY")) {
    return value.toStringAsFixed(3);
  } else {
    return value.toStringAsFixed(5);
  }
}


PriceParts extractPriceParts(String price) {
  String cleanedPrice = price.replaceAll('.', '');

  String? firstPart;
  String? secondPart;
  String? thirdPart;

  if (cleanedPrice.length >= 3) {
    firstPart = cleanedPrice.substring(0, 3);
  }

  // Extract 'second': characters from index 3 until 4 (meaning index 3 and 4)
  if (cleanedPrice.length >= 5) {
    secondPart = cleanedPrice.substring(3, 5);
  }

  // Extract 'third': the character at the last index of the cleaned string
  if (cleanedPrice.isNotEmpty) {
    thirdPart = cleanedPrice[cleanedPrice.length - 1];
  }

  return PriceParts(first: firstPart, second: secondPart, third: thirdPart);
}

PriceParts processAndExtractPriceParts(String originalPrice, {required String currency}) {
  // Step 1: Format the price string according to currency rules
  String formattedPrice = formatPrice(originalPrice, currency: currency);
  print('Original Price: "$originalPrice", Formatted Price ($currency): "$formattedPrice"');
  return extractPriceParts(formattedPrice);
}