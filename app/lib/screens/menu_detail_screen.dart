import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import '../widgets/brutal_text_field.dart';

class MenuDetailScreen extends StatefulWidget {
  const MenuDetailScreen({super.key});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  double _spiceLevel = 5;
  final Map<String, bool> _toppings = {
    'Telur Dadar Judes': false,
    'Tahu Goreng Kering': false,
  };
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      _buildHeroImage(),
                      Padding(
                        padding: const EdgeInsets.all(AppThemeConstants.marginMobile),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndDescription(),
                            const SizedBox(height: 32),
                            _buildSpiceLevelSlider(),
                            const SizedBox(height: 32),
                            _buildToppings(),
                            const SizedBox(height: 32),
                            BrutalTextField(
                              label: 'CATATAN UNTUK PENJUAL',
                              placeholder: 'Contoh: Sambalnya dipisah aja mas...',
                              maxLines: 3,
                              controller: _notesController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildBottomBar(),
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
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: AppThemeConstants.borderThick,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile),
      child: Row(
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
          // Center Title
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
          // Cart Button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: AppColors.primary),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '2',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadow,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BrutalCachedImage(
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCw4FW_xrUcUy_RbcmbJFnxJbmteucBxnIDCrtQG5MldX_g89FjqXdufRhi1LjBIxfcQIKu72E12RYfM-pLMMJOY8lKFuK2mpBs6_oY-7OSe2GhSd1-Nu_EnrugVXjiR0AQW3d5wXujgGhuL_647gpdidVU6jl0g2EHU_kmXnquGwr73L_Za7xwFedfJOagGJO11gEur2z3czzFfuwTlV3jlbXK7hav_r6NYF6fWCo033vIh35NSx9rjxWhE1CGLPbkt80uelHrOKM',
              fit: BoxFit.cover,
              memCacheWidth: 600,
              grayscale: true,
            ),
            // Dark vignette/gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                  radius: 1.0,
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'BEST SELLER',
                  style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AYAM DEPRESI\nAKUT',
          style: AppTypography.headlineLgMobile.copyWith(
            height: 1.1,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rp 28.000',
          style: AppTypography.bodyLg.copyWith(
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Ayam geprek krispi yang dihancurkan tanpa ampun, dilumuri sambal bawang ulekan ekstra pedas yang bikin merenung. Disajikan dengan nasi putih panas.',
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSpiceLevelSlider() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      child: Stack(
        children: [
          // Red Triangle in top right corner
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(64, 64),
              painter: TrianglePainter(color: AppColors.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'LEVEL PEDAS',
                      style: AppTypography.labelMono.copyWith(fontSize: 16),
                    ),
                    Text(
                      'Lv. ${_spiceLevel.toInt()}',
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Custom Brutalist Slider implementation
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primary,
                    thumbColor: Colors.blue, // As shown in reference
                    overlayColor: Colors.blue.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    value: _spiceLevel,
                    min: 1,
                    max: 15,
                    divisions: 14,
                    onChanged: (value) {
                      setState(() {
                        _spiceLevel = value;
                      });
                    },
                  ),
                ),
                // Labels below slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lv. 1 (Cemen)',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Lv. 15 (Mati Rasa)',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToppings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOPPING TAMBAHAN',
              style: AppTypography.labelMono.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Container(height: 4, width: 200, color: AppColors.primary),
          ],
        ),
        const SizedBox(height: 16),
        _buildToppingItem(
          title: 'Telur Dadar Judes',
          price: '+ Rp 5.000',
          isChecked: _toppings['Telur Dadar Judes']!,
          onChanged: (val) {
            setState(() {
              _toppings['Telur Dadar Judes'] = val ?? false;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildToppingItem(
          title: 'Tahu Goreng Kering',
          price: '+ Rp 3.000',
          isChecked: _toppings['Tahu Goreng Kering']!,
          onChanged: (val) {
            setState(() {
              _toppings['Tahu Goreng Kering'] = val ?? false;
            });
          },
        ),
        const SizedBox(height: 12),
        _buildToppingItem(
          title: 'Keju Mozarella Leleh',
          price: '+ Rp 6.000',
          isChecked: false,
          isSoldOut: true,
          onChanged: null,
        ),
      ],
    );
  }

  Widget _buildToppingItem({
    required String title,
    required String price,
    required bool isChecked,
    required ValueChanged<bool?>? onChanged,
    bool isSoldOut = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.onPrimary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      color: isSoldOut ? AppColors.secondary : AppColors.primary,
                      decoration: isSoldOut ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Text(
                  isSoldOut ? '' : price,
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (isSoldOut)
            Positioned(
              right: 16,
              top: 16,
              child: Transform.rotate(
                angle: -10 * pi / 180,
                child: Container(
                  color: AppColors.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'SOLD OUT',
                    style: AppTypography.labelMonoSmall.copyWith(
                      color: AppColors.surfaceContainerLowest,
                    ),
                  ),
                ),
              ),
            ),
          if (isSoldOut)
            Positioned.fill(
              child: Container(
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.primary,
              width: AppThemeConstants.borderThick,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL',
                  style: AppTypography.labelMonoSmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Rp 28.000',
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            BrutalButton(
              text: 'TAMBAH',
              icon: Icons.shopping_cart,
              isPrimary: true,
              onPressed: () => Navigator.pop(context), // Mock returning to home
            ),
          ],
        ),
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
      ..moveTo(size.width, 0) // top right
      ..lineTo(size.width, size.height) // bottom right
      ..lineTo(0, 0) // top left
      ..close();
      
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
