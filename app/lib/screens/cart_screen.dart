import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'package:intl/intl.dart';
import '../widgets/brutal_text_field.dart';
import '../models/address_model.dart';
import 'address_screen.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _notesController = TextEditingController();
  AddressModel? _selectedAddress;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

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
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              'KERANJANG KOSONG.\nSEPERTI HATIMU.',
                              style: AppTypography.headlineMd.copyWith(color: AppColors.secondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      final cartItems = cart.items.values.toList();
                      return Column(
                        children: [
                          ...cartItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildCartItem(
                                cartItem: item,
                                cart: cart,
                              ),
                            );
                          }),
                          const SizedBox(height: 32),
                          
                          // Input Catatan & Alamat
                          BrutalTextField(
                            controller: _notesController,
                            label: 'CATATAN PESANAN (OPSIONAL)',
                            placeholder: 'Cth: Jangan terlalu pedas, aku sudah sering disakiti',
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          
                          // Address Selector
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ALAMAT PENGIRIMAN',
                                style: AppTypography.labelMono.copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final selected = await Navigator.push<AddressModel>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddressScreen(isSelectionMode: true),
                                    ),
                                  );
                                  if (selected != null) {
                                    setState(() {
                                      _selectedAddress = selected;
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLowest,
                                    border: Border.all(color: AppColors.primary, width: 4),
                                    boxShadow: AppThemeConstants.brutalShadow,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedAddress?.title ?? 'PILIH ALAMAT',
                                              style: AppTypography.headlineMd.copyWith(fontSize: 18),
                                            ),
                                            if (_selectedAddress != null) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                _selectedAddress!.address,
                                                style: AppTypography.bodyMd,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios, color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),
                          _buildWarningSection(),
                          const SizedBox(height: 48),
                          _buildSummarySection(cart),
                        ],
                      );
                    },
                  ),
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
    required CartItem cartItem,
    required CartProvider cart,
  }) {
    final menu = cartItem.menuItem;
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
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
                  imageUrl: menu.imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  grayscale: menu.isGrayscale,
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
                            menu.title.toUpperCase(),
                            style: AppTypography.headlineMd.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cart.removeItem(menu.id);
                          },
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
                      menu.description,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.secondary,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, 
                      runSpacing: 8, 
                      children: [
                        if (menu.spicyLevel > 0)
                          _buildTag('LEVEL ${menu.spicyLevel}', AppColors.primary),
                        if (menu.tag != null && menu.tag!.isNotEmpty)
                          _buildTag(menu.tag!, AppColors.error),
                      ],
                    ),
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
                formatCurrency.format(cartItem.totalPrice),
                style: AppTypography.headlineMd.copyWith(fontSize: 24),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        cart.decrementItem(menu.id);
                      },
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
                      child: Text('${cartItem.quantity}', style: AppTypography.labelMono),
                    ),
                    InkWell(
                      onTap: () {
                        cart.addItem(menu);
                      },
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

  Widget _buildSummarySection(CartProvider cart) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final total = cart.totalAmount;

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
              _buildSummaryRow('HARGA DASAR', formatCurrency.format(total)),
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
                    formatCurrency.format(total),
                    style: AppTypography.headlineMd.copyWith(fontSize: 24),
                  ),
                ],
              ),
              BrutalButton(
                text: 'LANJUT PEMBAYARAN',
                isPrimary: true,
                onPressed: () => _handleCheckout(cart),
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

  void _handleCheckout(CartProvider cart) {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat pengiriman wajib dipilih!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          cartItems: cart.items.values.toList(),
          totalAmount: cart.totalAmount,
          orderNotes: _notesController.text.trim(),
          deliveryAddress: '${_selectedAddress!.title}\n${_selectedAddress!.address}',
        ),
      ),
    );
  }
}
