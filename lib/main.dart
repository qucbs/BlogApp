import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/feature/auth/data/datasource/auth_supabase_data_source.dart';
import 'package:blog_app/feature/auth/data/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  final supabaseClient = Supabase.instance.client;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => AuthBloc(
                userSignUp: UserSignUp(
                  authRepository: AuthRepositoryImp(
                    authSupabaseDataSource: AuthSupabaseDataSourceImpl(
                      supabaseClient: supabaseClient,
                    ),
                  ),
                ),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
