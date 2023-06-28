import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://isycyynxhwdoyripictp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlzeWN5eW54aHdkb3lyaXBpY3RwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODczMzkzMzIsImV4cCI6MjAwMjkxNTMzMn0.VKA8y7Z37TrynBQahUrgXIcxwcBBdhfGXnMctb73MCk',
  );
}
