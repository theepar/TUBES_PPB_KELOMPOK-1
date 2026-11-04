import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = _resolve(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.40)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  static (String, Color) _resolve(String status) {
    switch (status) {
      case 'menunggu_pembayaran':
        return ('Menunggu Pembayaran', Colors.orange);
      case 'dibayar':
        return ('Dibayar', Colors.blue);
      case 'dikirim':
        return ('Selesai Dikerjakan', Colors.purple);
      case 'menunggu_admin':
        return ('Menunggu Persetujuan Admin', Colors.amber.shade700);
      case 'selesai':
        return ('Selesai', Colors.green);
      case 'direfund':
        return ('Direfund', Colors.red);
      case 'dibatalkan':
        return ('Dibatalkan', Colors.grey);
      default:
        return (status, Colors.grey);
    }
  }
}
