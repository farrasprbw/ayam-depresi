import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'otp_screen.dart'; // for HatchedPatternPainter
import 'cart_screen.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: HatchedPatternPainter()),
                  ),
                  ListView(
                    padding: const EdgeInsets.only(
                      left: AppThemeConstants.marginMobile,
                      right: AppThemeConstants.marginMobile,
                      top: 24,
                      bottom: 120, // space for bottom button
                    ),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildAddressCard(
                        icon: Icons.apartment,
                        title: 'KANTOR (TEMPAT CARI MASALAH)',
                        address:
                            'Sudirman Central Business District, Gedung Menara Putus Asa, Lt. 12, No. 1205. Jakarta Selatan.',
                        isPrimary: true,
                      ),
                      const SizedBox(height: 24),
                      _buildAddressCard(
                        icon: Icons.home,
                        title: 'GUBUK DERITA',
                        address:
                            'Jl. Kenangan Pahit No. 404, Komplek Harapan Palsu Blok C-10. Depok.',
                      ),
                      const SizedBox(height: 24),
                      _buildAddressCard(
                        icon: Icons.school,
                        title: 'KAMPUS (WISUDA KAPAN?)',
                        address:
                            'Gedung Fakultas Teknik, Ruang Sidang Skripsi yang Selalu Ditolak, No. 13.',
                        isDimmed: true,
                      ),
                    ],
                  ),
                  _buildBottomButton(),
                ],
              ),
            ),
          ],
        ),
      ),
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
            'ZONA PENDERITAAN',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PILIH TEMPAT PENJEMPUTAN TAKDIRMU',
          style: AppTypography.headlineMd.copyWith(fontSize: 24, height: 1.1),
        ),
        const SizedBox(height: 8),
        Container(height: 4, width: 96, color: AppColors.primary),
        const SizedBox(height: 16),
        Text(
          'Pastikan kurir kami bisa menemukanmu di tengah hiruk-pikuk kekecewaan ini. Klik untuk edit atau pilih lokasi utama.',
          style: AppTypography.bodyMd.copyWith(color: AppColors.secondary),
        ),
      ],
    );
  }

  Widget _buildAddressCard({
    required IconData icon,
    required String title,
    required String address,
    bool isPrimary = false,
    bool isDimmed = false,
  }) {
    return Opacity(
      opacity: isDimmed ? 0.7 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.primary, width: 4),
          boxShadow: isPrimary
              ? [
                  const BoxShadow(
                    color: AppColors.primary,
                    offset: Offset(8, 8),
                  ),
                ]
              : AppThemeConstants.brutalShadow,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Icon(icon, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.headlineMd.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          address,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Text(
                                isPrimary ? 'UBAH RINCIAN' : 'JADIKAN UTAMA',
                                style: AppTypography.labelMono.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                isPrimary ? 'HAPUS' : 'EDIT',
                                style: AppTypography.labelMono.copyWith(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isPrimary)
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: const [
                      BoxShadow(color: AppColors.primary, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Text(
                    'LOKASI UTAMA',
                    style: AppTypography.labelMonoSmall.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppThemeConstants.marginMobile),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.9),
        ),
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3D00), // Exact color from HTML #ff3d00
              border: Border.all(color: AppColors.primary, width: 4),
              boxShadow: const [
                BoxShadow(color: AppColors.primary, offset: Offset(4, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_location_alt, color: AppColors.onPrimary),
                const SizedBox(width: 16),
                Text(
                  'TAMBAH LOKASI',
                  style: AppTypography.headlineMd.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.arrow_forward, color: AppColors.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
