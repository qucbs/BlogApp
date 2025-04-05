import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp({required this.authRepository});
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signupwithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
