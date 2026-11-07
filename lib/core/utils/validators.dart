class Validators {
  Validators._();

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static bool emailValid(String value) => _email.hasMatch(value.trim());

  static String? email(String? value) =>
      value == null || !emailValid(value) ? 'Isi email yang valid' : null;

  static String? password(String? value) =>
      value == null || value.length < 6 ? 'Minimal 6 karakter' : null;
}
