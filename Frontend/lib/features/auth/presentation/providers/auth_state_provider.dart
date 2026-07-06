import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/storage/secure_storage.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthStateNotifier extends StateNotifier<AuthStatus> {
  final Ref _ref;

  AuthStateNotifier(this._ref) : super(AuthStatus.unknown) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final hasToken = await _ref.read(secureStorageProvider).hasAccessToken();
    state = hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }

  void setAuthenticated() => state = AuthStatus.authenticated;
  void setUnauthenticated() => state = AuthStatus.unauthenticated;
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthStatus>(
  (ref) => AuthStateNotifier(ref),
);
