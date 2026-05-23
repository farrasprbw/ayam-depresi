import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(),
            Expanded(
              child: Stack(
                children: [
                  // Decorative Hatch Pattern Background
                  Positioned.fill(
                    child: CustomPaint(
                      painter: HatchPatternPainter(),
                    ),
                  ),
                  
                  // Decorative elements for desktop/tablet (hidden on mobile mostly, but let's add them)
                  Positioned(
                    top: -40,
                    right: -80,
                    child: Transform.rotate(
                      angle: 45 * pi / 180,
                      child: Opacity(
                        opacity: 0.2,
                        child: Container(
                          width: 256,
                          height: 256,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary, width: 8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: -40,
                    child: Transform.rotate(
                      angle: -12 * pi / 180,
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          width: 192,
                          height: 192,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            border: Border.all(color: AppColors.primary, width: 4),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main Scrollable Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppThemeConstants.marginMobile,
                      vertical: 48,
                    ),
                    child: Column(
                      children: [
                        // Floating Badge
                        Transform.rotate(
                          angle: -3 * pi / 180,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 32),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              border: Border.all(color: AppColors.primary, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.primary,
                                  offset: Offset(4, 4),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              'WARNING: HIGH SODIUM & EXISTENTIAL CRISIS',
                              style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        // Registration Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 500),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            border: AppThemeConstants.brutalBorder,
                            boxShadow: AppThemeConstants.brutalShadow,
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              // Mascot Logo
                              Transform.rotate(
                                angle: 2 * pi / 180,
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  margin: const EdgeInsets.only(bottom: 32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: AppThemeConstants.brutalBorder,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.primary,
                                        offset: Offset(4, 4),
                                      )
                                    ],
                                  ),
                                  child: Image.network(
                                    'https://lh3.googleusercontent.com/aida/ADBb0uie6AY74EpvJLHRydiYREAjrRghlkTvURAaeyVSthBmBGJCSXgFJ1pQAzL91-r7XkFPJGSNJn8fFtOkHr98RIGi37Wtuvo3mSNPslxwSFS25v6ZNtAjnDE25Ybm6U74bI44kxFFXBH27VSg4R95Ymdjwm3KbuqAFCzbycNLv6Fu68iEz0qAwmxNjOJLBYKP0HnayhkNQy7zyxihncn6UmMYi62xAUJNl5R6QA4plwscMr0stzPvXX-DuA',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              
                              // Header
                              Text(
                                'DAFTAR BARU\n(TAMBAH BEBAN)',
                                style: AppTypography.headlineMd.copyWith(fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Silakan isi dosa-dosamu di bawah ini.',
                                style: AppTypography.bodyMd.copyWith(
                                  color: AppColors.secondary,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),

                              // Fields
                              _buildUnderlineTextField(
                                label: 'NAMA LENGKAP (SIAPA KAMU?)',
                                hint: 'Nama yang akan kami panggil saat pesanan tiba...',
                              ),
                              const SizedBox(height: 24),
                              _buildUnderlineTextField(
                                label: 'NO. WHATSAPP (BIAR BISA DIHUBUNGI)',
                                hint: '0812...',
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: 24),
                              _buildUnderlineTextField(
                                label: 'RAHASIA KELAM (KATA SANDI)',
                                isPassword: true,
                                obscureText: !_isPasswordVisible,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              _buildUnderlineTextField(
                                label: 'KONFIRMASI RAHASIA',
                                isPassword: true,
                                obscureText: !_isConfirmPasswordVisible,
                                onToggleVisibility: () {
                                  setState(() {
                                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              const SizedBox(height: 32),

                              // Terms Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _termsAccepted,
                                      onChanged: (val) {
                                        setState(() {
                                          _termsAccepted = val ?? false;
                                        });
                                      },
                                      activeColor: AppColors.error,
                                      checkColor: AppColors.onPrimary,
                                      side: const BorderSide(color: AppColors.primary, width: 3),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'SAYA SETUJU UNTUK MENANGGUNG SEGALA RISIKO KEPEDASAN DAN PENYESALAN HIDUP YANG MUNGKIN TIMBUL.',
                                      style: AppTypography.labelMonoSmall.copyWith(
                                        fontSize: 12,
                                        height: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),

                              // Submit Button
                              BrutalButton(
                                text: 'MENDAFTAR & MENDERITA',
                                isPrimary: true,
                                onPressed: () {
                                  Navigator.pop(context); // Go back to login
                                },
                              ),
                              
                              const SizedBox(height: 40),
                              
                              // Login Link
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Sudah punya beban? Login saja.',
                                  style: AppTypography.labelMono.copyWith(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Footer
                        _buildFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.primary, size: 32),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              Text(
                'AYAM DEPRESI',
                style: AppTypography.headlineMd.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const Icon(Icons.shopping_cart, color: AppColors.primary, size: 32),
        ],
      ),
    );
  }

  Widget _buildUnderlineTextField({
    required String label,
    String? hint,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMono,
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyMd,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.secondary.withValues(alpha: 0.5)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.primary,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 4),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 4),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(top: BorderSide(color: AppColors.error, width: 8)),
      ),
      padding: const EdgeInsets.all(AppThemeConstants.marginMobile),
      child: Column(
        children: [
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(color: AppColors.onPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'MADE WITH EXISTENTIAL DREAD. NO CHICKENS WERE HAPPY IN THE MAKING OF THIS UI.',
            style: AppTypography.labelMonoSmall.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFooterIcon(Icons.share),
              const SizedBox(width: 16),
              _buildFooterIcon(Icons.public),
              const SizedBox(width: 16),
              _buildFooterIcon(Icons.mail),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            "ALL RIGHTS RESERVED. OR NOT. IT DOESN'T REALLY MATTER IN THE GRAND SCHEME OF THE UNIVERSE.",
            style: AppTypography.labelMonoSmall.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.5),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.onPrimary, width: 2),
      ),
      padding: const EdgeInsets.all(8),
      child: Icon(icon, color: AppColors.onPrimary),
    );
  }
}

class HatchPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 8.0;
    
    // Draw diagonal lines
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
