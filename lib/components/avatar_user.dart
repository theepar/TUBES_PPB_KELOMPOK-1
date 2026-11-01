import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../utils/app_colors.dart';

class AvatarUser extends StatelessWidget {
  final String nama;
  final String? avatarPath;
  final double radius;

  const AvatarUser({
    super.key,
    required this.nama,
    this.avatarPath,
    this.radius = 22,
  });

  String get _inisial {
    final bersih = nama.trim();
    return bersih.isEmpty ? '?' : bersih.substring(0, 1).toUpperCase();
  }

  Widget _huruf() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        _inisial,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final path = avatarPath;
    if (path == null || path.isEmpty || !Env.terisi) return _huruf();

    final url = Supabase.instance.client.storage.from('avatar').getPublicUrl(path);
    return ClipOval(
      child: Image.network(
        url,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _huruf(),
      ),
    );
  }
}
