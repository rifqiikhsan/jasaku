import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
        children: [
          const TextSpan(text: 'Dengan mendaftar, kamu menyetujui '),
          TextSpan(
            text: 'Syarat & Ketentuan',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: buka halaman syarat & ketentuan
              },
          ),
          const TextSpan(text: ' dan '),
          TextSpan(
            text: 'Kebijakan Privasi',
            style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: buka halaman kebijakan privasi
              },
          ),
          const TextSpan(text: ' JasaKu.'),
        ],
      ),
    );
  }
}
