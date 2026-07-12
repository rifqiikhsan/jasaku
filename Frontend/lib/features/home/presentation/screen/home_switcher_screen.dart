import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/secure_storage.dart';

final homeUserRoleProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return await storage.getUserRole();
});

final homeUFullNameProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return await storage.getFullName();
});

class HomeSwitcherScreen extends ConsumerStatefulWidget {
  const HomeSwitcherScreen({super.key});

  @override
  ConsumerState<HomeSwitcherScreen> createState() => _HomeSwitcherScreenState();
}

class _HomeSwitcherScreenState extends ConsumerState<HomeSwitcherScreen> {
  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(homeUserRoleProvider);

    // Tunggu sampai benar-benar selesai refresh, jangan pakai value stale
    if (roleAsync.isLoading || roleAsync.isRefreshing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return roleAsync.when(
      data: (role) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.go(role == 'PROVIDER' ? '/home-provider' : '/home-customer');
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) =>
          const Scaffold(body: Center(child: Text('Terjadi kesalahan.'))),
    );
  }
}
