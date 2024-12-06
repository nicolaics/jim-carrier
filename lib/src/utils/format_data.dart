import 'package:intl/intl.dart';

class FormatPrice {
  static String formatPrice(dynamic price, String currency) {
    final currencyCode = getCurrencyFormat(currency);
    double priceValue = price is double ? price : price.toDouble();

    return "$currencyCode${NumberFormat('#,##0.0').format(priceValue)}";
  }

  static String getCurrencyFormat(String currency) {
    return NumberFormat.simpleCurrency(name: currency).currencySymbol;
  }

  // NumberFormat _getCurrencyFormat(String currency) {
  //   switch (currency) {
  //     case 'USD':
  //       return NumberFormat.simpleCurrency(name: 'USD');
  //     case 'KRW':
  //       return NumberFormat.currency(locale: 'ko_KR', symbol: '₩');
  //     case 'EUR':
  //       return NumberFormat.currency(locale: 'de_DE', symbol: '€');
  //     case 'JPY':
  //       return NumberFormat.currency(locale: 'ja_JP', symbol: '¥');
  //     default:
  //       return NumberFormat.currency(locale: 'en_US', symbol: '\$');
  //   }
  // }
}

class FormatWeight {
  static String formatWeight(dynamic weight) {
    double weightDouble = weight is double ? weight : weight.toDouble();
    return NumberFormat('#,##0.0').format(weightDouble);
  }
}

class FormatDate {
  static String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "Unknown date"; // Return "Unknown date" if no date is available
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('MMM dd, yyyy').format(parsedDate); // Format the date
    } catch (e) {
      return "Invalid date"; // Return "Invalid date" if the format is not correct
    }
  }
}

String removeCommas(String string) {
    return string.replaceAll(',', '');
  }