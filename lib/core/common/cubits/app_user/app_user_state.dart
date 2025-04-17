part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {}

final class AppUserInitial extends AppUserState {}

final class AppuserSignedIn extends AppUserState {
  final User user;
  AppuserSignedIn(this.user);
}
