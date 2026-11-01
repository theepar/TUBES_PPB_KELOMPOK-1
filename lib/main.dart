import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/env.dart';
import 'pages/beranda_page.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Env.terisi) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  } else {
    debugPrint(
      'Supabase belum dikonfigurasi. Jalankan dengan --dart-define-from-file=env.json',
    );
  }
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
