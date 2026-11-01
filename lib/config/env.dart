// Nilai dibaca dari --dart-define-from-file=env.json (file itu masuk .gitignore).
// Contoh isi ada di env.example.json.
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get terisi => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
