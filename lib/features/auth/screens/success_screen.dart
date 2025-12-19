import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/gradient_background.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50, backgroundColor: AppColors.successGreen, child: const Icon(Icons.check, size: 60, color: Colors.white)),
                const SizedBox(height: 20),
                const Text('Successful', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Your password has been successfully updated.'),
                const SizedBox(height: 30),
                ElevatedButton(onPressed: ()=>context.go('/'), child: const Text('Continue to Login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
