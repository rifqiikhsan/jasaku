import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme.dart';

class HomeProviderScreen extends ConsumerWidget {
  const HomeProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Home Provider',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
      ),
      body: const Center(
        child: Text('Selamat datang di dashboard penyedia jasa'),
      ),
    );
  }
}
