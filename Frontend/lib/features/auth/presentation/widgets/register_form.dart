import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';
import '../providers/register_provider.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(registerProvider.notifier);
    final errorMessage = ref.watch(registerProvider).errorMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Nama Lengkap'),
        _field(
          controller: _nameController,
          hint: 'Masukkan nama lengkap',
          icon: Icons.person_outline_rounded,
          onChanged: notifier.setName,
        ),
        const SizedBox(height: 12),
        _label('Email'),
        _field(
          controller: _emailController,
          hint: 'Masukkan email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: notifier.setEmail,
        ),
        const SizedBox(height: 12),
        _label('Nomor HP'),
        _field(
          controller: _phoneController,
          hint: 'Contoh: 08xxxxxxxxxx',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          onChanged: notifier.setPhone,
        ),
        const SizedBox(height: 12),
        _label('Password'),
        _field(
          controller: _passwordController,
          hint: 'Buat password',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          onChanged: notifier.setPassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 12),
        _label('Konfirmasi Password'),
        _field(
          controller: _confirmPasswordController,
          hint: 'Ulangi password',
          icon: Icons.lock_outline_rounded,
          obscureText: _obscureConfirm,
          onChanged: notifier.setConfirmPassword,
          suffix: IconButton(
            icon: Icon(
              _obscureConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
        ),
        if (errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ],
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
