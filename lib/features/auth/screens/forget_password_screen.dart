import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_auth_layout.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Forget Password',
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
            'Please enter your Email to reset the\npassword',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ahmedmohsen123@example.com',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF0B1221).withOpacity(0.85),
              prefixIcon: const Icon(Icons.person_outline,
                  size: 24, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF00E5FF), width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: AnimatedPrimaryButton(
              text: 'Reset password',
              backgroundColor:
                  const Color(0xFF00E5FF).withOpacity(0.8), // Neon cyan button
              onPressed: () => context.push('/otp'),
            ),
          ),
        ],
      ),
    );
  }
}
