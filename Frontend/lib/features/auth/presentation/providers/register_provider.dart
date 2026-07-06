import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../shared/enums/user_role.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/services/notification_service.dart';

// ── State ────────────────────────────────────────────────────────────────────

const _keep = Object();

class RegisterState {
  final UserRole selectedRole;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    this.selectedRole = UserRole.pencariJasa,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    UserRole? selectedRole,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    Object? errorMessage = _keep,
  }) {
    return RegisterState(
      selectedRole: selectedRole ?? this.selectedRole,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage == _keep
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class RegisterNotifier extends StateNotifier<RegisterState> {
  final Ref _ref;

  RegisterNotifier(this._ref) : super(const RegisterState());

  void setRole(UserRole role) => state = state.copyWith(selectedRole: role);
  void setFullName(String value) => state = state.copyWith(fullName: value);
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

    final result = await _ref
        .read(registerUsecaseProvider)
        .call(
          fullName: state.fullName,
          email: state.email,
          phone: state.phone,
          password: state.password,
          role: state.selectedRole,
        );

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        NotificationService.showRegisterSuccess(state.fullName);
        onSuccess();
      },
    );

    state = state.copyWith(isLoading: false);
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(ref),
);
