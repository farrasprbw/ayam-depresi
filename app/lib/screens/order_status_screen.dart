import 'dart:math';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../services/order_service.dart';
import '../models/order_model.dart';

class OrderStatusView extends StatefulWidget {
  final String orderId;
  const OrderStatusView({super.key, required this.orderId});

  @override
  State<OrderStatusView> createState() => _OrderStatusViewState();
}

class _OrderStatusViewState extends State<OrderStatusView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: OrderService().getOrderStream(widget.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final order = snapshot.data;
        if (order == null) {
          return const Center(child: Text('PESANAN TIDAK DITEMUKAN'));
        }

        return Stack(
          children: [
            // Dot pattern background
            CustomPaint(painter: GridPatternPainter(), size: Size.infinite),
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: AppThemeConstants.marginMobile,
                      right: AppThemeConstants.marginMobile,
                      top: 32,
                      bottom: 120, // Space for bottom bar
                    ),
                    children: [
                      _buildHeaderSection(order),
                      const SizedBox(height: 48),
                      _buildTimelineSection(order),
                    ],
                  ),
                ),
              ],
            ),
            _buildBottomBar(),
          ],
        );
      },
    );
  }

  Widget _buildHeaderSection(OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Symbols.skull,
              size: 120,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.1),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Text(
                  'ORDER-${order.id.substring(0, min(8, order.id.length))}',
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                order.status,
                style: AppTypography.headlineLgMobile.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Alamat: ${order.deliveryAddress}',
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(OrderModel order) {
    final status = order.status;
    bool isPending = status == 'PENDING';
    bool isPreparing = status == 'PREPARING';
    bool isDelivering = status == 'DELIVERING';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 4),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 16),
            width: double.infinity,
            child: Text(
              'LIVE TRACKER',
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Timeline steps
          if (isPending)
            _buildActiveTimelineStep(
              'DAPUR TERIMA',
              'Pesanan masuk, bersiaplah.',
            )
          else
            _buildTimelineStep(
              icon: Icons.receipt_long,
              title: 'DAPUR TERIMA',
              description: 'Pesanan masuk.',
              isCompleted: true,
            ),

          if (isPreparing)
            _buildActiveTimelineStep(
              'DI GEPREK',
              'Ayam lagi nangis di pojokan, digeprek.',
            )
          else
            _buildTimelineStep(
              icon: Icons.hardware, // Hammer for Digeprek
              title: 'DI GEPREK',
              description: 'Dipukul kerasnya kenyataan.',
              isCompleted: status == 'DELIVERING' || status == 'COMPLETED',
              isUpcoming: isPending,
            ),

          if (isDelivering)
            _buildActiveTimelineStep(
              'DIANTAR',
              'Kurir lagi jalan bawa kesedihanmu.',
            )
          else
            _buildTimelineStep(
              icon: Icons.directions_bike,
              title: 'DIANTAR',
              description: 'Kurir lagi jalan bawa kesedihanmu..',
              isCompleted: status == 'COMPLETED',
              isUpcoming: isPending || isPreparing,
            ),

          _buildTimelineStep(
            icon: Icons.meeting_room,
            title: 'SAMPAI TUJUAN',
            description: 'Sampai Tujuan. Siap-siap nangis bareng.',
            isUpcoming: status != 'COMPLETED',
            isCompleted: status == 'COMPLETED',
            isLast: true,
            isDashedLine: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String title,
    required String description,
    bool isCompleted = false,
    bool isUpcoming = false,
    bool isLast = false,
    bool isDashedLine = false,
  }) {
    final opacity = isUpcoming ? 0.5 : 1.0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline graphics
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                if (!isLast)
                  Positioned(
                    top: 48,
                    bottom: 0,
                    child: CustomPaint(
                      painter: LinePainter(
                        isDashed: isDashedLine,
                        color: AppColors.primary,
                      ),
                      size: const Size(4, double.infinity),
                    ),
                  ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? Colors.white : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isCompleted ? Colors.white : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Content
          Expanded(
            child: Opacity(
              opacity: opacity,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.labelMono.copyWith(
                        color: isCompleted
                            ? AppColors.secondary
                            : AppColors.primary,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimelineStep(String title, String desc) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline graphics
          SizedBox(
            width: 48,
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 48,
                  bottom: 0,
                  child: CustomPaint(
                    painter: LinePainter(
                      isDashed: true,
                      color: AppColors.primary,
                    ),
                    size: const Size(4, double.infinity),
                  ),
                ),
                // Bouncing active icon container
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -5 * _pulseAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: AppThemeConstants.brutalShadow,
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Active content box
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  border: AppThemeConstants.brutalBorder,
                  boxShadow: AppThemeConstants.brutalShadow,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineMd.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: AppTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      color: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _pulseAnimation.value,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE',
                            style: AppTypography.labelMonoSmall.copyWith(
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.primary,
              width: AppThemeConstants.borderThick,
            ),
          ),
        ),
        child: BrutalButton(
          text: 'CHAT KE DAPUR (WA)',
          icon: Icons.chat,
          isPrimary: true,
          onPressed: () {},
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.outlineVariant
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    const spacing = 20.0;

    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LinePainter extends CustomPainter {
  final bool isDashed;
  final Color color;

  LinePainter({required this.isDashed, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    if (!isDashed) {
      canvas.drawLine(const Offset(2, 0), Offset(2, size.height), paint);
    } else {
      const dashWidth = 8.0;
      const dashSpace = 6.0;
      double startY = 0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(2, startY),
          Offset(2, startY + dashWidth),
          paint,
        );
        startY += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
