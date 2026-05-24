import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'cart_screen.dart';

class MenuScreenContent extends StatefulWidget {
  const MenuScreenContent({super.key});

  @override
  State<MenuScreenContent> createState() => _MenuScreenContentState();
}

class _MenuScreenContentState extends State<MenuScreenContent> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'PAKET GEPREK',
    'ALA CARTE',
    'MINUMAN',
    'TAMBAHAN'
  ];

  @override
  Widget build(BuildContext context) {
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
              _buildCategoryTabs(),
              const SizedBox(height: 32),
              _buildMenuSection(),
              const SizedBox(height: 64),
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary,
            offset: Offset(0, 4),
            blurRadius: 0,
          )
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
                      side: const BorderSide(color: AppColors.primary, width: 2),
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
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: AppColors.primary),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: AppTypography.labelMonoSmall.copyWith(
                            color: AppColors.onError,
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

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(_categories.length, (index) {
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: isSelected ? AppThemeConstants.brutalShadow : null,
                ),
                child: Text(
                  _categories[index],
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

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _categories[_selectedCategoryIndex],
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
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
        const SizedBox(height: 24),
        // Item 1
        _buildMenuItem(
          imageUrl:
              'https://lh3.googleusercontent.com/aida/ADBb0uhwJ2SHS5x1A8Q0dT1VhJcW057k0Pnl4jBf6CebBjLHUnLbvhvY76aKS6_tzKAwEbbRtdgXOEbFR5VVAoAkHvH7gFfxrBu_a-jpIE0XHUI8gZE681K2D1IF9a04uzcVb3PQj-g_RkQ-aX4mKN31qiikpXEc-kaMdV7aMNhdSrBpGovOVgYjo79LqUo-OIspEHpvUa05GqzKHAgKEvpw4Ik4Fr9_UzwSQaDnwxWCcgaIIGW-1gj2Gu6VSA',
          title: 'Paket Depresi Akut',
          description:
              'Nasi, Ayam Geprek Lv. 5, Es Teh. Penderitaan yang sempurna untuk jiwa yang gersang.',
          price: 'Rp 25.000',
          spicyLevel: 3,
          tag: 'EXTREME SPICY',
        ),
        const SizedBox(height: 24),
        // Item 2
        _buildMenuItem(
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAqo85_bwAKMSX2sXzv28Aq8sn4EKDnXyHK7TgfxLkwgOlKO-939oxP3mURIFVd36dlrAU6LOw8SXe7GVrHGydb92wmzEbHEktCC3PDf94HddNLckUsAGJv45Dw0U0YrUhuDtGB0MbTLwrGdT7thVZbnTYzqbhU7O9RucH4uKE2v3LuT1tAETB7A5kzsIo_7SiUU8XVim8ZlxatLj2bO0TO35-y1XaZD6831IGbG0Km2bw1I4gKJ_WCptvTrgLNZz-xGZdXmsDsQ9A',
          title: 'Paket Sedih Banget',
          description:
              'Nasi, Ayam Geprek Lv. 3, Tempe/Tahu. Cukup pedas untuk melupakan utang piutang.',
          price: 'Rp 22.000',
          spicyLevel: 2,
          isGrayscale: true,
        ),
        const SizedBox(height: 24),
        // Item 3
        _buildMenuItem(
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBKssz35t40v9XZb285UNtp00JFq0gdfMlO9Tg3yjSyQzrCerdk0OO8Swxb0YoOkGEpT7dIHheNxmaXUG8vI5jbOr126dQ9H4G1wK7qOi4xR0Mx8cNMMIzTtgAhXj7BX8eCNemH3kkidspRS-5ndypKNcrKT5jmsOw59ZptwqChUjK2l90PSTm_1xYrQnsU7lva76COkfsiOvwRGVBqpc2x25HOcsho3hP4xfS7yFc-WZwB0Y3gmFEK5iFyDTxrsT80JkNLOwy_mVM',
          title: 'Paket Galau',
          description:
              'Nasi, Ayam Geprek Lv. 1, Lalapan. Untuk kamu yang hatinya selembut sutra tapi nasibnya keras.',
          price: 'Rp 20.000',
          spicyLevel: 1,
        ),
        const SizedBox(height: 24),
        // Item 4: Sold Out
        _buildSoldOutItem(),
      ],
    );
  }

  Widget _buildMenuItem({
    required String imageUrl,
    required String title,
    required String description,
    required String price,
    int spicyLevel = 0,
    String? tag,
    bool isGrayscale = false,
  }) {
    return Container(
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
                child: isGrayscale
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        ),
                        child: BrutalCachedImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )
                    : BrutalCachedImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              if (tag != null)
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
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Text(
                        tag,
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
                        title.toUpperCase(),
                        style: AppTypography.headlineMd.copyWith(
                          fontSize: 24,
                          height: 1.1,
                        ),
                      ),
                    ),
                    if (spicyLevel > 0)
                      Row(
                        children: List.generate(
                          spicyLevel,
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
                  description,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    BrutalButton(
                      text: 'TAMBAH +',
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
    );
  }

  Widget _buildSoldOutItem() {
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
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
                  'PAKET HARAPAN PALSU',
                  style: AppTypography.headlineMd.copyWith(
                    fontSize: 24,
                    height: 1.1,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Menu ini tidak pernah benar-benar ada, seperti masa depanmu.',
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
        Container(
          height: 4,
          width: double.infinity,
          color: AppColors.primary,
        ),
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
          style: AppTypography.labelMono.copyWith(
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
