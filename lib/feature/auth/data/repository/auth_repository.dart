import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/auth/data/datasource/auth_supabase_data_source.dart';
import 'package:blog_app/core/common/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthRepositoryImp implements AuthRepository {
  final AuthSupabaseDataSource authSupabaseDataSource;
  AuthRepositoryImp({required this.authSupabaseDataSource});

  @override
  Future<Either<Failure, User>> signinwithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await authSupabaseDataSource.signinWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signupwithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getCurrentUser(
      () async => await authSupabaseDataSource.signupWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getCurrentUser(
    Future<User> Function() getCurrentUser,
  ) async {
    try {
      final user = await getCurrentUser();

      return right(user);
    } on supabase.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authSupabaseDataSource.getUserCurrentData();
      if (user == null) {
        return left(Failure('No not Signed in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
