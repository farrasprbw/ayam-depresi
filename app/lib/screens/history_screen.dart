import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'cart_screen.dart';
import 'order_status_screen.dart';

class HistoryScreenContent extends StatefulWidget {
  const HistoryScreenContent({super.key});

  @override
  State<HistoryScreenContent> createState() => _HistoryScreenContentState();
}

class _HistoryScreenContentState extends State<HistoryScreenContent> {
  int _selectedTabIndex = 0; // 0 = Aktif, 1 = Selesai

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopAppBar(context),
        _buildTabs(),
        Expanded(
          child: _selectedTabIndex == 0
              ? _buildActiveOrderView()
              : ListView(
                  padding: const EdgeInsets.symmetric(
              horizontal: AppThemeConstants.marginMobile,
              vertical: 24,
            ),
            children: [
              _buildHeroSection(),
              const SizedBox(height: 32),
              _buildHistoryItem(
                date: '24 OKT 2023 • 19:45',
                title: 'PAKET MELEDAK LEVEL 10',
                status: 'SUDAH MELEDAK',
                description:
                    '1x Ayam Geprek Jahanam, 1x Nasi Putih Pucat, 1x Es Teh Tawar Hambar.',
                price: 'RP 45.000',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBa0D7IFlRZvTc_ppq_HHqnY7qnTx-TPEs0OD3eTi9iZmAWgx7eJfoWVTOvnYKV4D40MwWPiPhrNixD1D_3VgGceUMYNNaMwwwNH8IwzbSbFKJo_VkedjGgGNltAjL-OWoy0zDsYebpIpTMXQIn8a40ZNtTtrVhCqsv4kKAL8CSa_PBpRX8rjNCsTY6q9R4QIPCECK7Cx50pjOu1raDcecaF-ZSEYL4rsXJBIVJCnPwDe1kRKIhy5DdgF2SQmAVZ7hhW2rtxD6eclM',
                isSoldOut: false,
              ),
              const SizedBox(height: 24),
              _buildHistoryItem(
                date: '15 OKT 2023 • 12:10',
                title: 'COMBO DEPRESI BERAT',
                status: 'SUDAH MELEDAK',
                description:
                    '2x Ayam Geprek Original, 1x Kol Goreng Krisis, 2x Nasi.',
                price: 'RP 68.000',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBVfMR3UA_4KNPPbuyYqvkzx61odX6d71zdWglPQmAtNcLk-kxcjh1Kye1_YfUwDIQnS-pvV3SzSy_qUKEz3tWliIXGav8eUzU-CxEyvUVyRb_dZl-Y-7XIQ9Olb5bPKO9WYpE8nW1oqT0VkPGCcKSd-M8HG9ngirVo9y-7n4EGe5XQTPQxUgBKC8x4tv1lT9vUeIq7wo8xHyRmX_HngsfaMJJ1IyhBDmwNmSIf-ls4AozyvzAIVLsq7Y-WhBXbZ4FkDN3KiugTPQg',
                isSoldOut: false,
              ),
              const SizedBox(height: 24),
              _buildHistoryItem(
                date: '01 OKT 2023 • 21:00',
                title: 'SAYAP PATAH HATI',
                status: 'TIDAK TERSEDIA',
                description: '6x Wings Level 5, 1x Saus Airmata.',
                price: 'RP 32.000',
                imageUrl:
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBMukt_uznKY7Dvxfi67h-t0o8F3L0Kc_V8i0MBLfiUk3UoazLzyX4mqi_5-7AO-rCX8VFKv-jbQX01d6IccncGlFtknM3kF7N76YPoqm2ke1Z5lYl3HCxKQp6c1MrlGy42_J6PXmyCaNmvutTpUhjQvwWS-kbUe2Ih5sWYdTp-d24BLSkBkmak3_HRmqasacY7VC9q_o0TjCPNZvkDCIMP98IyujLNHbsbfPCCCeSYtjinTyylUr4AnvY-GD5caB6Vh2j7SSLAjCA',
                isSoldOut: true,
              ),
              const SizedBox(height: 96),
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
          bottom: BorderSide(
            color: AppColors.primary,
            width: AppThemeConstants.borderThick,
          ),
        ),
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
              Navigator.canPop(context)
                  ? IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                      ),
                    )
                  : const SizedBox(width: 40),
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

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DOSA MASA LALU',
          style: AppTypography.headlineLg.copyWith(fontSize: 36),
        ),
        const SizedBox(height: 8),
        Text(
          'Rekam jejak keputusasaan anda dalam bentuk potongan ayam geprek yang terbakar. Ulangi kesalahan yang sama jika berani.',
          style: AppTypography.labelMono.copyWith(color: AppColors.secondary),
        ),
        const SizedBox(height: 32),
        Container(height: 4, color: AppColors.primary, width: double.infinity),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String title,
    required String status,
    required String description,
    required String price,
    required String imageUrl,
    required bool isSoldOut,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSoldOut
            ? AppColors.surfaceContainerLow
            : AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image container
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 4),
                    ),
                  ),
                  child: BrutalCachedImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 600,
                    grayscale: true,
                    opacity: isSoldOut ? 0.5 : 1.0,
                  ),
                ),
                const SizedBox(height: 16),
                // Content
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: AppTypography.labelMono.copyWith(
                              color: AppColors.secondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 24,
                              decoration: isSoldOut
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: isSoldOut
                                  ? AppColors.secondary
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: isSoldOut
                          ? AppColors.secondary
                          : AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        status,
                        style: AppTypography.labelMonoSmall.copyWith(
                          color: AppColors.onPrimary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    decoration: isSoldOut ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 2,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: AppTypography.headlineMd.copyWith(
                        fontSize: 24,
                        color: isSoldOut
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                    if (isSoldOut)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryFixedDim,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'STOK HABIS',
                          style: AppTypography.labelMono.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                      )
                    else
                      BrutalButton(
                        text: 'PESAN LAGI',
                        isPrimary: true,
                        onPressed: () {},
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isSoldOut)
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: -5 * pi / 180,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withValues(
                        alpha: 0.9,
                      ),
                      border: const Border(
                        top: BorderSide(color: AppColors.primary, width: 4),
                        bottom: BorderSide(color: AppColors.primary, width: 4),
                      ),
                    ),
                    child: Text(
                      'SOLD OUT',
                      style: AppTypography.headlineLg.copyWith(
                        color: AppColors.primary,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0
                      ? AppColors.primary
                      : AppColors.background,
                ),
                child: Center(
                  child: Text(
                    'SEDANG DISIKSA',
                    style: AppTypography.labelMono.copyWith(
                      color: _selectedTabIndex == 0
                          ? AppColors.onPrimary
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1
                      ? AppColors.primary
                      : AppColors.background,
                  border: const Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Center(
                  child: Text(
                    'MASA LALU',
                    style: AppTypography.labelMono.copyWith(
                      color: _selectedTabIndex == 1
                          ? AppColors.onPrimary
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderView() {
    return const OrderStatusView();
  }
}
