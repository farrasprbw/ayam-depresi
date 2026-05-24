import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _marqueeController;

  @override
  void initState() {
    super.initState();
    _marqueeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _marqueeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile, vertical: 32),
                child: Column(
                  children: [
                    _buildLogoMascot(),
                    const SizedBox(height: 40),
                    _buildTypographyCluster(),
                    const SizedBox(height: 32),
                    _buildFormSection(),
                    const SizedBox(height: 48),
                    _buildFooterLink(),
                    const SizedBox(height: 64),
                    _buildDecorativeElements(),
                  ],
                ),
              ),
            ),
            _buildBottomMarquee(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(width: 48), // Spacer for centering
            ],
          ),
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 24,
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoMascot() {
    return Center(
      child: SizedBox(
        width: 160,
        height: 160,
        child: Stack(
          children: [
            // Top Left Hatched Pattern
            Positioned(
              top: 0,
              left: 0,
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(
                  painter: SmallHatchPatternPainter(),
                  size: const Size(48, 48),
                ),
              ),
            ),
            // Bottom Right Hatched Pattern
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.2,
                child: CustomPaint(
                  painter: SmallHatchPatternPainter(),
                  size: const Size(64, 64),
                ),
              ),
            ),
            // Center Logo Image
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -2 * pi / 180,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary, width: 4),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primary,
                          offset: Offset(8, 8), // brutal-shadow-lg
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: BrutalCachedImage(
                      imageUrl: 'https://lh3.googleusercontent.com/aida/ADBb0uie6AY74EpvJLHRydiYREAjrRghlkTvURAaeyVSthBmBGJCSXgFJ1pQAzL91-r7XkFPJGSNJn8fFtOkHr98RIGi37Wtuvo3mSNPslxwSFS25v6ZNtAjnDE25Ybm6U74bI44kxFFXBH27VSg4R95Ymdjwm3KbuqAFCzbycNLv6Fu68iEz0qAwmxNjOJLBYKP0HnayhkNQy7zyxihncn6UmMYi62xAUJNl5R6QA4plwscMr0stzPvXX-DuA',
                      fit: BoxFit.contain,
                      memCacheWidth: 256,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyCluster() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LUPA RAHASIA KELAM? Title
        RichText(
          text: TextSpan(
            style: AppTypography.headlineLgMobile.copyWith(
              fontSize: 42,
              color: AppColors.primary,
              height: 1.0,
            ),
            children: [
              const TextSpan(text: 'LUPA '),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  color: AppColors.error,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'RAHASIA',
                    style: AppTypography.headlineLgMobile.copyWith(
                      fontSize: 42,
                      color: AppColors.onPrimary,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: ' KELAM?'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Description
        Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.error, width: 4)),
          ),
          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          child: Text(
            'Masukkan No. WhatsApp kamu untuk mengingat kembali dosa-dosamu.',
            style: AppTypography.bodyLg.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[ NO. WHATSAPP ]',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.primary, width: 4),
            boxShadow: AppThemeConstants.brutalShadow,
          ),
          child: TextField(
            keyboardType: TextInputType.phone,
            style: AppTypography.labelMono.copyWith(fontSize: 18),
            decoration: InputDecoration(
              hintText: '08XXXXXXXXXX',
              hintStyle: AppTypography.labelMono.copyWith(
                fontSize: 18,
                color: Colors.grey[400],
              ),
              suffixIcon: const Icon(Icons.phone_iphone, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 32),
        // CTA Button with stronger shadow (8px)
        BrutalButton(
          text: 'KIRIM KODE PENDERITAAN',
          icon: Icons.local_fire_department,
          isPrimary: true,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFooterLink() {
    return Column(
      children: [
        CustomPaint(
          painter: LineHatchPatternPainter(),
          size: const Size(double.infinity, 4),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: RichText(
            text: TextSpan(
              style: AppTypography.labelMono.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
              children: [
                const TextSpan(text: 'Ingat Rahasianya? '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Text(
                    'Kembali Masuk.',
                    style: AppTypography.labelMono.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationThickness: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeElements() {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Text(
            'PENDERITANN ANDA ADALAH KEBAHAGIAAN KAMI',
            style: AppTypography.labelMonoSmall.copyWith(
              fontSize: 10,
              letterSpacing: 2.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 8, height: 8, color: AppColors.error),
              const SizedBox(width: 16),
              Container(width: 8, height: 8, color: AppColors.primary),
              const SizedBox(width: 16),
              Container(width: 8, height: 8, color: AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomMarquee() {
    return Container(
      height: 16,
      width: double.infinity,
      color: AppColors.primary,
      child: AnimatedBuilder(
        animation: _marqueeController,
        builder: (context, child) {
          return FractionalTranslation(
            translation: Offset(-_marqueeController.value, 0),
            child: Row(
              children: List.generate(
                10,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    'SPICY AS HELL • DEPRESSED BUT FED •',
                    style: AppTypography.labelMonoSmall.copyWith(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SmallHatchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw outer border
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);

    // Draw hatch
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 5.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineHatchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw top/bottom borders
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), borderPaint);
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), borderPaint);

    // Draw hatch
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 4.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
