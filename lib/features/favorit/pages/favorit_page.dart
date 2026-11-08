import '../../../app/app_route.dart';

import 'package:flutter/material.dart';

import '../../../core/data/demo_store.dart';
import '../../../core/data/talent_data.dart';
import '../../../core/widgets/talent_card.dart';
import '../../../core/widgets/demo_ui.dart';
import '../../jasa/pages/detail_jasa_page.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});
  @override
  Widget build(BuildContext context) {
    final store = DemoStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Favorit')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final list = daftarTalent
              .where((t) => t.tampil && store.favorit.contains(t.id))
              .toList();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: Text('Belum ada favorit')),
                ),
              for (final talent in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TalentCard(
                    talent: talent,
                    isFavorit: true,
                    onToggleFavorit: () async {
                      if (await konfirmasi(
                            context,
                            'Hapus favorit?',
                            'Hapus jasa ini dari favorit?',
                          ) &&
                          context.mounted) {
                        store.toggleFavorit(talent.id);
                      }
                    },
                    onTap: () => Navigator.push(
                      context,
                      AppRoute(builder: (_) => DetailJasaPage(talent: talent)),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
