import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubes_ppb_kelompok_1/components/navbar.dart';
import 'package:tubes_ppb_kelompok_1/main.dart';
import 'package:tubes_ppb_kelompok_1/pages/profil_page.dart';
import 'package:tubes_ppb_kelompok_1/pengguna.dart';
import 'package:tubes_ppb_kelompok_1/services/app_session.dart';
import 'package:tubes_ppb_kelompok_1/utils/currency_formatter.dart';

Pengguna _user(String role) => Pengguna(
      id: 'uji-$role',
      nama: 'Uji $role',
      lokasi: 'Bandung',
      role: role,
      status: 'aktif',
      saldo: 150000,
    );

Finder _nav(String label) => find.descendant(
      of: find.byType(Navbar),
      matching: find.text(label),
    );

void _layar(WidgetTester tester) {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() {
    AppSession.instance.isAdminMode = false;
  });

  testWidgets('profil menampilkan nama, role, dan saldo', (tester) async {
    _layar(tester);
    AppSession.instance.setProfileUntukTest(_user('pencari'));
    await tester.pumpWidget(const MaterialApp(home: ProfilPage()));

    expect(find.text('Uji pencari'), findsOneWidget);
    expect(find.text('Pencari jasa'), findsOneWidget);
    expect(find.text(formatRupiah(150000)), findsOneWidget);
    expect(find.text('Edit Profil'), findsOneWidget);
  });

  testWidgets('Mode Admin tersembunyi untuk non-admin', (tester) async {
    _layar(tester);
    AppSession.instance.setProfileUntukTest(_user('penyedia'));
    await tester.pumpWidget(const MaterialApp(home: ProfilPage()));

    expect(find.text('Mode Admin'), findsNothing);
  });

  testWidgets('Mode Admin tampil untuk admin dan bisa dinyalakan', (tester) async {
    _layar(tester);
    AppSession.instance.setProfileUntukTest(_user('admin'));
    await tester.pumpWidget(const MaterialApp(home: ProfilPage()));

    expect(find.text('Mode Admin'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(AppSession.instance.isAdminMode, isTrue);
  });

  test('Mode Admin tidak bisa dinyalakan oleh non-admin', () {
    AppSession.instance.setProfileUntukTest(_user('pencari'));
    AppSession.instance.isAdminMode = true;
    expect(AppSession.instance.isAdminMode, isFalse);
  });

  testWidgets('navbar berganti dari 5 tab ke 3 tab saat Mode Admin menyala', (tester) async {
    _layar(tester);
    AppSession.instance.setProfileUntukTest(_user('admin'));
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();

    for (final label in ['Beranda', 'Katalog', 'Riwayat', 'Favorit', 'Profil']) {
      expect(_nav(label), findsOneWidget);
    }
    expect(_nav('Pembelian'), findsNothing);

    await tester.tap(_nav('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(_nav('Pembelian'), findsOneWidget);
    expect(_nav('Akun'), findsOneWidget);
    expect(_nav('Profil'), findsOneWidget);
    expect(_nav('Katalog'), findsNothing);

    // Dimatikan lagi: kembali ke 5 tab.
    await tester.tap(_nav('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(_nav('Katalog'), findsOneWidget);
    expect(_nav('Pembelian'), findsNothing);
  });

  testWidgets('tombol Tambah Jasa hanya untuk penyedia', (tester) async {
    _layar(tester);

    AppSession.instance.setProfileUntukTest(_user('pencari'));
    await tester.pumpWidget(const SewaSkillApp());
    await tester.pumpAndSettle();
    expect(find.byTooltip('Tambah Jasa'), findsNothing);

    AppSession.instance.setProfileUntukTest(_user('penyedia'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Tambah Jasa'), findsOneWidget);
  });
}
