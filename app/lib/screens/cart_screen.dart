import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'otp_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeConstants.marginMobile,
                  vertical: 24,
                ),
                children: [
                  _buildPageTitle(),
                  const SizedBox(height: 32),
                  _buildCartItem(
                    title: 'PAKET PUTUS CINTA',
                    description:
                        'Nasi, Ayam Geprek Level 10, es teh tawar (setawar janji manisnya).',
                    price: 'Rp 35.000',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAQlECNkx7RNngoCbuwG-Bg3ZLioCC8OqT1VrLvubA54yEfPk9u3pa1djiCcPss3tT53wyVM-f05AHaHtsuaTtxvOIzRvvcKLgezZvdUd2aRE1LQF_5sXJc5g_VBI8DHR-wNhGzTBW87Tl6tW9p5N_FnjBqlJklzSYzaycEafB4L1dgp6YJZoDnWbHGvwVb7uDaKdv1nL91fXAWlsGIiRNJ5PO9BH1kBlD0ITN-ca2xGNVF0QKkHy-vwM5tsmwNmkiXFxuTY5cCmUw',
                    tags: [
                      _buildTag('EXTREME SPICY', AppColors.error),
                      _buildTag('LEVEL 10', AppColors.primary),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildCartItem(
                    title: 'AYAM DEPRESI AKUT',
                    description:
                        'Hanya ayam tanpa harapan, dibalut cabai yang lebih pedas dari omongan tetangga.',
                    price: 'Rp 28.000',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuByhkYGsmY5uSDUKBQOm7CeVVzUHHZdlrWTASw1tNBBBdNJ_Q-YSKF7PK8XFl8Z37Lhjllx1Jv9xVvH9jmmfz1N1UpSmdZDHxX3AM7jgzCpE7zwAaCA7V-6Q3knELBW3nKIou1KJK1k4WBWvE8vcvbFqgj69QQQm2iwqCcBRxwG-ZXMf0SwSe5McXH3hATkD4ermaS-ZHZSSIAMs_qH_L8326NRQVKq44Crr_muw-NVdNMwdWXPdUUNZpTS32teurEL5ycDHX30p-s',
                    tags: [_buildTag('DANGER', AppColors.error)],
                  ),
                  const SizedBox(height: 32),
                  _buildWarningSection(),
                  const SizedBox(height: 48),
                  _buildSummarySection(),
                  const SizedBox(height: 96),
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
                    onPressed: () {}, // Already on Cart screen
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
                          '3', // Match global state design
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

  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KERANJANG PENDERITAAN',
          style: AppTypography.headlineLg.copyWith(fontSize: 36),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            border: Border.all(color: AppColors.primary, width: 4),
            boxShadow: AppThemeConstants.brutalShadow,
          ),
          child: Text(
            'STATUS: SEDANG MENIMBUN MASALAH',
            style: AppTypography.labelMono.copyWith(color: AppColors.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Text(
        text,
        style: AppTypography.labelMonoSmall.copyWith(
          color: AppColors.onPrimary,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildCartItem({
    required String title,
    required String description,
    required String price,
    required String imageUrl,
    required List<Widget> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(color: AppColors.primary, width: 4),
                ),
                child: BrutalCachedImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  grayscale: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.secondary,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(spacing: 8, runSpacing: 8, children: tags),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: AppTypography.headlineMd.copyWith(fontSize: 24),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        color: Colors.transparent,
                        child: const Text(
                          '-',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text('1', style: AppTypography.labelMono),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        color: Colors.transparent,
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  Widget _buildWarningSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(color: AppColors.primary, width: 4),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'YAKIN KUAT NAMBAH BEBAN?',
            style: AppTypography.headlineMd.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Lambungmu mungkin menyerah, tapi egomu tidak.',
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            border: AppThemeConstants.brutalBorder,
            boxShadow: const [
              BoxShadow(color: AppColors.primary, offset: Offset(8, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Text(
                  'TOTAL PENDERITAAN',
                  style: AppTypography.headlineMd.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryRow('HARGA DASAR', 'Rp 63.000'),
              const SizedBox(height: 16),
              _buildSummaryRow('BIAYA PENYESALAN', 'Rp 5.000', isError: true),
              const SizedBox(height: 16),
              _buildSummaryRow('ONGKIR JAUH', 'Rp 12.000'),
              const SizedBox(height: 24),
              Container(height: 2, color: AppColors.primary),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL',
                    style: AppTypography.headlineMd.copyWith(fontSize: 24),
                  ),
                  Text(
                    'Rp 80.000',
                    style: AppTypography.headlineMd.copyWith(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              BrutalButton(
                text: 'BAYAR SEKARANG',
                isPrimary: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OtpScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'TIDAK MELAYANI PENGEMBALIAN AIR MATA',
                  style: AppTypography.labelMonoSmall.copyWith(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondaryContainer,
            border: Border.all(color: AppColors.primary, width: 4),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'KODE PROMO SEDIH',
                    hintStyle: AppTypography.labelMono.copyWith(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  style: AppTypography.labelMono,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: AppColors.primary,
                child: Text(
                  'CEK',
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isError = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.labelMono.copyWith(
            color: isError ? AppColors.error : AppColors.primary,
          ),
        ),
        Text(
          value,
          style: AppTypography.labelMono.copyWith(
            color: isError ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
