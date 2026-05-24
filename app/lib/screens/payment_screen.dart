import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'cart_screen.dart';
import 'otp_screen.dart'; // for HatchedPatternPainter

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash';

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
                  ListView(
                    padding: const EdgeInsets.only(
                      left: AppThemeConstants.marginMobile,
                      right: AppThemeConstants.marginMobile,
                      top: 32,
                      bottom: 120, // space for bottom action
                    ),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildPaymentOption(
                        id: 'cash',
                        title: 'DUIT PANAS (CASH)',
                        subtitle: 'BAYAR LANGSUNG DI TEMPAT KEJADIAN',
                        icon: Icons.payments,
                      ),
                      const SizedBox(height: 24),
                      _buildPaymentOption(
                        id: 'wallet',
                        title: 'SIKSA DIGITAL (E-WALLET)',
                        subtitle: 'QRIS, GOPAY, OVO, DAN LAIN-LAIN',
                        icon: Icons.account_balance_wallet,
                      ),
                      const SizedBox(height: 24),
                      _buildPaymentOption(
                        id: 'bank',
                        title: 'TRANSFER PENYESALAN (BANK)',
                        subtitle: 'VIRTUAL ACCOUNT SEMUA BANK',
                        icon: Icons.account_balance,
                      ),
                      const SizedBox(height: 48),
                      _buildOrderSummary(),
                      const SizedBox(height: 24),
                      Text(
                        'DENGAN MENGEKLIK KONFIRMASI, ANDA SETUJU BAHWA RASA PEDAS INI ADALAH PILIHAN HIDUP ANDA SENDIRI DAN KAMI TIDAK BERTANGGUNG JAWAB ATAS GEJALA FISIK MAUPUN SPIRITUAL YANG MUNGKIN TIMBUL.',
                        style: AppTypography.labelMonoSmall.copyWith(
                          color: AppColors.outline,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  // Background decoration text
                  Positioned(
                    top: 96,
                    right: -48,
                    child: Transform.rotate(
                      angle: 12 * pi / 180,
                      child: Text(
                        'SADNESS\nDELIVERY',
                        style: AppTypography.headlineLg.copyWith(
                          fontSize: 120,
                          color: AppColors.primary.withValues(alpha: 0.05),
                          height: 0.9,
                        ),
                      ),
                    ),
                  ),
                  _buildBottomAction(),
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
            'PEMBAYARAN',
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
          'METODE\nPEMBAYARAN',
          style: AppTypography.headlineMd.copyWith(fontSize: 36, height: 1.0),
        ),
        const SizedBox(height: 8),
        Container(height: 4, width: 96, color: AppColors.primary),
        const SizedBox(height: 24),
        Text(
          'PILIH CARA ANDA MEMBAYAR DOSA INI',
          style: AppTypography.labelMono.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethod == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = id;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerLowest,
          border: Border.all(color: AppColors.primary, width: 4),
          boxShadow: isSelected ? [] : AppThemeConstants.brutalShadow,
        ),
        child: Stack(
          children: [
            if (!isSelected)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(painter: HatchedPatternPainter()),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          icon,
                          size: 36,
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: AppTypography.headlineMd.copyWith(
                            fontSize: 24,
                            color: isSelected
                                ? AppColors.onPrimary
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTypography.labelMonoSmall.copyWith(
                            color: isSelected
                                ? AppColors.onPrimary.withValues(alpha: 0.8)
                                : AppColors.primary.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 4),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: const Border(
          top: BorderSide(color: AppColors.primary, width: 4),
          left: BorderSide(color: AppColors.primary, width: 4),
          right: BorderSide(color: AppColors.primary, width: 4),
          bottom: BorderSide(color: AppColors.primary, width: 4),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(painter: HatchedPatternPainter()),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                child: Text(
                  'RINGKASAN DOSA',
                  style: AppTypography.labelMono.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('AYAM DEPRESI LV. 5', 'RP 25.000'),
              const SizedBox(height: 8),
              _buildSummaryRow('NASI PUTIH POLOS', 'RP 5.000'),
              const SizedBox(height: 8),
              _buildSummaryRow(
                'ONGKOS PENDERITAAN',
                'RP 10.000',
                isError: true,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary,
                      width: 4,
                      style: BorderStyle.solid,
                    ), // Flutter doesn't easily support dashed borders natively without a package, using solid for now
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TOTAL TAGIHAN',
                      style: AppTypography.headlineMd.copyWith(fontSize: 20),
                    ),
                    Text(
                      'Rp 40.000',
                      style: AppTypography.headlineMd.copyWith(fontSize: 32),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isError = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMonoSmall.copyWith(
            color: isError ? AppColors.error : AppColors.primary,
            fontWeight: isError ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: AppTypography.labelMonoSmall.copyWith(
            color: isError ? AppColors.error : AppColors.primary,
            fontWeight: isError ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppThemeConstants.marginMobile),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.primary, width: 4)),
        ),
        child: InkWell(
          onTap: () {
            // Show alert or handle payment
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Pesanan Diterima. Selamat Menikmati Penderitaan.',
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFBA1A1A), // accent-red
              border: Border.all(color: AppColors.primary, width: 4),
              boxShadow: const [
                BoxShadow(color: AppColors.primary, offset: Offset(4, 4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'KONFIRMASI PEMBAYARAN',
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.check_circle, color: AppColors.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
