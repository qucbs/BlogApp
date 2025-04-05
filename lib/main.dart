import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: const SignInPage(),
      routes: {
        signinpage: (context) => const SignInPage(),
        signuppage: (context) => const SignUpPage(),
      },
    );
  }
}
