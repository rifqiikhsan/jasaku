import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole { pencariJasa, penyediaJasa }

const _sentinel = Object();

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
    Object? errorMessage = _sentinel,
  }) {
    return LoginState(
      selectedRole: selectedRole ?? this.selectedRole,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _sentinel
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

class LoginNotifier extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setRole(UserRole role) => state = state.copyWith(selectedRole: role);

  void setEmail(String value) => state = state.copyWith(email: value);

  void setPassword(String value) => state = state.copyWith(password: value);

  void togglePasswordVisibility() =>
      state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);

  Future<void> login(VoidCallback onSuccess) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(errorMessage: 'Email dan kata sandi wajib diisi');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);
    onSuccess();
  }
}

final loginProvider = NotifierProvider.autoDispose<LoginNotifier, LoginState>(
  LoginNotifier.new,
);
