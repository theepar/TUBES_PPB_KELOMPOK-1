import 'package:flutter/material.dart';
import '../utils/currency_formatter.dart';

class RupiahText extends StatelessWidget {
  final num nominal;
  final TextStyle? style;
  final String? prefix;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const RupiahText(
    this.nominal, {
    super.key,
    this.style,
    this.prefix,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = formatRupiah(nominal);
    final text = prefix != null ? '$prefix $formatted' : formatted;

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
