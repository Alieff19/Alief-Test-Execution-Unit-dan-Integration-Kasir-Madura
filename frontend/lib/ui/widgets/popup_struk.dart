import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../state/cart_controller.dart';
import 'package:intl/intl.dart';

class PopupStruk extends StatefulWidget {
  final List<CartItem> items;
  final double totalBayar;
  final double uangDibayar;
  final double kembalian;

  const PopupStruk({
    Key? key,
    required this.items,
    required this.totalBayar,
    required this.uangDibayar,
    required this.kembalian,
  }) : super(key: key);

  @override
  State<PopupStruk> createState() => _PopupStrukState();
}

class _PopupStrukState extends State<PopupStruk> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    print('PopupStruk initState - items: ${widget.items.length}');
    
    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Scale animation (from 0.8 to 1.0)
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    // Fade animation (from 0.0 to 1.0)
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start animation
    _animationController.forward();
    
    // Auto close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      print(' Auto close triggered');
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop(); // Kembali ke dashboard
        print('Navigasi selesai');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Success - Full Width
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.success,
                    size: 56,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pembayaran Berhasil!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(now),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Struk Content
            Container(
              constraints: const BoxConstraints(maxHeight: 350),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daftar Belanja
                    Text(
                      'Rincian Belanja',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Items
                    ...widget.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.nama,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${item.qty} x Rp${item.product.hargaJual.toInt()}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.textSubtle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp${(item.product.hargaJual * item.qty).toInt()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        )),

                    Divider(
                      height: 32,
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),

                    // Total
                    _buildInfoRow('Total Belanja', 'Rp${widget.totalBayar.toInt()}', false),
                    const SizedBox(height: 12),
                    _buildInfoRow('Uang Dibayar', 'Rp${widget.uangDibayar.toInt()}', false),
                    const SizedBox(height: 12),

                    // Kembalian (Highlighted)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.success.withOpacity(0.1),
                            AppTheme.success.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.success.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kembalian',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.success,
                            ),
                          ),
                          Text(
                            'Rp${widget.kembalian.toInt()}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isHighlight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isHighlight ? AppTheme.success : AppTheme.textPrimary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isHighlight ? 18 : 14,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w700,
            color: isHighlight ? AppTheme.success : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Helper function untuk menampilkan popup struk
Future<void> showPopupStruk({
  required BuildContext context,
  required List<CartItem> items,
  required double totalBayar,
  required double uangDibayar,
  required double kembalian,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopupStruk(
        items: items,
        totalBayar: totalBayar,
        uangDibayar: uangDibayar,
        kembalian: kembalian,
      );
    },
  );
}
