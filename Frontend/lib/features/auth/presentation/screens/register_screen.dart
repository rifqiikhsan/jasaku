import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jasaku/features/auth/presentation/widgets/role_selector.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/register_provider.dart';
import '../widgets/register_footer.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

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
                  Image.asset('assets/images/logo-with-text.png', height: 40),
                  const SizedBox(height: 32),
                  const Text(
                    'Buat Akun Baru 🎉',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Daftar dan mulai temukan atau tawarkan jasa',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

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
                      const RegisterForm(),
                      const SizedBox(height: 26),
                      AppButton(
                        label: 'Daftar',
                        isLoading: state.isLoading,
                        onPressed: () =>
                            notifier.register(() => context.go('/login')),
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Sudah punya akun? Masuk',
                        variant: AppButtonVariant.outline,
                        onPressed: () => context.pop(),
                      ),
                      const SizedBox(height: 20),
                      const Center(child: RegisterFooter()),
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
