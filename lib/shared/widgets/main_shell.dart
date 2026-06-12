import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'floating_bottom_nav_bar.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const _routes = ['/home', '/chat', '/profile'];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _routes.indexWhere((r) => location.startsWith(r));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: FloatingBottomNavBar(
        currentIndex: _currentIndex(context),
        onTap: (index) => context.go(_routes[index]),
      ),
    );
  }
}
