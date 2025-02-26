import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auth_repository/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository;

  AuthenticationBloc({required this.authRepository})
      : super(const AuthenticationState.unknown()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthenticationState> emit,
  ) async {
    print("Checking authentication status...");
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      print("Is user logged in? $isLoggedIn");
      if (isLoggedIn) {
        final role = await authRepository.getUserRole();
        print("User role: $role");
        emit(AuthenticationState.authenticated(role!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    } catch (e) {
      print("Auth check failed: $e");
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loading());
    print("Login started...");

    try {
      await authRepository.logIn(event.email, event.password);
      final role = await authRepository.getUserRole();

      if (role != null) {
        print("Login successful! Navigating...");
        emit(AuthenticationState.authenticated(
            role)); // ✅ Emits authenticated state
      } else {
        throw Exception("Role not found.");
      }
    } catch (e) {
      print("Login failed: ${e.toString()}");
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await authRepository.logOut();
    emit(const AuthenticationState.unauthenticated());
  }
}
