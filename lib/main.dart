import 'package:flutter/material.dart';

import 'pages/beranda_page.dart';
import 'pages/order_page.dart';
import 'talent_data.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const BerandaPage(),
    );
  }
}
