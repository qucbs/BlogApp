import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/auth/data/datasource/auth_supabase_data_source.dart';
import 'package:blog_app/feature/auth/data/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_supabase_source.dart';
import 'package:blog_app/feature/blog/data/repositories/blog_respositoryimpli.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthSupabaseDataSource>(
    () => AuthSupabaseDataSourceImpl(supabaseClient: serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImp(authSupabaseDataSource: serviceLocator()),
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

  // Repository
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryimpl(serviceLocator()),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => UploadBlog(serviceLocator()),
  );

  // Bloc
  serviceLocator.registerLazySingleton(() => BlogBloc(uploadBlog: serviceLocator()));
}
