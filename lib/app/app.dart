import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import '../core/theme/app_spacing.dart';

import 'main_page.dart';
import '../features/auth/pages/auth_page.dart';
import '../features/admin/pages/admin_shell_page.dart';
import '../core/data/demo_store.dart';
import '../core/theme/app_colors.dart';

class SewaSkillApp extends StatelessWidget {
  const SewaSkillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SewaSkill',
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.ink),
          bodyLarge: TextStyle(color: AppColors.ink),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          minVerticalPadding: 12,
          iconColor: AppColors.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          errorMaxLines: 2,
          errorStyle: const TextStyle(fontSize: 12, height: 1.5),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: Color(0xFFB3261E)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
            borderSide: const BorderSide(color: AppColors.track),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.track),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: AppColors.primary,
          showCheckmark: false,
          side: BorderSide.none,
          shape: const StadiumBorder(),
          labelStyle: const TextStyle(fontFamily: 'Roboto'),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          constraints: BoxConstraints(maxWidth: 720),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.controlHeight),
            visualDensity: VisualDensity.standard,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: const StadiumBorder(),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const StadiumBorder(),
            minimumSize: const Size(0, 48),
            visualDensity: VisualDensity.standard,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style:
              FilledButton.styleFrom(
                minimumSize: const Size(0, AppSpacing.controlHeight),
                visualDensity: VisualDensity.standard,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
                shape: const StadiumBorder(),
              ).copyWith(
                elevation: const WidgetStatePropertyAll(0),
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                surfaceTintColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
              ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFC5E1FA),
              AppColors.background,
              AppColors.background,
            ],
            stops: [0, 0.55, 1],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: child,
          ),
        ),
      ),
      home: ListenableBuilder(
        listenable: DemoStore.instance,
        builder: (context, _) => DemoStore.instance.pengguna == null
            ? const AuthPage()
            : DemoStore.instance.isAdmin
            ? const AdminShellPage()
            : MainPage(pengguna: DemoStore.instance.pengguna!),
      ),
    );
  }
}
