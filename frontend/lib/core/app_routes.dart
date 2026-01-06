import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// pages
import '../ui/pages/onBoarding.dart';
import '../ui/pages/LoginPage.dart';
import '../ui/pages/registerPage.dart';
import '../ui/pages/ForgotPasswordPage.dart';
import '../ui/pages/forgotOTP.dart';
import '../ui/pages/dashboardPage.dart';
import '../ui/pages/TambahToko.dart';
import '../ui/pages/laporanPenjualan.dart';
import '../ui/pages/TambahProdukPage.dart';
import '../ui/pages/tambahPenggunaPage.dart';
import '../ui/pages/setNewPassword.dart';
import '../ui/pages/TambahEditProduk.dart';
import '../ui/pages/checkoutPage.dart';
import '../state/kasir_controller.dart';

class AppRoutes {
  static const String onBoarding = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgot = '/forgot';
  static const String forgotOTP = '/forgot-otp';
  static const String setNewPassword = '/set-new-password';
  static const String dashboard = '/dashboard';
  static const String tambahToko = '/tambah-toko';
  static const String laporanPenjualan = '/laporan-penjualan';
  static const String editProduk = '/edit-produk';
  static const String tambahPengguna = '/tambah-pengguna';
  static const String checkoutPage = '/checkout';

  static const String initial = onBoarding;

  static Map<String, WidgetBuilder> get routes => {
    onBoarding: (_) => const OnBoardingPage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    forgot: (_) => const ForgotPasswordPage(),
    forgotOTP: (_) => const ForgotOTPPage(),
    setNewPassword: (_) => const SetNewPasswordPage(),
    dashboard: (_) => const DashboardPage(),

    // ROUTE TAMBAH TOKO (AMAN)
    tambahToko: (context) {
      return ChangeNotifierProvider(
        create: (_) => KasirController()..load(),
        child: const TambahTokoPage(),   // TANPA kasirId
      );
    },

    laporanPenjualan: (_) => const LaporanPenjualanPage(),
    editProduk: (_) => const TambahProdukPage(),
    '/tambah-edit-produk': (_) => const TambahEditProduk(),
    tambahPengguna: (_) => const TambahPenggunaPage(),
    checkoutPage: (_) => const CheckoutPage(),
  };
}
