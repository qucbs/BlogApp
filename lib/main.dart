import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:blog_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/feature/blog/presentation/screens/add_new_screen.dart';
import 'package:blog_app/feature/blog/presentation/screens/blog_screen.dart';
import 'package:blog_app/feature/blog/presentation/screens/blog_viewer.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:blog_app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthisuserSignedIn());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppuserSignedIn;
        },
        builder: (context, isSignedIn) {
          if (isSignedIn) {
            return const BlogScreen();
          }
          return const SignInPage();
        },
      ),
      routes: {
        signinpage: (context) => const SignInPage(),
        signuppage: (context) => const SignUpPage(),
        blogpage: (context) => const BlogScreen(),
        addnewscreen: (context) => const AddNewScreen(),
        blogviewer: (context) {
          final blog = ModalRoute.of(context)!.settings.arguments as Blog;
          return BlogViewerScreen(blog: blog);
        },
      },
    );
  }
}
