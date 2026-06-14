import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../shared/widgets/app_button.dart';
import 'providers/login_provider.dart';
import 'widgets/login_footer.dart';
import 'widgets/login_form.dart';
import 'widgets/role_selector.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  const SizedBox(height: 32),
                  Image.asset('assets/images/logo-with-text.png', height: 40),
                  const SizedBox(height: 32),
                  // Greeting
                  const Text(
                    'Selamat\nDatang Kembali 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Temukan jasa terdekat untuk anda',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Bottom Sheet ─────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoleSelector(
                        selectedRole: state.selectedRole,
                        onChanged: notifier.setRole,
                      ),
                      const SizedBox(height: 24),
                      const LoginForm(),
                      const SizedBox(height: 26),
                      AppButton(
                        label: 'Masuk',
                        isLoading: state.isLoading,
                        onPressed: () =>
                            notifier.login(() => context.go('/home')),
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Daftar',
                        variant: AppButtonVariant.outline,
                        onPressed: () {
                          // TODO: navigasi ke register
                        },
                      ),
                      const SizedBox(height: 20),
                      const Center(child: LoginFooter()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
