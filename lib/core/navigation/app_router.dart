import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/forget_password_screen.dart';
import '../../features/auth/screens/reset_info_screen.dart';
import '../../features/auth/screens/new_password_screen.dart';
import '../../features/auth/screens/success_screen.dart';
import '../../features/auth/screens/otp_screen.dart';


final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/forget', builder: (_, __) => const ForgetPasswordScreen()),
    GoRoute(path: '/reset-info', builder: (_, __) => const ResetInfoScreen()),
    GoRoute(path: '/new-password', builder: (_, __) => const NewPasswordScreen()),
    GoRoute(path: '/success', builder: (_, __) => const SuccessScreen()),
    GoRoute(path: '/otp', builder: (_, __) => const OtpScreen(),
    ),

  ],
);
