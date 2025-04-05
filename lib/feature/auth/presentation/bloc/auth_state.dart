part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final String uid;
  AuthSuccess({required this.uid});
}

final class AuthFaliure extends AuthState {
  final String message;
  AuthFaliure({required this.message});
}
