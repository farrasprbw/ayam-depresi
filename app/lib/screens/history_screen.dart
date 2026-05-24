import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import 'cart_screen.dart';
import 'order_status_screen.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

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
          child: StreamBuilder<List<OrderModel>>(
            stream: OrderService().getUserOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              final orders = snapshot.data ?? [];
              final activeOrders = orders.where((o) => ['PENDING', 'PREPARING', 'DELIVERING'].contains(o.status)).toList();
              final pastOrders = orders.where((o) => !['PENDING', 'PREPARING', 'DELIVERING'].contains(o.status)).toList();

              if (_selectedTabIndex == 0) {
                return _buildActiveOrderView(activeOrders);
              } else {
                return _buildPastOrderView(pastOrders);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPastOrderView(List<OrderModel> pastOrders) {
    if (pastOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'BELUM ADA DOSA MASA LALU.',
            style: AppTypography.headlineMd.copyWith(color: AppColors.secondary),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final formatDate = DateFormat('dd MMM yyyy • HH:mm');

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeConstants.marginMobile,
        vertical: 24,
      ),
      children: [
        _buildHeroSection(),
        const SizedBox(height: 32),
        ...pastOrders.map((order) {
          String firstItemName = order.items.isNotEmpty ? order.items.first['title'] : 'Pesanan Misterius';
          String desc = '${order.items.length} Macam Penderitaan';
          String img = order.items.isNotEmpty ? order.items.first['imageUrl'] : '';
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _buildHistoryItem(
              date: formatDate.format(order.createdAt),
              title: firstItemName.toUpperCase(),
              status: order.status,
              description: desc,
              price: formatCurrency.format(order.totalAmount),
              imageUrl: img,
              isSoldOut: order.status == 'CANCELLED',
            ),
          );
        }),
        const SizedBox(height: 96),
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
                  child: imageUrl.isNotEmpty ? BrutalCachedImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 600,
                    grayscale: true,
                    opacity: isSoldOut ? 0.5 : 1.0,
                  ) : Container(color: AppColors.outline),
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

  Widget _buildActiveOrderView(List<OrderModel> activeOrders) {
    if (activeOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'BELUM ADA DOSA YANG BERJALAN.',
            style: AppTypography.headlineMd.copyWith(color: AppColors.secondary),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    
    // For simplicity, just track the latest active order
    final latestOrder = activeOrders.first;
    return OrderStatusView(orderId: latestOrder.id);
  }
}
