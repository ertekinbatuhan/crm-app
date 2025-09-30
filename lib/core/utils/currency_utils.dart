import 'package:intl/intl.dart';

class CurrencyUtils {
  static final NumberFormat _dollarFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _numberFormat = NumberFormat('#,##0.00', 'en_US');

  static String formatCurrency(double? amount) {
    if (amount == null) return '\$0.00';
    return _dollarFormat.format(amount);
  }

  static String formatNumber(double? number) {
    if (number == null) return '0.00';
    return _numberFormat.format(number);
  }

  static double? parseAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    
    String cleanValue = value
        .replaceAll('\$', '')
        .replaceAll(',', '')
        .trim();
    
    return double.tryParse(cleanValue);
  }

  static String formatPercentage(double? percentage) {
    if (percentage == null) return '0%';
    return '${_numberFormat.format(percentage)}%';
  }
}