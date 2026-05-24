import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'menu_detail_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'menu_screen.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';
import '../providers/cart_provider.dart';
import 'package:intl/intl.dart';

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
        child: _selectedIndex == 3
            ? const ProfileScreenContent()
            : _selectedIndex == 2
            ? const HistoryScreenContent()
            : _selectedIndex == 1
            ? const MenuScreenContent()
            : Column(
                children: [
                  _buildTopAppBar(),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppThemeConstants.marginMobile,
                        vertical: 24,
                      ),
                      children: [
                        _buildActiveOrderBanner(),
                        const SizedBox(height: 24),
                        _buildFlashSale(),
                        const SizedBox(height: 32),
                        _buildCategories(),
                        const SizedBox(height: 32),
                        _buildFeaturedMenu(),
                        const SizedBox(height: 96),
                      ],
                    ),
                  ),
                ],
              ),
      ),
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
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeConstants.marginMobile,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Spacer to maintain balance
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: AppColors.primary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        if (cart.itemCount == 0) return const SizedBox.shrink();
                        return Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '${cart.itemCount}',
                              style: AppTypography.labelMonoSmall.copyWith(
                                color: AppColors.onError,
                                fontSize: 8,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashSale() {
    return StreamBuilder<List<MenuItem>>(
      stream: MenuService().getMenus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        
        // Find if any item has an originalPrice set (indicating a flash sale)
        final flashSaleItems = snapshot.data!.where((item) => item.originalPrice != null && item.originalPrice! > item.price).toList();
        
        if (flashSaleItems.isEmpty) return const SizedBox.shrink();

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
                  child: const Icon(Icons.timer, size: 150, color: Colors.white24),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                    'POTONGAN HARGA SEDANG BERLANGSUNG',
                    style: AppTypography.labelMono.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BrutalButton(
                    text: 'SIKAT MIRING',
                    isPrimary: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuDetailScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }
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
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Container(height: 4, color: AppColors.primary)),
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
            Expanded(child: Container(height: 4, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 24),

        StreamBuilder<List<MenuItem>>(
          stream: MenuService().getFeaturedMenus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('TIDAK ADA REKOMENDASI HARI INI.');
            }

            final menus = snapshot.data!;
            final mainFeatured = menus.first;
            final otherFeatured = menus.length > 1 ? menus.sublist(1) : <MenuItem>[];

            return Column(
              children: [
                // Large Item
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
                            border: Border(
                              bottom: BorderSide(color: AppColors.primary, width: 4),
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              BrutalCachedImage(
                                imageUrl: mainFeatured.imageUrl,
                                fit: BoxFit.cover,
                                memCacheWidth: 600,
                                grayscale: mainFeatured.isGrayscale,
                              ),
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Transform.rotate(
                                  angle: -3 * pi / 180,
                                  child: Container(
                                    color: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'BEST SELLER',
                                      style: AppTypography.labelMono.copyWith(
                                        color: AppColors.onPrimary,
                                      ),
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
                                mainFeatured.title.toUpperCase(),
                                style: AppTypography.headlineMd.copyWith(fontSize: 24),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                mainFeatured.description,
                                style: AppTypography.bodyMd.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainer,
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 2,
                                      ),
                                    ),
                                    child: Text(
                                      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                                          .format(mainFeatured.price),
                                      style: AppTypography.labelMono.copyWith(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  BrutalButton(
                                    text: 'TAMBAH',
                                    icon: Icons.add,
                                    isPrimary: true,
                                    onPressed: () {
                                      context.read<CartProvider>().addItem(mainFeatured);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${mainFeatured.title} ditambah ke keranjang.')),
                                      );
                                    },
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

                if (otherFeatured.isNotEmpty) ...otherFeatured.map((item) {
                  return Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildSmallMenuItem(
                        menu: item,
                      ),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSmallMenuItem({
    required MenuItem menu,
  }) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return GestureDetector(
      onTap: !menu.isSoldOut
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
                    border: Border(
                      right: BorderSide(color: AppColors.primary, width: 4),
                    ),
                  ),
                  child: BrutalCachedImage(
                    imageUrl: menu.imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 300,
                    grayscale: menu.isGrayscale,
                    opacity: !menu.isSoldOut ? 1.0 : 0.5,
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.title.toUpperCase(),
                              style: AppTypography.labelMono.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatCurrency.format(menu.price),
                              style: AppTypography.labelMono.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            if (!menu.isSoldOut)
                              GestureDetector(
                                onTap: () {
                                  context.read<CartProvider>().addItem(menu);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${menu.title} ditambah ke keranjang.')),
                                  );
                                },
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.primary,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.onPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Out of stock overlay
            if (menu.isSoldOut)
              Container(
                color: AppColors.surfaceDim.withValues(alpha: 0.5),
                child: Center(
                  child: Transform.rotate(
                    angle: -15 * pi / 180,
                    child: Container(
                      color: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Text(
                        'HABIS',
                        style: AppTypography.labelMono.copyWith(
                          color: AppColors.onPrimary,
                        ),
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

  Widget _buildActiveOrderBanner() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = 2; // Go to History
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.errorContainer,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadow,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_bike,
                color: AppColors.onError,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔥 AYAM SEDANG DISIKSA',
                    style: AppTypography.headlineMd.copyWith(
                      color: AppColors.onErrorContainer,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lacak pesananmu sekarang!',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onErrorContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.onErrorContainer,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.primary, width: 4)),
      ),
      child: Row(
        children: [
          _buildNavItem(0, 'Home', Icons.home),
          _buildNavItem(1, 'Menu', Icons.restaurant_menu),
          _buildNavItem(2, 'Order', Icons.receipt_long),
          _buildNavItem(3, 'Sadness', Icons.sentiment_very_dissatisfied),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, IconData icon) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
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
