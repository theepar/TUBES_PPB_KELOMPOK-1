import 'package:flutter/material.dart';

const durasiAnimasi = Duration(milliseconds: 300);
const durasiHitung = Duration(milliseconds: 500);
const kurvaAnimasi = Curves.easeInOut;

class SlidingIndicator extends StatelessWidget {
  final int index;
  final double lebarSlot;
  final Decoration decoration;

  const SlidingIndicator({
    super.key,
    required this.index,
    required this.lebarSlot,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: durasiAnimasi,
      curve: kurvaAnimasi,
      left: index * lebarSlot,
      top: 0,
      bottom: 0,
      width: lebarSlot,
      child: DecoratedBox(decoration: decoration),
    );
  }
}

class AnimatedTint extends StatelessWidget {
  final bool aktif;
  final Color warnaAktif;
  final Color warnaNonaktif;
  final Widget Function(BuildContext context, Color color) builder;

  const AnimatedTint({
    super.key,
    required this.aktif,
    required this.warnaAktif,
    required this.warnaNonaktif,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: aktif ? warnaAktif : warnaNonaktif),
      duration: durasiAnimasi,
      curve: kurvaAnimasi,
      builder: (context, color, _) =>
          builder(context, color ?? (aktif ? warnaAktif : warnaNonaktif)),
    );
  }
}

class CountUp extends StatelessWidget {
  final double nilai;
  final Widget Function(BuildContext context, double nilai) builder;

  const CountUp({super.key, required this.nilai, required this.builder});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: nilai),
      duration: durasiHitung,
      curve: kurvaAnimasi,
      builder: (context, v, _) => builder(context, v),
    );
  }
}
