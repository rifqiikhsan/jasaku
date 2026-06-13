import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Dengan masuk, kamu setuju dengan ',
        style: const TextStyle(color: Color(0xFFAAAEB6), fontSize: 12),
        children: [
          TextSpan(
            text: 'Syarat & Ketentuan',
            style: const TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // TODO: buka halaman syarat & ketentuan
              },
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
