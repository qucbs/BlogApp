
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;
  const UserSignIn({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignInParams params) async {
    return await authRepository.signinwithEmailAndPassword(
      email: params.email,
      password: params.password, 
    );
  }
  
}

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}