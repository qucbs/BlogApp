import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/feature/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthSupabaseDataSource {
  Session? get currentUserSession;

  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getUserCurrentData();
}

class AuthSupabaseDataSourceImpl implements AuthSupabaseDataSource {
  final SupabaseClient supabaseClient;
  AuthSupabaseDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signinWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw ServerException('No user found', StackTrace.current);
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }

  @override
  Future<UserModel> signupWithEmailAndPassword({
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
        throw ServerException('No user found', StackTrace.current);
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }

  @override
  Future<UserModel?> getUserCurrentData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel.fromJson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString(), StackTrace.current);
    }
  }
}
