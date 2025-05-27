import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatusRequested extends AuthEvent {}

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User? user;

  const AuthAuthenticated({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final AuthRepository repository;

  AuthBloc({
    required this.loginUseCase,
    required this.repository,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await loginUseCase(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) {
          emit(AuthAuthenticated(user: user));
          // Ensure the state is properly updated in the UI
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('⚠️ AuthBloc: Handling LogoutRequested event');
    emit(AuthLoading());
    try {
      // Llamar al método logout del repositorio para eliminar el token
      await repository.logout();
      print('✅ AuthBloc: Logout successful, token cleared, emitting AuthUnauthenticated');
      emit(AuthUnauthenticated());
    } catch (e) {
      print('❌ AuthBloc: Error during logout: $e');
      // En caso de error, seguimos emitiendo AuthUnauthenticated para cerrar la sesión
      // pero registramos el error para diagnóstico
      print('⚠️ AuthBloc: Despite error, emitting AuthUnauthenticated');
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCheckAuthStatusRequested(
    CheckAuthStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await repository.getToken();
      if (token != null) {
        final user = await repository.getCurrentUser();
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: 'Failed to check auth status: $e'));
    }
  }
}
