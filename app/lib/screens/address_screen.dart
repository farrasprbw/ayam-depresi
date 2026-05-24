import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'otp_screen.dart'; // for HatchedPatternPainter
import 'cart_screen.dart';
import '../services/user_service.dart';
import '../models/address_model.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_text_field.dart';

class AddressScreen extends StatefulWidget {
  final bool isSelectionMode;
  const AddressScreen({super.key, this.isSelectionMode = false});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
                  StreamBuilder<List<AddressModel>>(
                    stream: UserService().getUserAddressesStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }
                      
                      final addresses = snapshot.data ?? [];

                      return ListView(
                        padding: const EdgeInsets.only(
                          left: AppThemeConstants.marginMobile,
                          right: AppThemeConstants.marginMobile,
                          top: 24,
                          bottom: 120, // space for bottom button
                        ),
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          if (addresses.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Text(
                                'BELUM ADA ALAMAT. MAU DIKIRIM KE MANA DOSA INI?',
                                style: AppTypography.headlineMd.copyWith(color: AppColors.secondary),
                                textAlign: TextAlign.center,
                              ),
                            )
                          else
                            ...addresses.map((address) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: _buildAddressCard(address),
                              );
                            }),
                        ],
                      );
                    }
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

  Widget _buildAddressCard(AddressModel addressData) {
    final bool isPrimary = addressData.isPrimary;
    // We can pick an icon based on title or just use a generic one
    IconData icon = Icons.location_on;
    if (addressData.title.toLowerCase().contains('kantor')) icon = Icons.apartment;
    if (addressData.title.toLowerCase().contains('rumah')) icon = Icons.home;
    
    return GestureDetector(
      onTap: () {
        if (widget.isSelectionMode) {
          Navigator.pop(context, addressData);
        }
      },
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
                          addressData.title,
                          style: AppTypography.headlineMd.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          addressData.address,
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!widget.isSelectionMode)
                          Row(
                            children: [
                              if (!isPrimary)
                                InkWell(
                                  onTap: () {
                                    UserService().setPrimaryAddress(addressData.id);
                                  },
                                  child: Text(
                                    'JADIKAN UTAMA',
                                    style: AppTypography.labelMono.copyWith(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              if (!isPrimary) const SizedBox(width: 24),
                              InkWell(
                                onTap: () {
                                  UserService().deleteAddress(addressData.id);
                                },
                                child: Text(
                                  'HAPUS',
                                  style: AppTypography.labelMono.copyWith(
                                    color: AppColors.error,
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
          onTap: () {
            _showAddAddressDialog();
          },
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

  void _showAddAddressDialog() {
    final titleController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: AppColors.primary, width: 4),
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'TAMBAH ALAMAT',
            style: AppTypography.headlineMd,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrutalTextField(
                controller: titleController,
                label: 'NAMA TEMPAT',
                placeholder: 'Cth: Rumah, Kantor, Kosan',
              ),
              const SizedBox(height: 16),
              BrutalTextField(
                controller: addressController,
                label: 'ALAMAT LENGKAP',
                placeholder: 'Jl. Kenangan Pahit No. 404',
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            BrutalButton(
              text: 'BATAL',
              isPrimary: false,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            BrutalButton(
              text: 'SIMPAN',
              isPrimary: true,
              onPressed: () async {
                if (titleController.text.isNotEmpty && addressController.text.isNotEmpty) {
                  await UserService().addAddress(
                    AddressModel(
                      id: '',
                      title: titleController.text.trim(),
                      address: addressController.text.trim(),
                    ),
                  );
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
