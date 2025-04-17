import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/auth/data/datasource/auth_supabase_data_source.dart';
import 'package:blog_app/feature/auth/data/repository/auth_repository_impli.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_supabase_source.dart';
import 'package:blog_app/feature/blog/data/repositories/blog_respositoryimpli.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerFactory(() => InternetConnection());
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()));
}

void _initAuth() {
  serviceLocator.registerFactory<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImp( serviceLocator(), serviceLocator())
  );



  serviceLocator.registerFactory(
    () => UserSignUp(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => UserSignIn(authRepository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(authRepository: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlog() {
  // Data Sources
  serviceLocator.registerFactory<BlogSupabaseSource>(
    () => BlogSupabaseSourceImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(serviceLocator()));

  // Repository
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryimpl(serviceLocator(), serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory<GetAllBlogs>(
    () => GetAllBlogs(serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerFactory(() => UploadBlog(serviceLocator()));

  // Bloc
  serviceLocator.registerLazySingleton(
    () => BlogBloc(uploadblog: serviceLocator(), getAllBlogs: serviceLocator()),
  );
}
