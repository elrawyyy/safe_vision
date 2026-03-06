import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_auth_layout.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool passwordsMatch = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _checkPasswords() {
    setState(() {
      passwordsMatch = passwordController.text.isNotEmpty &&
          passwordController.text == confirmController.text;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SharedAuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'Set a new password',
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
            'Create a new password. Ensure it differs\nfrom previous ones for security',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),

          const SizedBox(height: 40),

          // Password Field
          Text(
            'Password',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: passwordController,
            obscureText: !_isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF0B1221).withOpacity(0.85),
              prefixIcon: const Icon(Icons.vpn_key_outlined,
                  size: 22, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
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
            onChanged: (_) => _checkPasswords(),
          ),

          const SizedBox(height: 20),

          // Confirm Password Field
          Text(
            'Confirm Password',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: confirmController,
            obscureText: !_isConfirmPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Re-enter password',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF0B1221).withOpacity(0.85),
              prefixIcon: const Icon(Icons.vpn_key_outlined,
                  size: 22, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              errorText: confirmController.text.isEmpty
                  ? null
                  : passwordsMatch
                      ? null
                      : 'Passwords do not match',
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
            onChanged: (_) => _checkPasswords(),
          ),

          const SizedBox(height: 50),

          Center(
            child: AnimatedPrimaryButton(
              text: 'Confirm',
              backgroundColor:
                  const Color(0xFF00E5FF).withOpacity(0.8), // Neon cyan button
              disabledBackgroundColor:
                  Colors.white.withOpacity(0.1), // Dimmed dark gradient fill
              onPressed: passwordsMatch ? () => context.push('/success') : null,
            ),
          ),
        ],
      ),
    );
  }
}
