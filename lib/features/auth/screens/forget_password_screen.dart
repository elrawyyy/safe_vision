import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/gradient_background.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: ()=>context.pop(), icon: const Icon(Icons.arrow_back)),
                const Text('Forget Password', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('Please enter your Email to reset the password'),
                const SizedBox(height: 20),
                TextField(decoration: const InputDecoration(hintText: 'Enter your Email')),
                const SizedBox(height: 30),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: ()=>context.push('/otp'), child: const Text('Reset Password'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
