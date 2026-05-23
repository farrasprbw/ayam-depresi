import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_text_field.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

/// Login screen — "MASUK KE NERAKA"
/// Brutalist design with tilted card, hard-drop shadows, ironic copy
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _cardSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<double> _flairSlideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardSlideAnimation = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _cardFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _flairSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.marginMobile,
                  vertical: 24,
                ),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Transform.translate(
                          offset: Offset(0, _cardSlideAnimation.value),
                          child: Opacity(
                            opacity: _cardFadeAnimation.value,
                            child: _buildLoginCard(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Transform.translate(
                          offset: Offset(0, _flairSlideAnimation.value),
                          child: Opacity(
                            opacity: _cardFadeAnimation.value,
                            child: _buildExtraFlair(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  /// Top AppBar — logo + brand name, thick bottom border
  Widget _buildAppBar() {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: AppThemeConstants.borderThick,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo (grayscale filter like the HTML)
          SizedBox(
            width: 32,
            height: 32,
            child: RepaintBoundary(
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.33, 0.33, 0.33, 0, 0,
                  0.33, 0.33, 0.33, 0, 0,
                  0.33, 0.33, 0.33, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Brand name
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Main login card — tilted -1°, thick border, large shadow
  Widget _buildLoginCard() {
    return Transform.rotate(
      angle: -1 * pi / 180,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadowLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'MASUK KE\nNERAKA',
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle with bottom border
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'SILAKAN MENDERITA BERSAMA KAMI LAGI.',
                style: AppTypography.labelMono.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Identity field
            BrutalTextField(
              label: 'IDENTITASMU',
              placeholder: 'No. WhatsApp / Email...',
              controller: _identityController,
            ),
            const SizedBox(height: 24),

            // Password field
            BrutalTextField(
              label: 'RAHASIA KELAM',
              placeholder: 'Kata sandi rahasiamu...',
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 8),

            // Forgot password link
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                  );
                },
                child: Text(
                  'LUPA SANDI? (SAMA, SAYA JUGA LUPA BAHAGIA)',
                  style: AppTypography.labelMonoSmall.copyWith(
                    color: AppColors.error,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: AppColors.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login button
            BrutalButton(
              text: 'LOGIN & PESAN',
              icon: Icons.local_fire_department,
              isPrimary: true,
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 16),

            // Register button
            BrutalButton(
              text: 'DAFTAR BARU (TAMBAH BEBAN)',
              isPrimary: false,
              onPressed: _handleRegister,
            ),
          ],
        ),
      ),
    );
  }

  /// Extra flair — status badge + broken heart icon
  Widget _buildExtraFlair() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Expanded(
            child: Transform.rotate(
              angle: 2 * pi / 180,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: AppThemeConstants.brutalBorder,
                  boxShadow: AppThemeConstants.brutalShadow,
                ),
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.labelMonoSmall.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    children: [
                      const TextSpan(text: 'STATUS HARI INI:\n'),
                      TextSpan(
                        text: 'SANGAT KECEWA',
                        style: AppTypography.labelMonoSmall.copyWith(
                          color: AppColors.brandRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Broken heart icon
          Transform.rotate(
            angle: -12 * pi / 180,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: AppThemeConstants.brutalBorder,
                boxShadow: AppThemeConstants.brutalShadow,
              ),
              child: const Center(
                child: Icon(
                  Icons.heart_broken,
                  color: AppColors.brandRed,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer — icons + version text
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: AppColors.primary,
            width: AppThemeConstants.borderThick,
          ),
        ),
      ),
      child: Column(
        children: [
          // Icons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, color: AppColors.onSurface.withValues(alpha: 0.5), size: 24),
              const SizedBox(width: 16),
              Icon(Icons.close, color: AppColors.onSurface.withValues(alpha: 0.5), size: 24),
              const SizedBox(width: 16),
              Icon(Icons.close, color: AppColors.onSurface.withValues(alpha: 0.5), size: 24),
            ],
          ),
          const SizedBox(height: 16),
          // Version text
          Text(
            'V.1.0-SAD | MADE WITH EXISTENTIAL DREAD.\nNO CHICKENS WERE HAPPY IN THE MAKING OF THIS UI.',
            textAlign: TextAlign.center,
            style: AppTypography.labelMonoSmall.copyWith(
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    // Show a quick snackbar then navigate
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          'SELAMAT DATANG DI NERAKA 🔥',
          style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
        ),
        duration: const Duration(milliseconds: 1000),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  void _handleRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }
}
