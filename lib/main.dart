import 'package:hyper_ui/core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient supabaseHandler = Supabase.instance.client;
void main() async {
  await initialize();

  runMainApp();
}

runMainApp() async {
  return runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capek Ngoding',
      navigatorKey: Get.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: getDefaultTheme(),
      home: supabaseHandler.auth.currentUser != null
          ? MainNavigationView()
          : LoginView(),
      builder: (context, child) => debugView(
        context: context,
        child: child,
        visible: true,
      ),
    );
  }
}
