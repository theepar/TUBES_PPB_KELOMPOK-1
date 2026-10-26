import 'package:flutter/material.dart';

import 'pages/beranda_page.dart';
import 'utils/app_colors.dart';

void main() {
  runApp(const SewaSkillApp());
}

class SewaSkillApp extends StatelessWidget {
  const SewaSkillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SewaSkill',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.ink,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const BerandaPage(),
    );
  }
}
