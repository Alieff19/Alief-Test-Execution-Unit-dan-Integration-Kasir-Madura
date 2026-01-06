import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';

/// Popup notifikasi universal (sukses, error, dsb.)
/// Menampilkan pesan singkat dengan animasi slide dari atas.
class NotifPopup extends StatefulWidget {
  final String message;
  final Duration duration;
  final IconData icon;
  final Color color;

  const NotifPopup({
    super.key,
    required this.message,
    this.icon = Icons.check_circle_rounded,
    this.color = AppTheme.success,
    this.duration = const Duration(seconds: 2),
  });

  /// Factory untuk popup sukses
  factory NotifPopup.success(BuildContext context, String message) {
    return NotifPopup(
      message: message,
      icon: Icons.check_circle_rounded,
      color: AppTheme.success,
    );
  }

  /// Factory untuk popup error (opsional, siap dipakai)
  factory NotifPopup.error(BuildContext context, String message) {
    return NotifPopup(
      message: message,
      icon: Icons.error_rounded,
      color: AppTheme.primaryRed,
    );
  }

  @override
  State<NotifPopup> createState() => _NotifPopupState();
}

class _NotifPopupState extends State<NotifPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Setup animasi slide dari atas ke bawah
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    // Auto-close setelah durasi selesai
    Future.delayed(widget.duration, () {
      if (!mounted) return;
      _controller.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter, // Posisi di tengah atas
          child: SlideTransition(
            position: _slideAnim,
            child: _buildPopupContent(),
          ),
        ),
      ),
    );
  }

  /// Widget isi popup
  Widget _buildPopupContent() {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              widget.message,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget ikon bundar (warna mengikuti tema popup)
  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color,
      ),
      child: Icon(
        widget.icon,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
