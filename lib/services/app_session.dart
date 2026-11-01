import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/env.dart';
import '../pengguna.dart';

class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  Pengguna? _profile;
  bool _isAdminMode = false;
  bool _akunDiblokir = false;

  Pengguna? get profile => _profile;
  bool get akunDiblokir => _akunDiblokir;
  bool get isLoggedIn => _profile != null;
  String? get userId => _profile?.id;

  bool get isAdmin => _profile?.role == 'admin';
  bool get isPenyedia => _profile?.role == 'penyedia';
  bool get isPencari => _profile?.role == 'pencari';

  bool get isAdminMode => _isAdminMode;

  set isAdminMode(bool value) {
    final next = value && isAdmin;
    if (next == _isAdminMode) return;
    _isAdminMode = next;
    notifyListeners();
  }

  Future<void> muatProfil() async {
    if (!Env.terisi) return;

    final db = Supabase.instance.client;
    final user = db.auth.currentUser;
    if (user == null) {
      _reset();
      return;
    }

    final row = await db.from('profiles').select().eq('id', user.id).maybeSingle();
    if (row == null) {
      _reset();
      return;
    }

    final pengguna = Pengguna.fromMap(row);
    if (pengguna.diblokir) {
      await db.auth.signOut();
      _reset();
      _akunDiblokir = true;
      notifyListeners();
      return;
    }

    _akunDiblokir = false;
    _profile = pengguna;
    if (!isAdmin) _isAdminMode = false;
    notifyListeners();
  }

  Future<void> keluar() async {
    if (Env.terisi) {
      await Supabase.instance.client.auth.signOut();
    }
    _reset();
  }

  @visibleForTesting
  void setProfileUntukTest(Pengguna? pengguna) {
    _profile = pengguna;
    notifyListeners();
  }

  void _reset() {
    _profile = null;
    _isAdminMode = false;
    _akunDiblokir = false;
    notifyListeners();
  }
}
