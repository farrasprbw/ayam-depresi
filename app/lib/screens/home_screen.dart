import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import '../widgets/grain_overlay.dart';
import 'menu_detail_screen.dart';
import 'order_status_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Custom App Bar built into the body for brutalist styling control
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(
              child: GrainOverlay(opacity: 0.05),
            ),
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppThemeConstants.marginMobile,
                      vertical: 24,
                    ),
                    children: [
                      _buildFlashSale(),
                      const SizedBox(height: 32),
                      _buildCategories(),
                      const SizedBox(height: 32),
                      _buildFeaturedMenu(),
                      const SizedBox(height: 96), // Spacer for FAB
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopAppBar() {
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            offset: Offset(0, 4), // bottom shadow only for app bar
            blurRadius: 0,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppThemeConstants.marginMobile),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Location Button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_on, color: AppColors.primary),
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // Center Title
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AYAM DEPRESI',
                style: AppTypography.headlineMd.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  'LT. 12, NO. 1205',
                  style: AppTypography.labelMonoSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
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
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
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

  Widget _buildFlashSale() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Icon
          Positioned(
            right: -40,
            top: -40,
            child: Transform.rotate(
              angle: 12 * pi / 180,
              child: const Icon(
                Icons.timer,
                size: 150,
                color: Colors.white24,
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: -2 * pi / 180,
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    'FLASH SALE!',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'DISKON 50% JAM 19:00 - 21:00',
                style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
              ),
              const SizedBox(height: 16),
              BrutalButton(
                text: 'SIKAT MIRING',
                isPrimary: false,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Column(
      children: [
        // Header
        Row(
          children: [
            Text(
              'LEVEL STRES',
              style: AppTypography.headlineMd.copyWith(color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 4,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildCategoryCard(
              title: 'RINGAN',
              subtitle: '(Cabe 1-5)',
              icon: Icons.sentiment_dissatisfied,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.surfaceContainer,
            ),
            _buildCategoryCard(
              title: 'SEDANG',
              subtitle: '(Cabe 10-20)',
              icon: Icons.sentiment_very_dissatisfied,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.surfaceContainer,
            ),
            _buildCategoryCard(
              title: 'BERAT',
              subtitle: '(Cabe 50)',
              icon: Icons.mood_bad,
              iconColor: AppColors.onPrimary,
              iconBgColor: AppColors.error,
              textColor: AppColors.error,
            ),
            _buildCategoryCard(
              title: 'AKUT',
              subtitle: '(Cabe 100+)',
              icon: Symbols.skull, // Using material symbols skull
              iconColor: AppColors.onPrimary,
              iconBgColor: AppColors.error,
              textColor: AppColors.error,
              bgColor: AppColors.primary,
              subtitleColor: AppColors.surfaceContainerHighest,
              borderColor: AppColors.onPrimary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    Color textColor = AppColors.primary,
    Color bgColor = AppColors.surfaceContainerLowest,
    Color subtitleColor = AppColors.secondary,
    Color borderColor = AppColors.primary,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 3),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTypography.labelMono.copyWith(color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.bodyMd.copyWith(
                color: subtitleColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMenu() {
    return Column(
      children: [
        // Header
        Row(
          children: [
            Transform.rotate(
              angle: 1 * pi / 180,
              child: Container(
                color: AppColors.surfaceContainerLowest,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  'REKOMENDASI PSIKIATER',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.primary,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 4,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Large Item (Paket Putus Cinta)
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuDetailScreen()),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: AppThemeConstants.brutalBorder,
              boxShadow: AppThemeConstants.brutalShadow,
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  border: Border(bottom: BorderSide(color: AppColors.primary, width: 4)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: BrutalCachedImage(
                        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCw4FW_xrUcUy_RbcmbJFnxJbmteucBxnIDCrtQG5MldX_g89FjqXdufRhi1LjBIxfcQIKu72E12RYfM-pLMMJOY8lKFuK2mpBs6_oY-7OSe2GhSd1-Nu_EnrugVXjiR0AQW3d5wXujgGhuL_647gpdidVU6jl0g2EHU_kmXnquGwr73L_Za7xwFedfJOagGJO11gEur2z3czzFfuwTlV3jlbXK7hav_r6NYF6fWCo033vIh35NSx9rjxWhE1CGLPbkt80uelHrOKM',
                        fit: BoxFit.cover,
                        memCacheWidth: 600,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Transform.rotate(
                        angle: -3 * pi / 180,
                        child: Container(
                          color: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'BEST SELLER',
                            style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAKET PUTUS CINTA',
                      style: AppTypography.headlineMd.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nasi + Ayam Geprek Level Berat (Cabe 50) + Es Teh Manis untuk mendinginkan hati yang panas.',
                      style: AppTypography.bodyMd.copyWith(color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Text(
                            'Rp 35.000',
                            style: AppTypography.labelMono.copyWith(fontSize: 18),
                          ),
                        ),
                        BrutalButton(
                          text: 'TAMBAH',
                          icon: Icons.add,
                          isPrimary: true,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ), // Close GestureDetector
        
        const SizedBox(height: 24),
        
        // Small Item (Kol Goreng Ngenes)
        _buildSmallMenuItem(
          title: 'KOL GORENG\nNGENES',
          originalPrice: 'Rp 15.000',
          price: 'Rp 10.000',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCmrIiEezVpeyUssw0OJUnheDn7WEULbp8X3_TbBdy8F3gHNWIEa62gU5tD6K2Ob-NiHjTid407t4OCRKoGgx6ZlNq-lJLgfA_usjapXJ_HUKuEICZ9D375hps7OLUQh_W68s4VLjI-xxCZifrL__4paeyWK3prwbLq5959JB4beYWO_rIq1cymuQLFdfAcjqL1DRR0hegIQR09UzJqsRZuPvjl0F3GmUD8jeLYn0sl0X0IfYLBsr3ENXR-9W74NSDcwyWzqYEp5M8',
          isAvailable: true,
        ),
        
        const SizedBox(height: 24),
        
        // Small Item (Kulit Krispi Kandas - HABIS)
        _buildSmallMenuItem(
          title: 'KULIT KRISPI\nKANDAS',
          price: 'Rp 12.000',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAi75Lcm9Z9sS7tqVJsCAvQcSIJcJFp_C8bZy1gAc_-DKzeUAtf4WuCsmmL8FWdasua5iWy1-cHUSbl2Go6CUlem4u4wNDkZdHYq7q0F9rUJ6kaAFLuWtV695o6HpedMZ_fgHpdnq8C7pdQReJ2S2zgbC-MxCfN441LOJ_vNuOxfE1qq6Nfiu_vZiGXojIIaPPnclqjItcGnAE0t2Q_uJc3-zQC5HxlTIZzEE9pV4CENF7n1_K3GSOMVzp3re5LYzShypPl0tK90Rs',
          isAvailable: false,
        ),
      ],
    );
  }

  Widget _buildSmallMenuItem({
    required String title,
    String? originalPrice,
    required String price,
    required String imageUrl,
    required bool isAvailable,
  }) {
    return GestureDetector(
      onTap: isAvailable
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MenuDetailScreen()),
              )
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadow,
        ),
      height: 120,
      child: Stack(
        children: [
          Row(
            children: [
              // Image
              Container(
                width: 120,
                height: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: AppColors.primary, width: 4)),
                ),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.saturation,
                  ),
                  child: Opacity(
                    opacity: isAvailable ? 1.0 : 0.5,
                    child: BrutalCachedImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 300,
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Opacity(
                    opacity: isAvailable ? 1.0 : 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.labelMono.copyWith(fontSize: 16),
                            ),
                            if (originalPrice != null)
                              Text(
                                originalPrice,
                                style: AppTypography.bodyMd.copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              price,
                              style: AppTypography.labelMono.copyWith(fontSize: 14),
                            ),
                            if (isAvailable)
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    border: Border.all(color: AppColors.primary, width: 2),
                                    boxShadow: const [
                                      BoxShadow(color: AppColors.primary, offset: Offset(2, 2)),
                                    ],
                                  ),
                                  child: const Icon(Icons.add, color: AppColors.onPrimary, size: 20),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Out of stock overlay
          if (!isAvailable)
            Container(
              color: AppColors.surfaceDim.withValues(alpha: 0.5),
              child: Center(
                child: Transform.rotate(
                  angle: -15 * pi / 180,
                  child: Container(
                    color: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      'HABIS',
                      style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
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

  Widget _buildFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.error,
            border: AppThemeConstants.brutalBorder,
            boxShadow: AppThemeConstants.brutalShadow,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'PESAN CEPAT',
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.onPrimary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.bolt, color: AppColors.onPrimary, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: Row(
        children: [
          _buildNavItem(0, 'Home', Icons.home),
          _buildNavItem(1, 'Order', Icons.restaurant),
          _buildNavItem(2, 'History', Icons.receipt_long),
          _buildNavItem(3, 'Profile', Icons.person),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderStatusScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        child: Container(
          color: isSelected ? AppColors.primary : Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.onPrimary : AppColors.primary,
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: AppTypography.labelMonoSmall.copyWith(
                  color: isSelected ? AppColors.onPrimary : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
