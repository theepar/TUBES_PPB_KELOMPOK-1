import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SewaSkillLogo extends StatelessWidget {
  final double size;

  const SewaSkillLogo({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Logo SewaSkill',
    image: true,
    child: SvgPicture.asset(
      'assets/sewaskill_logo.svg',
      width: size,
      height: size,
    ),
  );
}
