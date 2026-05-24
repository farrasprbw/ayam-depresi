import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/order_service.dart';
import '../services/payment_service.dart';
import '../models/payment_method_model.dart';
import '../models/cart_item.dart';
import 'package:intl/intl.dart';
import 'otp_screen.dart'; // For HatchedPatternPainter

class PaymentScreen extends StatefulWidget {
  final List<CartItem>? cartItems;
  final num? totalAmount;
  final String? orderNotes;
  final String? deliveryAddress;
  final num? discountAmount;
  final bool isManagementMode;

  const PaymentScreen({
    super.key,
    this.cartItems,
    this.totalAmount,
    this.orderNotes,
    this.deliveryAddress,
    this.discountAmount,
    this.isManagementMode = false,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethodId;
  bool _isLoading = false;

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
                  StreamBuilder<List<PaymentMethodModel>>(
                    stream: PaymentService().getPaymentMethodsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                      }
                      
                      final methods = snapshot.data ?? [];
                      
                      // Auto-select first if none selected
                      if (_selectedPaymentMethodId == null && methods.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _selectedPaymentMethodId = methods.first.id);
                        });
                      }

                      return ListView(
                        padding: EdgeInsets.only(
                          left: AppThemeConstants.marginMobile,
                          right: AppThemeConstants.marginMobile,
                          top: 24,
                          bottom: widget.isManagementMode ? 24 : 120, // Space for bottom action if not management mode
                        ),
                        children: [
                          _buildSectionTitle('PILIH JALAN KESENGSARAAN'),
                          const SizedBox(height: 16),
                          ...methods.map((method) {
                            IconData icon = Icons.payments;
                            if (method.type == 'qris' || method.type == 'ewallet') icon = Icons.qr_code;
                            if (method.type == 'bank') icon = Icons.account_balance;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _buildPaymentOption(
                                id: method.id,
                                title: method.name,
                                subtitle: method.type.toUpperCase(),
                                icon: icon,
                              ),
                            );
                          }),
                          if (!widget.isManagementMode) ...[
                            const SizedBox(height: 32),
                            _buildSectionTitle('RINGKASAN DOSA'),
                            const SizedBox(height: 16),
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
                        ],
                      );
                    }
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

  Widget _buildSectionTitle(String title) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTypography.headlineLg.copyWith(
          fontSize: 24,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedPaymentMethodId == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethodId = id;
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
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
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
              ...(widget.cartItems ?? []).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildSummaryRow('${item.quantity}x ${item.menuItem.title}', formatCurrency.format(item.totalPrice)),
                );
              }),
              if (widget.discountAmount != null && widget.discountAmount! > 0) ...[
                const SizedBox(height: 8),
                _buildSummaryRow(
                  'POTONGAN SEDIH',
                  '-${formatCurrency.format(widget.discountAmount)}',
                  isError: true,
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
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
                      formatCurrency.format(widget.totalAmount),
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
          onTap: _isLoading ? null : _handlePaymentConfirmation,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: _isLoading ? AppColors.outline : const Color(0xFFBA1A1A), // accent-red
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

  Future<void> _handlePaymentConfirmation() async {
    if (_selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await OrderService().placeOrder(
        cartItems: widget.cartItems ?? [],
        totalAmount: widget.totalAmount ?? 0,
        orderNotes: widget.orderNotes ?? '',
        deliveryAddress: widget.deliveryAddress ?? '',
      );

      // Clear cart
      if (mounted) {
        Provider.of<CartProvider>(context, listen: false).clearCart();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat! Rasa sakit segera dikirim.')),
        );
        
        // Go back to Home
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
