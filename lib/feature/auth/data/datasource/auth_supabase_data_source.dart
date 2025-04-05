import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Future<String> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> signinWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthSupabaseDataSourceImpl implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement signinWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException('No user found');
      }
      return response.user!.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
