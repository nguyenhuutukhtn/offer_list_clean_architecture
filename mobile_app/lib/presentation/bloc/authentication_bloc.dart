import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/services/auth_service.dart';

// Events
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LoginWithTokenEvent extends AuthenticationEvent {}

class RegisterEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const RegisterEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthenticationEvent {}

// States
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService authService;

  AuthenticationBloc({required this.authService}) : super(AuthenticationInitial()) {
    on<LoginEvent>(_onLogin);
    on<LoginWithTokenEvent>(_onLoginWithToken);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }


  void _onLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await authService.signIn(event.email, event.password);
      
      emit(Authenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  void _onLoginWithToken(LoginWithTokenEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final isAuthenticated = await authService.checkAndSignInWithToken();
      if (isAuthenticated) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  void _onRegister(RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await authService.signUp(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthenticationError(e.toString()));
    }
  }
}