import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usercase/usecase.dart';
import 'package:blog_app/core/common/user.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  }) : _userSignIn = userSignIn,
       _userSignUp = userSignUp,
       _currentUser = currentUser,
        _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading() )) ;
    on<AuthSignup>(_onAuthSignUp);
    on<AuthSignin>(_onAuthSignIn);
    on<AuthisuserSignedIn>(_onAuthisuserSignedIn);
  }

  void _onAuthisuserSignedIn(
    AuthisuserSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _currentUser(Noparams());

    result.fold(
      (failure) => emit(AuthFaliure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    final response = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    response.fold(
      (failure) => emit(AuthFaliure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignIn(AuthSignin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final responce = await _userSignIn(
      UserSignInParams(email: event.email, password: event.password),
    );
    responce.fold(
      (failure) => emit(AuthFaliure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    emit(AuthSuccess(user: user));
    _appUserCubit.updateUser(user);
  }
}
