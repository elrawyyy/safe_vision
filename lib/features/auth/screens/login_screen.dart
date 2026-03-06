import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user_role.dart';
import '../../../splash/splash_screen.dart'; // import PadlockLogoWidget from here.
import '../widgets/shared_auth_layout.dart'; // import AnimatedPrimaryButton
import '../../../core/utils/shake_animation_widget.dart';
import '../../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole role = UserRole.admin;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ShakeController _idShakeController = ShakeController();
  final ShakeController _passwordShakeController = ShakeController();

  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _idFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    bool hasError = false;

    if (_idController.text.trim().isEmpty) {
      _idShakeController.shake();
      HapticFeedback.heavyImpact();
      hasError = true;
    }
    if (_passwordController.text.trim().isEmpty) {
      _passwordShakeController.shake();
      HapticFeedback.heavyImpact();
      hasError = true;
    }

    if (hasError) return;

    setState(() {
      _isLoading = true;
    });

    final authService = AuthService();
    final result = await authService.login(
      _idController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        context.go('/employee-home');
      } else {
        _passwordShakeController.shake();
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Login failed'),
            backgroundColor: Colors.redAccent.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.6),
                radius: 1.2,
                colors: [
                  Color(0xFF112240), // Subtle neon glow in corner
                  Color(0xFF050B14),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Logo Area
                const Center(
                  child: Hero(
                    tag: 'padlock_logo',
                    child: PadlockLogoWidget(),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "SAFE VISION",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      fontFamily: 'Courier',
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFFD500F9)],
                        ).createShader(
                            const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      shadows: [
                        Shadow(
                          color: const Color(0xFF00E5FF).withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Container for Form
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFF131B2A)
                          .withOpacity(0.7), // Glassmorphic panel
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border(
                        top: BorderSide(
                            color: Colors.white.withOpacity(0.08), width: 1.5),
                        left: BorderSide(
                            color: Colors.white.withOpacity(0.08), width: 1.5),
                        right: BorderSide(
                            color: Colors.white.withOpacity(0.08), width: 1.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: -5,
                          offset: const Offset(0, -10),
                        ),
                        BoxShadow(
                          // Neon glow
                          color: const Color(0xFF00E5FF).withOpacity(0.05),
                          blurRadius: 40,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome !',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFF00E5FF),
                                    Color(0xFF2979FF)
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 150.0, 50.0)),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // ID Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'ID',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ShakeWidget(
                            controller: _idShakeController,
                            child: TextField(
                              controller: _idController,
                              focusNode: _idFocusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your ID',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor:
                                    const Color(0xFF0B1221).withOpacity(0.85),
                                prefixIcon: Icon(Icons.person_outline,
                                    size: 24,
                                    color: _idFocusNode.hasFocus
                                        ? const Color(0xFF00E5FF)
                                        : Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF), width: 2.0),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password Field
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ShakeWidget(
                            controller: _passwordShakeController,
                            child: TextField(
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter your password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor:
                                    const Color(0xFF0B1221).withOpacity(0.85),
                                prefixIcon: Icon(Icons.vpn_key_outlined,
                                    size: 22,
                                    color: _passwordFocusNode.hasFocus
                                        ? const Color(0xFF00E5FF)
                                        : Colors.grey),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off_outlined,
                                    color: _passwordFocusNode.hasFocus
                                        ? const Color(0xFF00E5FF)
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF00E5FF), width: 2.0),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Forget Password Text
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.push('/forget'),
                              child: const Text(
                                'Forget Password',
                                style: TextStyle(
                                  color: Color(0xFF00E5FF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Login Button
                          Center(
                            child: AnimatedPrimaryButton(
                              text: 'Login',
                              backgroundColor: const Color(0xFF00E5FF)
                                  .withOpacity(0.8), // Neon cyan button
                              isLoading: _isLoading,
                              onPressed: _handleLogin,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
