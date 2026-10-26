String formatRupiah(num nominal) {
  final str = nominal.round().toString();
  final isNegative = str.startsWith('-');
  final cleanStr = isNegative ? str.substring(1) : str;

  final buffer = StringBuffer();
  for (int i = 0; i < cleanStr.length; i++) {
    if (i > 0 && (cleanStr.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(cleanStr[i]);
  }

  final prefix = isNegative ? '-Rp ' : 'Rp ';
  return '$prefix$buffer';
}

extension CurrencyExtension on num {
  String toRupiah() => formatRupiah(this);
}
