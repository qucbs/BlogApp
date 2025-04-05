import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/auth/data/datasource/auth_supabase_data_source.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthSupabaseDataSource authSupabaseDataSource;
  AuthRepositoryImp({required this.authSupabaseDataSource});

  @override
  Future<Either<Failure, String>> signinwithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signinwithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signupwithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userID = await authSupabaseDataSource.signupWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(userID);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
