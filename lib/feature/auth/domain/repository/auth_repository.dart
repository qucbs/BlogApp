import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/common/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signupwithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signinwithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
