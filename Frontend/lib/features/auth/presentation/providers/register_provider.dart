import 'dart:ui';

import 'package:flutter_riverpod/legacy.dart';
import '../../../../shared/enums/user_role.dart';

// ── State ────────────────────────────────────────────────────────────────────

class RegisterState {
  final UserRole selectedRole;
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    this.selectedRole = UserRole.pencariJasa,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    UserRole? selectedRole,
    String? name,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      selectedRole: selectedRole ?? this.selectedRole,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(const RegisterState());

  void setRole(UserRole role) => state = state.copyWith(selectedRole: role);
  void setName(String value) => state = state.copyWith(name: value);
  void setEmail(String value) => state = state.copyWith(email: value);
  void setPhone(String value) => state = state.copyWith(phone: value);
  void setPassword(String value) => state = state.copyWith(password: value);
  void setConfirmPassword(String value) =>
      state = state.copyWith(confirmPassword: value);

  Future<void> register(VoidCallback onSuccess) async {
    if (state.password != state.confirmPassword) {
      state = state.copyWith(errorMessage: 'Password tidak cocok');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // TODO: ganti dengan API call sesuai role (state.selectedRole)
      await Future.delayed(const Duration(seconds: 2));
      onSuccess();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (_) => RegisterNotifier(),
);
