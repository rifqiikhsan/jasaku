import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../shared/enums/user_role.dart';
import '../../data/repositories/auth_repository_impl.dart';
import './auth_state_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../../home/presentation/screen/home_switcher_screen.dart';

// ── State ────────────────────────────────────────────────────────────────────

// Sentinel untuk membedakan "tidak dipass" vs "sengaja null"
const _keep = Object();

class LoginState {
  final UserRole selectedRole;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    this.selectedRole = UserRole.pencariJasa,
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    UserRole? selectedRole,
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    Object? errorMessage = _keep,
  }) {
    return LoginState(
      selectedRole: selectedRole ?? this.selectedRole,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _keep
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class LoginNotifier extends StateNotifier<LoginState> {
  final Ref _ref;

  LoginNotifier(this._ref) : super(const LoginState());

  void setRole(UserRole role) => state = state.copyWith(selectedRole: role);
  void setEmail(String value) => state = state.copyWith(email: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);

  Future<void> login(VoidCallback onSuccess) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _ref
        .read(loginUsecaseProvider)
        .call(
          email: state.email,
          password: state.password,
          role: state.selectedRole,
        );

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (auth) {
        NotificationService.showLoginSuccess(auth.user.fullName);
        _ref.invalidate(homeUserRoleProvider);
        _ref.invalidate(homeUFullNameProvider);
        _ref
            .read(authStateProvider.notifier)
            .setAuthenticated(); // baru trigger redirect
        onSuccess();
      },
    );

    state = state.copyWith(isLoading: false);
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref),
);
