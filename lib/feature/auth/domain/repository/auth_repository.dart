import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signupwithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signinwithEmailAndPassword({
    required String email,
    required String password,
  });
}
