import 'package:flutter/material.dart';

import '../../order/pages/riwayat_order_page.dart';

class AdminPembelianPage extends StatelessWidget {
  const AdminPembelianPage({super.key});
  @override
  Widget build(BuildContext context) => const RiwayatOrderPage(admin: true);
}
