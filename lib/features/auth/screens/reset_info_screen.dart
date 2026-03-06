import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_auth_layout.dart';

class ResetInfoScreen extends StatelessWidget {
  const ResetInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Password reset',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF00E5FF), Color(0xFFD500F9)],
                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
              shadows: [
                Shadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your password has been successfully\nreset.\nclick confirm to set a new password',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: AnimatedPrimaryButton(
              text: 'Confirm',
              backgroundColor:
                  const Color(0xFF00E5FF).withOpacity(0.8), // Neon cyan button
              onPressed: () => context.push('/new-password'),
            ),
          ),
        ],
      ),
    );
  }
}
