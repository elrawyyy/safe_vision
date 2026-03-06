import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCAE15), // Background color
      body: Stack(
        children: [
          // Bottom V shapes
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 300),
              painter: BottomVShapesPainter(),
            ),
          ),

          // Main Logo Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The Padlock Logo with Hero
                    const Hero(
                      tag: 'padlock_logo',
                      child: PadlockLogoWidget(),
                    ),

                    const SizedBox(height: 30),

                    // "SAFE VISION" Text
                    Text(
                      "SAFE VISION",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        color: const Color(0xFF001B36),
                        fontFamily:
                            'Courier', // Using Courier as fallback for the mono look
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PadlockLogoWidget extends StatelessWidget {
  const PadlockLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkNavy = Color(0xFF001B36);
    const Color lightGrey = Color(0xFFDFE2F1);

    return SizedBox(
      width: 220,
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The Shackle (Top part of padlock)
          Positioned(
            top: 0,
            left: 20,
            child: Container(
              width: 130,
              height: 120,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: darkNavy, width: 35),
                  left: BorderSide(color: darkNavy, width: 35),
                  right: BorderSide(color: darkNavy, width: 35),
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(65),
                  topRight: Radius.circular(65),
                ),
              ),
            ),
          ),

          // The Lock Body (Square with rounded corners)
          Container(
            width: 190,
            height: 140,
            decoration: BoxDecoration(
              color: darkNavy,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          // The Inner Bank Building
          Positioned(
            bottom: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Roof Triangle
                CustomPaint(
                  size: const Size(160, 45),
                  painter: TrianglePainter(color: lightGrey),
                ),

                // Columns & Keyhole Section
                Container(
                  width: 150,
                  height: 65,
                  // color: lightGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column
                      Container(width: 25, color: lightGrey),

                      // Center Arch / Doorway
                      Container(
                        width: 75,
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color(0xFF131518),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const KeyholeWidget(),
                      ),

                      // Right Column
                      Container(width: 25, color: lightGrey),
                    ],
                  ),
                ),

                // Base Steps
                Container(
                  width: 170,
                  height: 10,
                  color: lightGrey,
                ),
                const SizedBox(height: 3),
                Container(
                  width: 190,
                  height: 10,
                  color: lightGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);

    // Draw the inner triangle relief lines
    final linePaint = Paint()
      ..color = const Color(0xFFB0B5CF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawLine(
        Offset(size.width / 2, 10), Offset(20, size.height - 5), linePaint);
    canvas.drawLine(Offset(size.width / 2, 10),
        Offset(size.width - 20, size.height - 5), linePaint);
    canvas.drawLine(Offset(20, size.height - 5),
        Offset(size.width - 20, size.height - 5), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class KeyholeWidget extends StatelessWidget {
  const KeyholeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color keyholeColor = Color(0xFFFCAE15);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: keyholeColor,
            shape: BoxShape.circle,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -5),
          child: CustomPaint(
            size: const Size(26, 20),
            painter: KeyholeBottomPainter(color: keyholeColor),
          ),
        ),
      ],
    );
  }
}

class KeyholeBottomPainter extends CustomPainter {
  final Color color;
  KeyholeBottomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2 - 5, 0)
      ..lineTo(size.width / 2 + 5, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BottomVShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkNavy = const Color(0xFF001B36);
    final mediumBlue = const Color(0xFF003060);

    final paintBack = Paint()
      ..color = mediumBlue
      ..style = PaintingStyle.fill;

    final paintFront = Paint()
      ..color = darkNavy
      ..style = PaintingStyle.fill;

    // Background V (Medium Blue)
    final pathBack = Path()
      ..moveTo(0, size.height * 0.4)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathBack, paintBack);

    // Foreground V (Dark Navy)
    final pathFront = Path()
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width / 2,
          size.height + 20) // Extend a bit lower to ensure point is crisp
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(pathFront, paintFront);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
