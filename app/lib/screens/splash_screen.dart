import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'login_screen.dart';

/// Splash Screen — The "Bridging Screen"
/// Features a pulsing logo, bouncing loading dots, and brutalist decorative elements.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the main container
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Bounce animation for loading dots
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // Slide up animation for transitioning out
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<double>(begin: 0, end: -1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeIn),
    );

    // 3-second delay before sliding up and navigating to LoginScreen
    Timer(const Duration(seconds: 3), () async {
      await _slideController.forward();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We use AnimatedBuilder on the slide controller to move the whole screen up
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(0, _slideAnimation.value),
          child: Opacity(
            // Fade out slightly as it slides up
            opacity: 1.0 - _slideController.value,
            child: Scaffold(
              backgroundColor: AppColors.primary, // Black background
              body: Stack(
                children: [
                  // Decorative Elements
                  _buildDecorations(),

                  // Main Splash Content
                  Center(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        // Pulse scaling from 0.95 to 1.05
                        final scale = 0.95 + (_pulseController.value * 0.1);
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppThemeConstants.marginMobile,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLogoBox(),
                            const SizedBox(height: 48),
                            _buildTypography(),
                            const SizedBox(height: 32),
                            _buildLoadingIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// The logo inside a rotated brutalist box with a glitch overlay
  Widget _buildLogoBox() {
    return Transform.rotate(
      angle: -2 * pi / 180, // -2 degrees
      child: Container(
        width: 256,
        height: 256,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.surfaceContainerLowest, width: 4),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.white10,
              offset: Offset(8, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Logo Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: RepaintBoundary(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    1.25, 0, 0, 0, 0,
                    0, 0.5, 0, 0, 0,
                    0, 0, 0.5, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.multiply,
                  ),
                ),
              ),
            ),
            // Glitch overlay simulation
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.error, width: 2),
                color: AppColors.error.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App Title and Tagline
  Widget _buildTypography() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          'AYAM DEPRESI',
          textAlign: TextAlign.center,
          style: AppTypography.headlineLgMobile.copyWith(
            color: AppColors.surfaceContainerLowest,
            shadows: [
              const Shadow(
                color: AppColors.brandRed,
                offset: Offset(4, 4),
                blurRadius: 0,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Tagline with top/bottom borders
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: AppColors.error, width: 4),
            ),
          ),
          child: Text(
            'DIHAJAR PAKE ULEKAN, ENDINGNYA KETAGIHAN.',
            textAlign: TextAlign.center,
            style: AppTypography.labelMono.copyWith(
              color: AppColors.error,
              letterSpacing: 2.0,
            ),
          ),
        ),
      ],
    );
  }

  /// 3 Bouncing Dots
  Widget _buildLoadingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(0.0, true),
        const SizedBox(width: 8),
        _buildDot(0.2, false),
        const SizedBox(width: 8),
        _buildDot(0.4, true),
      ],
    );
  }

  /// Individual bouncing dot
  Widget _buildDot(double delay, bool isRed) {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        // Calculate bounce offset with a sine wave, offset by delay
        final progress = (_bounceController.value + delay) % 1.0;
        final dy = sin(progress * pi * 2) * -8.0; // Bounce height

        // Only bounce up (negative dy)
        final actualDy = dy < 0 ? dy : 0.0;

        return Transform.translate(
          offset: Offset(0, actualDy),
          child: child,
        );
      },
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: isRed ? AppColors.error : AppColors.surfaceContainerLowest,
          border: Border.all(
            color: isRed ? AppColors.surfaceContainerLowest : AppColors.error,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isRed ? Colors.white : AppColors.brandRed,
              offset: const Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
      ),
    );
  }

  /// Decorative background elements
  Widget _buildDecorations() {
    return Stack(
      children: [
        // Top Left #PEDAS
        Positioned(
          top: 40,
          left: 40,
          child: Transform.rotate(
            angle: -12 * pi / 180,
            child: Text(
              '#PEDAS',
              style: AppTypography.display.copyWith(color: AppColors.error.withValues(alpha: 0.2)),
            ),
          ),
        ),
        // Bottom Right MATI
        Positioned(
          bottom: 40,
          right: 40,
          child: Transform.rotate(
            angle: 12 * pi / 180,
            child: Text(
              'MATI',
              style: AppTypography.display.copyWith(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.1),
              ),
            ),
          ),
        ),
        // Right slash
        Positioned(
          top: MediaQuery.of(context).size.height * 0.25,
          right: 20,
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: Container(
              width: 64,
              height: 4,
              color: AppColors.error,
            ),
          ),
        ),
        // Left circle
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.25,
          left: 20,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.surfaceContainerLowest.withValues(alpha: 0.2),
                width: 4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
