import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_ppb_kelompok_1/components/navbar.dart';
import 'package:tubes_ppb_kelompok_1/main.dart';

Finder _nav(String label) => find.descendant(
      of: find.byType(Navbar),
      matching: find.text(label),
    );

Future<void> _pilihKategori(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Pilih kategori'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

void main() {
  for (final size in const [Size(360, 740), Size(412, 915), Size(1280, 800)]) {
    testWidgets('beranda tanpa overflow di $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      FlutterError.onError = (d) => fail(d.toString());
      await tester.pumpWidget(const SewaSkillApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('header menampilkan nama dan lokasi pengguna', (tester) async {
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();
    expect(find.text('Hi, Deva'), findsOneWidget);
    expect(find.text('Bandung, Jawa Barat'), findsOneWidget);
  });

  testWidgets('ganti kategori memfilter daftar talent', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();
    expect(find.text('Rizky Aditya'), findsOneWidget);
    expect(find.text('Sari Dewi'), findsOneWidget);

    await _pilihKategori(tester, 'Desain');
    expect(find.text('Sari Dewi'), findsOneWidget);
    expect(find.text('Rizky Aditya'), findsNothing);
  });

  testWidgets('pindah Order lalu kembali ke Beranda tidak stuck', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();

    await tester.tap(_nav('Order'));
    await tester.pumpAndSettle();
    expect(find.byType(AppBar), findsOneWidget);

    final kembali = find.text('Kembali ke Halaman Jasa');
    await tester.ensureVisible(kembali);
    await tester.pumpAndSettle();
    await tester.tap(kembali);
    await tester.pumpAndSettle();
    expect(find.text('Hi, Deva'), findsOneWidget);
    expect(_nav('Beranda'), findsOneWidget);

    await tester.tap(_nav('Order'));
    await tester.pumpAndSettle();
    await tester.tap(_nav('Beranda'));
    await tester.pumpAndSettle();
    await _pilihKategori(tester, 'Desain');
    expect(find.text('Rizky Aditya'), findsNothing);
  });

  testWidgets('angka hero berubah sesuai kategori dan tab', (tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();
    expect(find.text('35.000'), findsOneWidget);

    await _pilihKategori(tester, 'Koding');
    expect(find.text('75.000'), findsOneWidget);

    await tester.tap(find.text('Rating').first);
    await tester.pumpAndSettle();
    expect(find.text('4.7'), findsOneWidget);
  });
}
