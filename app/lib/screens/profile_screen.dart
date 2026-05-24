import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'cart_screen.dart';
import 'address_screen.dart';
import 'login_screen.dart';
import 'history_screen.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopAppBar(context),
        Expanded(
          child: StreamBuilder<UserModel?>(
            stream: UserService().getUserProfileStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Gagal memuat profil penderitaan.'));
              }

              final user = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.marginMobile,
                  vertical: 24,
                ),
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 32),
                  Container(
                    height: 4,
                    color: AppColors.primary,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 32),
                  _buildSettingsList(context),
                  const SizedBox(height: 48),
                  _buildLogoutButton(context),
                  const SizedBox(height: 48),
                ],
              );
            }
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
            'PROFIL KORBAN',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    // Determine level string based on orders
    String level = 'PEMULA';
    if (user.totalOrder > 10) level = 'MENENGAH';
    if (user.totalOrder > 50) level = 'EXTREME';

    final joinYear = user.createdAt.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with Badge
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: AppThemeConstants.brutalShadow,
                ),
                child: const BrutalCachedImage(
                  imageUrl:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBDm1ULIje33cKzBi286st8kOH1rZpvipS1-liievrX_rANmpUORcJxTUixXuRQ4ZHlu8-efPnkbFM9SocdmK8y1f_9cj52JVtqB_RkleshGatkRcmn2GAIWCF8sKimzMljx-A3CN8Y-mUNdkqu0HikyqNH0QIq5xjbKuETW8RuGWerM2KrECMaC9U1LWd2_Q_WmW3Sbn-rE3xNQJapu92YcSru4bQzFlw-o8h83C0tI0nFEw-9MZSag3jdiuWZaPp6pUuI7qMWFTs',
                  fit: BoxFit.cover,
                  memCacheWidth: 400,
                  grayscale: true,
                ),
              ),
              Positioned(
                bottom: -10,
                right: -20,
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
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primary,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'MARTIR CABE',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // User Info
        Text(
          user.nama.toUpperCase(),
          style: AppTypography.headlineLg.copyWith(fontSize: 32),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sentiment_very_dissatisfied,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'KORBAN SEJAK $joinYear',
              style: AppTypography.labelMono.copyWith(
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Stats Bento
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'TOTAL PESANAN',
                value: '${user.totalOrder} KALI',
                valueColor: AppColors.error,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'LEVEL DEPRESI SAAT INI',
                value: level,
                icon: Icons.local_fire_department,
                iconColor: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    Color? valueColor,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.primary, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelMonoSmall.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.headlineMd.copyWith(
                    color: valueColor ?? AppColors.primary,
                    fontSize: 20,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PENGATURAN HIDUP',
          style: AppTypography.headlineMd.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 4,
            decorationColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: 24),
        _buildSettingItem(
          icon: Icons.location_on,
          title: 'Alamat Pengiriman',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddressScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildSettingItem(
          icon: Icons.history,
          title: 'Riwayat Penderitaan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  backgroundColor: AppColors.background,
                  body: SafeArea(child: HistoryScreenContent()),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Color textColor = AppColors.primary,
    Color iconColor = AppColors.primary,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: const [
            BoxShadow(color: AppColors.primary, offset: Offset(2, 2)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: AppTypography.labelMono.copyWith(color: textColor),
              ),
            ),
            const Icon(Icons.arrow_forward, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return BrutalButton(
      text: 'LOG OUT (MENYERAH)',
      isPrimary: false,
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
    );
  }
}
