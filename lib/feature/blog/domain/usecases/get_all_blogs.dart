import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/feature/blog/domain/entity/blog.dart';
import 'package:blog_app/feature/blog/domain/repository/bloc_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, Noparams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(Noparams params) async {
    return await blogRepository.getAllBlogs();
  }
}
