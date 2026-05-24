import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'cart_screen.dart';
import 'menu_detail_screen.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';
import '../providers/cart_provider.dart';
import 'package:intl/intl.dart';

class MenuScreenContent extends StatefulWidget {
  const MenuScreenContent({super.key});

  @override
  State<MenuScreenContent> createState() => _MenuScreenContentState();
}

class _MenuScreenContentState extends State<MenuScreenContent> {
  int _selectedCategoryIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: MenuService().getCategories(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final categories = snapshot.data!;
        
        // Ensure index is valid after fetching
        if (_selectedCategoryIndex >= categories.length) {
          _selectedCategoryIndex = 0;
        }

        return Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.marginMobile,
                  vertical: 24,
                ),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 32),
                  _buildCategoryTabs(categories),
                  const SizedBox(height: 32),
                  _buildMenuSection(categories),
                  const SizedBox(height: 64),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.primary, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            offset: Offset(0, 4),
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
              if (Navigator.canPop(context))
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 48), // Spacer to maintain balance
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
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
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
            'MENU DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.primary, width: 4),
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: AppTypography.bodyLg,
              decoration: InputDecoration(
                hintText: 'Cari Penderitaanmu...',
                hintStyle: AppTypography.bodyLg.copyWith(
                  color: AppColors.secondary,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.search, color: AppColors.primary, size: 28),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: isSelected ? AppThemeConstants.brutalShadow : null,
                ),
                child: Text(
                  categories[index],
                  style: AppTypography.labelMono.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMenuSection(List<String> categories) {
    final currentCategory = categories[_selectedCategoryIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              currentCategory,
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Container(height: 4, color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 24),

        StreamBuilder<List<MenuItem>>(
          stream: MenuService().getMenusByCategory(currentCategory),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final menus = snapshot.data ?? [];
            if (menus.isEmpty) {
              return Text(
                'TIDAK ADA PENDERITAAN DI KATEGORI INI (KOSONG).',
                style: AppTypography.labelMono,
              );
            }

            return Column(
              children: menus.map((menu) {
                if (menu.isSoldOut) {
                  return Column(
                    children: [
                      _buildSoldOutItem(menu),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildMenuItem(menu: menu),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem({required MenuItem menu}) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuDetailScreen(menu: menu)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.primary, width: 4),
          boxShadow: AppThemeConstants.brutalShadowLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 4),
                    ),
                  ),
                  child: menu.isGrayscale
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          ),
                          child: BrutalCachedImage(
                            imageUrl: menu.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        )
                      : BrutalCachedImage(
                          imageUrl: menu.imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                if (menu.tag != null && menu.tag!.isNotEmpty)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Transform.rotate(
                      angle: 3 * pi / 180,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          menu.tag!,
                          style: AppTypography.labelMono.copyWith(
                            color: AppColors.onError,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menu.title.toUpperCase(),
                          style: AppTypography.headlineMd.copyWith(
                            fontSize: 24,
                            height: 1.1,
                          ),
                        ),
                      ),
                      if (menu.spicyLevel > 0)
                        Row(
                          children: List.generate(
                            menu.spicyLevel,
                            (index) => const Icon(
                              Icons.local_fire_department,
                              color: AppColors.error,
                              size: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    menu.description,
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency.format(menu.price),
                        style: AppTypography.headlineMd.copyWith(fontSize: 24),
                      ),
                      BrutalButton(
                        text: 'TAMBAH +',
                        isPrimary: true,
                        onPressed: () {
                          context.read<CartProvider>().addItem(menu);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${menu.title} ditambah ke keranjang.',
                              ),
                            ),
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
    );
  }

  Widget _buildSoldOutItem(MenuItem menu) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.7),
        border: Border.all(color: AppColors.primary, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryFixedDim,
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Transform.rotate(
                    angle: -12 * pi / 180,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        border: Border.all(color: AppColors.primary, width: 8),
                      ),
                      child: Text(
                        'SOLD OUT',
                        style: AppTypography.display.copyWith(
                          color: AppColors.onError,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menu.title.toUpperCase(),
                  style: AppTypography.headlineMd.copyWith(
                    fontSize: 24,
                    height: 1.1,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu.description,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.secondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(height: 4, width: double.infinity, color: AppColors.primary),
        const SizedBox(height: 40),
        Text(
          '"MAKAN PEDAS BIAR LUPA SAKIT HATI"',
          textAlign: TextAlign.center,
          style: AppTypography.display.copyWith(
            fontSize: 28,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '© 2024 AYAM DEPRESI - EST. 2020 DI TENGAH PANDEMI DAN AIR MATA',
          textAlign: TextAlign.center,
          style: AppTypography.labelMono.copyWith(color: AppColors.secondary),
        ),
      ],
    );
  }
}
