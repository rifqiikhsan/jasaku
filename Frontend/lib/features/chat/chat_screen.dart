import 'package:flutter/material.dart';
import '../../app/theme.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: AppTheme.background,
      child: Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}
