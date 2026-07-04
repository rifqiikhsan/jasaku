import 'package:go_router/go_router.dart';
import 'package:jasaku/features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/presentation/screen/home_screen.dart';
import '../features/search/presentation/screen/search_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/profile/profile_screen.dart';
import '../shared/widgets/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
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
