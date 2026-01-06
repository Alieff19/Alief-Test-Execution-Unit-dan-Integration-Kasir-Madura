import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../data/models/transaksi.dart';
import '../../data/services/transaksi_service.dart';
import '../../state/cart_controller.dart';
import '../widgets/popup_struk.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final bayarC = TextEditingController();
  double kembalian = 0;
  final TransaksiService _transaksiService = TransaksiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return Scaffold(
      backgroundColor: AppTheme.primaryCream,
      resizeToAvoidBottomInset: true,

      // =========================================================
      //                  CUSTOM HEADER
      // =========================================================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 8,
                      top: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.primaryCream,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          color: AppTheme.primaryCream,
                          size: 40,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Transaksi',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryCream,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cart.items.length} item dalam keranjang',
                          style: GoogleFonts.poppins(
                            color: AppTheme.primaryCream.withOpacity(0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

      // =========================================================
      //                           BODY
      // =========================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= CART ITEMS =================
            Text(
              'Daftar Belanja',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: cart.items.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  return _buildCartRow(cart.items[index], context);
                },
              ),
            ),

            const SizedBox(height: 24),

            // ==================== TOTAL SECTION ====================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryOrange.withOpacity(0.1),
                    AppTheme.primaryRed.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.primaryOrange.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Bayar",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    "Rp${cart.totalHarga.toInt()}",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==================== INPUT PEMBAYARAN ====================
            Text(
              "Uang Dibayarkan",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: bayarC,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Masukkan nominal",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Text(
                    'Rp',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 0),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                ),
              ),
              onChanged: (_) => _hitungKembalian(cart.totalHarga),
            ),

            const SizedBox(height: 20),

            // ==================== KEMBALIAN ====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kembalian < 0 
                    ? Colors.red.shade50 
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: kembalian < 0 
                      ? Colors.red.shade200 
                      : Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kembalian",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kembalian < 0 
                          ? Colors.red.shade700 
                          : Colors.green.shade700,
                    ),
                  ),
                  Text(
                    kembalian < 0 
                        ? "Kurang Rp${kembalian.abs().toInt()}" 
                        : "Rp${kembalian.toInt()}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kembalian < 0 
                          ? Colors.red.shade700 
                          : Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space untuk bottom button
          ],
        ),
      ),

      // =========================================================
      //                  BUTTON CHECKOUT
      // =========================================================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: AppTheme.primaryCream,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryRed.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => _handleCheckout(cart),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.payment_rounded, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Bayar',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  //                      ITEM CART ROW
  // =========================================================
  Widget _buildCartRow(cartItem, BuildContext context) {
    final cart = context.read<CartController>();

    return Row(
      children: [
        // Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.product.nama,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Rp${cartItem.product.hargaJual.toInt()} / item",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSubtle,
                ),
              ),
            ],
          ),
        ),

        // Quantity Controls
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.primaryCream,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              _qtyButton(
                Icons.remove,
                () => cart.removeFromCart(cartItem.product),
                AppTheme.primaryRed,
              ),
              
              Container(
                constraints: const BoxConstraints(minWidth: 32),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "${cartItem.qty}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              
              _qtyButton(
                Icons.add,
                () => cart.addToCart(cartItem.product),
                AppTheme.success,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Total Price
        SizedBox(
          width: 90,
          child: Text(
            "Rp${(cartItem.product.hargaJual * cartItem.qty).toInt()}",
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color,
        ),
      ),
    );
  }

  // =========================================================
  //                   HITUNG KEMBALIAN
  // =========================================================
  void _hitungKembalian(double total) {
    final uang = double.tryParse(bayarC.text) ?? 0;
    setState(() {
      kembalian = uang - total;
    });
  }

  // =========================================================
  //                   HANDLE CHECKOUT (BARU!)
  // =========================================================
  Future<void> _handleCheckout(CartController cart) async {
    print('_handleCheckout dipanggil');
    
    // Validasi keranjang kosong
    if (cart.items.isEmpty) {
      print('Keranjang kosong');
      _showError('Keranjang belanja masih kosong');
      return;
    }

    // Validasi input pembayaran
    if (bayarC.text.isEmpty) {
      print('Input pembayaran kosong');
      _showError('Masukkan jumlah uang pembayaran');
      return;
    }

    // Validasi pembayaran cukup
    if (kembalian < 0) {
      print('Pembayaran tidak cukup: kembalian=$kembalian');
      _showError('Uang pembayaran tidak cukup!');
      return;
    }

    print('Semua validasi lolos');
    setState(() => _isLoading = true);

    try {
      print('Menyiapkan data transaksi...');
      // Siapkan data transaksi
      final items = cart.items.map((item) {
        return ItemTransaksi(
          produkId: item.product.id,
          jumlah: item.qty,
        );
      }).toList();

      final transaksi = Transaksi(
        pembayaran: double.parse(bayarC.text),
        totalBayar: cart.totalHarga,
        kembalian: kembalian,
        items: items,
      );

      print('Mengirim ke backend...');
      // Kirim ke backend dengan timeout
      final result = await _transaksiService.createTransaksi(transaksi).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timeout setelah 10 detik');
          throw Exception('Request timeout. Periksa koneksi internet atau server.');
        },
      );

      print('Transaksi berhasil: ${result.id}');

      // Berhasil - simpan data untuk struk
      final cartItemsCopy = List<CartItem>.from(cart.items);
      final totalBayar = cart.totalHarga;
      final uangDibayar = double.parse(bayarC.text);
      final kembalianFinal = result.kembalian;

      print('Data struk: items=${cartItemsCopy.length}, total=$totalBayar');

      // Clear cart
      cart.clear();
      print('Cart cleared');

      // Stop loading dulu
      setState(() => _isLoading = false);
      print('Loading stopped');

      // Tampilkan popup struk
      if (mounted) {
        print('Memanggil showPopupStruk...');
        await showPopupStruk(
          context: context,
          items: cartItemsCopy,
          totalBayar: totalBayar,
          uangDibayar: uangDibayar,
          kembalian: kembalianFinal,
        );
        print('Popup struk selesai');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
      
      // Parse error message
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      
      // Jika error database lock, berikan pesan yang lebih user-friendly
      if (errorMsg.contains('Lock wait timeout') || errorMsg.contains('could not execute statement')) {
        errorMsg = 'Server sedang sibuk. Silakan coba lagi dalam beberapa saat.';
      }
      
      _showError(errorMsg);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    bayarC.dispose();
    super.dispose();
  }
}