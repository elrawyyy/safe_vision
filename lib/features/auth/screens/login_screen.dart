import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_switch.dart';
import '../widgets/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int role = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: const [ThemeSwitch()]),
                const Spacer(),
                const Text('LOG IN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: RadioListTile(value: 0, groupValue: role, onChanged: (v)=>setState(()=>role=v as int), title: const Text('Administrator'))),
                  Expanded(child: RadioListTile(value: 1, groupValue: role, onChanged: (v)=>setState(()=>role=v as int), title: const Text('Employee'))),
                ]),
                TextField(decoration: const InputDecoration(hintText: 'Enter your ID')),
                const SizedBox(height: 12),
                TextField(obscureText: true, decoration: const InputDecoration(hintText: 'Password')),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: ()=>context.push('/forget'), child: const Text('Forget Password')),
                ),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: const Text('LOG IN'))),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
