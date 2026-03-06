import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/forget_password_screen.dart';
import '../../features/auth/screens/reset_info_screen.dart';
import '../../features/auth/screens/new_password_screen.dart';
import '../../features/auth/screens/success_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/employee_home_screen.dart';
import '../../splash/splash_screen.dart';

// Helper for smooth Auth Transitions (Fade + slight Slide)
CustomTransitionPage<void> _buildAuthTransitionPage(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeIn).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0), // Slight slide from right
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _buildAuthTransitionPage(context, state, const LoginScreen()),
    ),
    GoRoute(
      path: '/forget',
      pageBuilder: (context, state) => _buildAuthTransitionPage(
          context, state, const ForgetPasswordScreen()),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) =>
          _buildAuthTransitionPage(context, state, const OtpScreen()),
    ),
    GoRoute(
      path: '/reset-info',
      pageBuilder: (context, state) =>
          _buildAuthTransitionPage(context, state, const ResetInfoScreen()),
    ),
    GoRoute(
      path: '/new-password',
      pageBuilder: (context, state) =>
          _buildAuthTransitionPage(context, state, const NewPasswordScreen()),
    ),
    GoRoute(
      path: '/success',
      pageBuilder: (context, state) =>
          _buildAuthTransitionPage(context, state, const SuccessScreen()),
    ),
    GoRoute(
      path: '/employee-home',
      builder: (_, __) => const VisitorDashboardPage(),
    ),
  ],
);
