import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_typography.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_cached_image.dart';
import '../widgets/brutal_text_field.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../models/menu_item.dart';
import '../models/topping_model.dart';
import '../services/menu_service.dart';

class MenuDetailScreen extends StatefulWidget {
  final MenuItem menu;

  const MenuDetailScreen({super.key, required this.menu});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  double _spiceLevel = 1;
  final Map<String, Topping> _selectedToppings = {};
  final TextEditingController _notesController = TextEditingController();

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
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 120),
                    children: [
                      _buildHeroImage(),
                      Padding(
                        padding: const EdgeInsets.all(
                          AppThemeConstants.marginMobile,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndDescription(),
                            if (widget.menu.spicyLevel > 0) ...[
                              _buildSpiceLevelSlider(),
                              const SizedBox(height: 32),
                            ],
                            if (widget.menu.category != 'MINUMAN') ...[
                              _buildToppings(),
                              const SizedBox(height: 32),
                            ],
                            BrutalTextField(
                              label: 'CATATAN UNTUK PENJUAL',
                              placeholder:
                                  'Contoh: Sambalnya dipisah aja mas...',
                              maxLines: 3,
                              controller: _notesController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 64,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: AppThemeConstants.borderThick,
          ),
        ),
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
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              // Cart Button
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
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
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
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
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
          // Center Title
          Text(
            'AYAM DEPRESI',
            style: AppTypography.headlineMd.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: AppThemeConstants.brutalBorder,
          boxShadow: AppThemeConstants.brutalShadow,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            BrutalCachedImage(
              imageUrl: widget.menu.imageUrl,
              fit: BoxFit.cover,
              memCacheWidth: 600,
              grayscale: widget.menu.isGrayscale,
            ),
            // Dark vignette/gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                  radius: 1.0,
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  'BEST SELLER',
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get dynamicTitle {
    if (widget.menu.category != 'PAKET GEPREK' || widget.menu.spicyLevel == 0) {
      if (widget.menu.spicyLevel > 0) {
        return '${widget.menu.title} (Level $_spiceLevel)';
      }
      return widget.menu.title;
    }
    switch (_spiceLevel.toInt()) {
      case 1: return 'Geprek Pemula';
      case 2: return 'Geprek Patah Hati';
      case 3: return 'Geprek Depresi';
      case 4: return 'Geprek Bunuh Diri';
      default: return widget.menu.title;
    }
  }

  String get dynamicDescription {
    if (widget.menu.category != 'PAKET GEPREK' || widget.menu.spicyLevel == 0) return widget.menu.description;
    switch (_spiceLevel.toInt()) {
      case 1: return 'Pedas malu-malu, cocok buat kamu yang masih belajar menahan luka.';
      case 2: return 'Pedasnya mulai terasa, seperti ditinggal pas lagi sayang-sayangnya.';
      case 3: return 'Sangat pedas, air mata mulai menetes tak terkendali.';
      case 4: return 'Pedas brutal, jangan coba-coba kalau mental tidak kuat!';
      default: return widget.menu.description;
    }
  }

  Widget _buildTitleAndDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dynamicTitle.toUpperCase(),
          style: AppTypography.headlineLgMobile.copyWith(
            height: 1.1,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(widget.menu.price),
          style: AppTypography.bodyLg.copyWith(color: AppColors.error),
        ),
        const SizedBox(height: 16),
        Text(
          dynamicDescription,
          style: AppTypography.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSpiceLevelSlider() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
        boxShadow: AppThemeConstants.brutalShadow,
      ),
      child: Stack(
        children: [
          // Red Triangle in top right corner
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(64, 64),
              painter: TrianglePainter(color: AppColors.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'LEVEL PEDAS',
                      style: AppTypography.labelMono.copyWith(fontSize: 16),
                    ),
                    Text(
                      'Lv. ${_spiceLevel.toInt()}',
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Custom Brutalist Slider implementation
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors.primary,
                    thumbColor: Colors.blue, // As shown in reference
                    overlayColor: Colors.blue.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: Slider(
                    value: _spiceLevel,
                    min: 1,
                    max: 4,
                    divisions: 3,
                    onChanged: (value) {
                      setState(() {
                        _spiceLevel = value;
                      });
                    },
                  ),
                ),
                // Labels below slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lv. 1 (Ringan)',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Lv. 4 (Akut)',
                      style: AppTypography.labelMonoSmall.copyWith(
                        color: AppColors.secondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToppings() {
    return StreamBuilder<List<Topping>>(
      stream: MenuService().getToppings(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final toppings = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOPPING TAMBAHAN',
                  style: AppTypography.labelMono.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Container(height: 4, width: 200, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 16),
            ...toppings.map((topping) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildToppingItem(
                  title: topping.title,
                  price: '+ ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(topping.price)}',
                  isChecked: _selectedToppings.containsKey(topping.id),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedToppings[topping.id] = topping;
                      } else {
                        _selectedToppings.remove(topping.id);
                      }
                    });
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildToppingItem({
    required String title,
    required String price,
    required bool isChecked,
    required ValueChanged<bool?>? onChanged,
    bool isSoldOut = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: AppThemeConstants.brutalBorder,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                    checkColor: AppColors.onPrimary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyMd.copyWith(
                      color: isSoldOut
                          ? AppColors.secondary
                          : AppColors.primary,
                      decoration: isSoldOut ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Text(
                  isSoldOut ? '' : price,
                  style: AppTypography.labelMono.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (isSoldOut)
            Positioned(
              right: 16,
              top: 16,
              child: Transform.rotate(
                angle: -10 * pi / 180,
                child: Container(
                  color: AppColors.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    'SOLD OUT',
                    style: AppTypography.labelMonoSmall.copyWith(
                      color: AppColors.surfaceContainerLowest,
                    ),
                  ),
                ),
              ),
            ),
          if (isSoldOut)
            Positioned.fill(
              child: Container(
                color: AppColors.surfaceContainerHigh.withValues(alpha: 0.6),
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
        height: 80,
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(
              color: AppColors.primary,
              width: AppThemeConstants.borderThick,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeConstants.marginMobile,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL',
                  style: AppTypography.labelMonoSmall.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_calculateTotalPrice()),
                  style: AppTypography.bodyLg.copyWith(color: AppColors.error),
                ),
              ],
            ),
            BrutalButton(
              text: 'TAMBAH',
              icon: Icons.shopping_cart,
              isPrimary: true,
              onPressed: () {
                final itemToAdd = MenuItem(
                  id: widget.menu.id,
                  title: dynamicTitle,
                  description: dynamicDescription,
                  price: _calculateTotalPrice(),
                  spicyLevel: _spiceLevel.toInt(),
                  imageUrl: widget.menu.imageUrl,
                  category: widget.menu.category,
                  tag: widget.menu.tag,
                );
                
                String finalNotes = '';
                final selectedToppings = _selectedToppings.values.map((e) => e.title).toList();
                
                if (selectedToppings.isNotEmpty) {
                  finalNotes += 'Topping: ${selectedToppings.join(", ")}. ';
                }
                if (_notesController.text.isNotEmpty) {
                  finalNotes += 'Catatan: ${_notesController.text}';
                }

                context.read<CartProvider>().addItem(itemToAdd, notes: finalNotes.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$dynamicTitle ditambah ke keranjang.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  num _calculateTotalPrice() {
    num total = widget.menu.price;
    if (widget.menu.category == 'PAKET GEPREK' || widget.menu.category == 'ALA CARTE') {
      for (final topping in _selectedToppings.values) {
        total += topping.price;
      }
    }
    return total;
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width, 0) // top right
      ..lineTo(size.width, size.height) // bottom right
      ..lineTo(0, 0) // top left
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
