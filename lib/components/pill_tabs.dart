import 'package:flutter/material.dart';

import '../animations/animasi.dart';
import '../utils/app_colors.dart';

class PillTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool compact;
  final bool expand;

  const PillTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.compact = false,
    this.expand = false,
  });

  double get _tinggi => compact ? 32 : 38;
  double get _paddingX => compact ? 12 : 22;
  TextStyle get _gaya => TextStyle(
        fontSize: compact ? 12 : 14,
        fontWeight: FontWeight.w600,
      );

  double _lebarSlot(BuildContext context) {
    var terlebar = 0.0;
    for (final label in labels) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: _gaya),
        textDirection: TextDirection.ltr,
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: 1,
      )..layout();
      if (painter.width > terlebar) terlebar = painter.width;
    }
    return terlebar.ceilToDouble() + _paddingX * 2;
  }

  @override
  Widget build(BuildContext context) {
    final Widget isi;
    if (expand) {
      isi = LayoutBuilder(
        builder: (context, constraints) =>
            _baris(constraints.maxWidth / labels.length),
      );
    } else {
      final slot = _lebarSlot(context);
      isi = SizedBox(width: slot * labels.length, child: _baris(slot));
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: isi,
    );
  }

  Widget _baris(double lebarSlot) {
    return SizedBox(
      height: _tinggi,
      child: Stack(
        children: [
          SlidingIndicator(
            index: selectedIndex,
            lebarSlot: lebarSlot,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(_tinggi / 2),
            ),
          ),
          Row(
            children: [
              for (int i = 0; i < labels.length; i++)
                SizedBox(width: lebarSlot, child: _tab(i)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tab(int i) {
    final selected = i == selectedIndex;
    return Semantics(
      button: true,
      selected: selected,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(i),
          child: AnimatedTint(
            aktif: selected,
            warnaAktif: Colors.white,
            warnaNonaktif: AppColors.inkSoft,
            builder: (context, color) => Center(
              child: Text(
                labels[i],
                maxLines: 1,
                style: _gaya.copyWith(color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
