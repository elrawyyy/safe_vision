import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SharedAuthLayout extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final Widget? topSection;

  const SharedAuthLayout({
    super.key,
    required this.child,
    this.showBackButton = true,
    this.topSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF050B14), // Deep premium dark background
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.2,
            colors: [
              Color(0xFF112240), // Subtle neon glow in corner
              Color(0xFF050B14),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              if (topSection != null) topSection!,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF131B2A)
                              .withOpacity(0.7), // Glassmorphic panel
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40)),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: -5,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              // Neon glow
                              color: const Color(0xFF00E5FF).withOpacity(0.05),
                              blurRadius: 40,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: Transform.translate(
                                      offset: Offset(0, 50 * (1 - value)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: child,
                              ),
                            ),
                            if (showBackButton)
                              Positioned(
                                top: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    } else {
                                      context.go('/');
                                    }
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF0B1221)
                                            .withOpacity(0.85),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color(0xFF00E5FF)
                                                .withOpacity(0.3)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF00E5FF)
                                                .withOpacity(0.2),
                                            blurRadius: 10,
                                          )
                                        ]),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Color(0xFF00E5FF),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedPrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color backgroundColor;
  final Color? disabledBackgroundColor;
  final bool isLoading;

  const AnimatedPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.backgroundColor,
    this.disabledBackgroundColor,
    this.isLoading = false,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null && !widget.isLoading
          ? (_) {
              HapticFeedback.lightImpact();
              _controller.forward();
            }
          : null,
      onTapUp: widget.onPressed != null && !widget.isLoading
          ? (_) {
              HapticFeedback.lightImpact();
              _controller.reverse();
              widget.onPressed!();
            }
          : null,
      onTapCancel: widget.onPressed != null && !widget.isLoading
          ? () => _controller.reverse()
          : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.isLoading ? () {} : widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              disabledBackgroundColor: widget.disabledBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
