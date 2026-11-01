import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_ppb_kelompok_1/pages/auth_page.dart';

Future<void> _pumpAuth(WidgetTester tester) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const MaterialApp(home: AuthPage()));
}

void main() {
  testWidgets('login kosong menampilkan pesan validasi', (tester) async {
    await _pumpAuth(tester);

    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });

  testWidgets('email tidak valid dan password pendek ditolak', (tester) async {
    await _pumpAuth(tester);

    await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'abc');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '123');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();

    expect(find.text('Format email tidak valid'), findsOneWidget);
    expect(find.text('Password minimal 6 karakter'), findsOneWidget);
  });

  testWidgets('mode daftar menampilkan nama, lokasi, dan pilihan role', (tester) async {
    await _pumpAuth(tester);

    expect(find.widgetWithText(TextFormField, 'Nama'), findsNothing);

    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pump();

    expect(find.widgetWithText(TextFormField, 'Nama'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Lokasi (kota)'), findsOneWidget);
    expect(find.text('Pencari jasa'), findsOneWidget);
    expect(find.text('Penyedia jasa'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
    await tester.pump();

    expect(find.text('Nama wajib diisi'), findsOneWidget);
    expect(find.text('Lokasi wajib diisi'), findsOneWidget);
  });
}
