class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
  );

  static bool get terisi => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
