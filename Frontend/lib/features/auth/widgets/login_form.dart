import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/login_provider.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Email',
          hint: 'Masukan email',
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.setEmail,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Kata Sandi',
          hint: 'Masukan kata sandi',
          obscureText: !state.isPasswordVisible,
          onChanged: notifier.setPassword,
          suffixIcon: IconButton(
            icon: Icon(
              state.isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppTheme.textHint,
              size: 20,
            ),
            onPressed: notifier.togglePasswordVisibility,
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.blue.withValues(alpha: 0.2),
              highlightColor: Colors.blue.withValues(alpha: 0.1),
              onTap: () {
                // TODO: navigasi ke forgot password
              },
              child: const Text(
                'Lupa Kata Sandi',
                style: TextStyle(
                  color: AppTheme.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            state.errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
