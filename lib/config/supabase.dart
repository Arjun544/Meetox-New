import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/imports/packages_imports.dart';

late SupabaseClient supabase;

Future<void> supabaseInit() async {
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['ANON_KEY']!,
  );

  supabase = Supabase.instance.client;
}
