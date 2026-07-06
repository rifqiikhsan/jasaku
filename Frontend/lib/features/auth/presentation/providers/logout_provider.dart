import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:jasaku/features/auth/presentation/providers/auth_state_provider.dart';
import '../../../../core/storage/secure_storage.dart';

class LogoutNotifier extends StateNotifier<bool> {
  final Ref _ref;

  LogoutNotifier(this._ref) : super(false);

  Future<void> logout(VoidCallback onSuccess) async {
    state = true;
    await _ref.read(secureStorageProvider).clearAll();
    _ref.read(authStateProvider.notifier).setUnauthenticated();
    state = false;
    onSuccess();
  }
}

final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>(
  (ref) => LogoutNotifier(ref),
);
