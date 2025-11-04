import 'package:intl/intl.dart';

final NumberFormat _vndCurrencyFormatter = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);

String formatCurrencyVND(double amount) {
  return _vndCurrencyFormatter.format(amount);
}

String formatCurrencyVNDAbs(double amount) {
  return _vndCurrencyFormatter.format(amount.abs());
}

String formatCurrencySignedVND(double amount) {
  final String formatted = formatCurrencyVNDAbs(amount);
  return amount >= 0 ? '+$formatted' : '-$formatted';
}
