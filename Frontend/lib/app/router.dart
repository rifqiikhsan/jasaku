import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:jasaku/features/profile/presentation/screen/profile_screen.dart';
import '../features/auth/presentation/providers/auth_state_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/home/presentation/screen/home_screen.dart';
import '../features/search/presentation/screen/search_screen.dart';
import '../features/splash/splash_screen.dart';
import '../shared/widgets/main_shell.dart';

const _guestRoutes = ['/login', '/register'];
const _protectedRoutes = ['/home', '/chat', '/profile'];

final _routerNotifierProvider = ChangeNotifierProvider<_RouterNotifier>(
  (ref) => _RouterNotifier(ref),
);

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(_routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authStatus = ref.read(authStateProvider);
      final location = state.matchedLocation;

      if (authStatus == AuthStatus.unknown) {
        return location == '/splash' ? null : '/splash';
      }

      final isAuthenticated = authStatus == AuthStatus.authenticated;
      final isGuestRoute = _guestRoutes.contains(location);
      final isProtectedRoute = _protectedRoutes.any(
        (r) => location.startsWith(r),
      );

      if (isAuthenticated && isGuestRoute) return '/home';
      if (!isAuthenticated && isProtectedRoute) return '/login';
      if (location == '/splash') {
        return isAuthenticated ? '/home' : '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChatScreen()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}
