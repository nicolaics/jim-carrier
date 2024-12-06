import 'package:intl/intl.dart';

class FormatPrice {
  static String formatPrice(dynamic price, String currency) {
    final currencyCode = getCurrencyFormat(currency);

    return "$currencyCode ${NumberFormat('#,##0.0').format(price.toString())}";
  }

  static String getCurrencyFormat(String currency) {
    return NumberFormat.simpleCurrency(name: currency).currencySymbol;
  }
}
