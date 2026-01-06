import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

/// Dialog konfirmasi yang dapat digunakan kembali untuk berbagai keperluan
/// seperti logout, delete, dan aksi konfirmasi lainnya
class ConfirmDialog extends StatefulWidget {
  /// Icon yang akan ditampilkan di bagian atas dialog
  final IconData icon;

  /// Pesan konfirmasi yang akan ditampilkan
  final String message;

  /// Text untuk tombol kiri (biasanya untuk batal/tidak)
  final String leftButtonText;

  /// Text untuk tombol kanan (biasanya untuk konfirmasi/ya)
  final String rightButtonText;

  /// Callback ketika tombol kiri ditekan
  final VoidCallback? onLeftButtonPressed;

  /// Callback ketika tombol kanan ditekan
  final VoidCallback? onRightButtonPressed;

  /// Warna untuk tombol kanan (default: merah untuk aksi berbahaya)
  final Color? rightButtonColor;

  const ConfirmDialog({
    Key? key,
    required this.icon,
    required this.message,
    this.leftButtonText = 'Batal',
    this.rightButtonText = 'Ya',
    this.onLeftButtonPressed,
    this.onRightButtonPressed,
    this.rightButtonColor,
  }) : super(key: key);

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            decoration: BoxDecoration(
              color: Color(0xFFFEF3E2),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Color(0x1AFFFFFF),
                  blurRadius: 20,
                  offset: Offset(0, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                
                // Icon Section dengan background
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryRed.withOpacity(0.15),
                        Color(0xFFB81313).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14159), // Flip horizontal (mirror)
                    child: Icon(
                      widget.icon,
                      color: Color(0xFFB81313),
                      size: 32,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Message Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFEF5542),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Divider
                Container(
                  height: 1,
                  color: Color(0xFFEAE0D2),
                ),

                // Buttons Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F0E5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Left Button (Batal)
                      Expanded(
                        child: _buildButton(
                          text: widget.leftButtonText,
                          backgroundColor: Colors.transparent,
                          textColor: AppTheme.primaryOrange,
                          borderColor: AppTheme.primaryOrange,
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            widget.onLeftButtonPressed?.call();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Right Button (Ya/Konfirmasi)
                      Expanded(
                        child: _buildButton(
                          text: widget.rightButtonText,
                          backgroundColor: widget.rightButtonColor ?? Color(0xFFB81313),
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            widget.onRightButtonPressed?.call();
                          },
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
    );
  }

  Widget _buildButton({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
    Color? borderColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.5)
                : null,
            boxShadow: backgroundColor != Colors.transparent
                ? [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function untuk menampilkan dialog konfirmasi
/// Returns true jika user menekan tombol konfirmasi, false jika batal
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required IconData icon,
  required String message,
  String leftButtonText = 'Batal',
  String rightButtonText = 'Ya',
  VoidCallback? onLeftButtonPressed,
  VoidCallback? onRightButtonPressed,
  Color? rightButtonColor,
}) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ConfirmDialog(
        icon: icon,
        message: message,
        leftButtonText: leftButtonText,
        rightButtonText: rightButtonText,
        onLeftButtonPressed: onLeftButtonPressed,
        onRightButtonPressed: onRightButtonPressed,
        rightButtonColor: rightButtonColor,
      );
    },
  );
}

/// Contoh penggunaan untuk logout
Future<bool?> showLogoutConfirmDialog(BuildContext context) {
  return showConfirmDialog(
    context: context,
    icon: Icons.logout_rounded,
    message: 'Anda akan keluar dari akun ini. Lanjutkan?',
    leftButtonText: 'Batal',
    rightButtonText: 'Ya,keluar',
    rightButtonColor: Color(0xFFB81313),
  );
}

/// Contoh penggunaan untuk delete
Future<bool?> showDeleteConfirmDialog(
  BuildContext context, {
  String itemName = 'item ini',
}) {
  return showConfirmDialog(
    context: context,
    icon: Icons.delete_outline,
    message: 'Anda akan menghapus $itemName. Lanjutkan?',
    leftButtonText: 'Batal',
    rightButtonText: 'Ya,hapus',
    rightButtonColor: Color(0xFFB81313),
  );
}

/// Contoh penggunaan untuk keluar dari toko
Future<bool?> showExitTokoConfirmDialog(BuildContext context) {
  return showConfirmDialog(
    context: context,
    icon: Icons.store_outlined,
    message: 'Anda akan keluar dari toko ini. Lanjutkan?',
    leftButtonText: 'Batal',
    rightButtonText: 'Ya,keluar',
    rightButtonColor: Color(0xFFB81313),
  );
}
