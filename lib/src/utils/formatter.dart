import 'package:intl/intl.dart';

class Formatter {
  static String formatPrice(dynamic price, String? currency) {
    double? priceValue;

    if (price is double) {
      priceValue = price;
    } else if (price is String) {
      priceValue = double.parse(price);
    } else if (price is int) {
      priceValue = price.toDouble();
    }

    if (currency != null) {
      final currencyCode = getCurrencyFormat(currency);
      return "$currencyCode${NumberFormat('#,##0.0').format(priceValue)}";
    }

    return NumberFormat('#,##0.0').format(priceValue);
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

  static String formatWeight(dynamic weight) {
    double? weightDouble;

    if (weight is double) {
      weightDouble = weight;
    } else if (weight is String) {
      weightDouble = double.parse(weight);
    } else if (weight is int) {
      weightDouble = weight.toDouble();
    }

    return NumberFormat('#,##0.0').format(weightDouble);
  }

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

  static String removeCommas(String string) {
    return string.replaceAll(',', '');
  }
}
