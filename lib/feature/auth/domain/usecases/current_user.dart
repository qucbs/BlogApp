import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, Noparams> {
  final AuthRepository authRepository;
  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(Noparams params) async {
    return await authRepository.currentUser();
  }
}
