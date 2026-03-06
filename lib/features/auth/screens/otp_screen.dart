import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/shared_auth_layout.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final int otpLength = 5;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  bool isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  void _onOtpChanged() {
    setState(() {
      isOtpComplete =
          controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
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
            'Enter OTP',
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
            'Please enter the OTP sent to your\nregistered mail',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[300],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center items
            children: List.generate(
              otpLength,
              (index) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6), // Closer spacing
                child: SizedBox(
                  width: 50,
                  height: 60,
                  child: TextField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFF0B1221).withOpacity(0.85),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1), width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF00E5FF), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      _onOtpChanged();

                      if (value.isNotEmpty && index < otpLength - 1) {
                        focusNodes[index + 1].requestFocus();
                      }

                      if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: AnimatedPrimaryButton(
              text: 'Reset password',
              backgroundColor:
                  const Color(0xFF00E5FF).withOpacity(0.8), // Neon cyan button
              onPressed: () => context.push(
                  '/reset-info'), // Active regardless for demo purposes, or tie to isOtpComplete
            ),
          ),
        ],
      ),
    );
  }
}
