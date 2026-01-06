import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../core/app_routes.dart';
import '../widgets/notif_popup.dart';
import '../widgets/button.dart';
import '../../data/services/auth_service.dart';   // ✅ WAJIB import

class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordC = TextEditingController();
  final _confirmC = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  OutlineInputBorder _rounded(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: c, width: 1),
  );

  InputDecoration _dec({
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggleObscure,
    required Color fill,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.textPrimary),
      suffixIcon: IconButton(
        onPressed: toggleObscure,
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppTheme.textPrimary,
        ),
      ),
      filled: true,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: _rounded(Colors.transparent),
      enabledBorder: _rounded(Colors.transparent),
      focusedBorder: _rounded(Colors.transparent),
      errorBorder: _rounded(AppTheme.error),
      focusedErrorBorder: _rounded(AppTheme.error),
    );
  }

  // ----------------------------------------------------------------------
  //                🔥 RESET PASSWORD (LOGIC BARU)
  // ----------------------------------------------------------------------
  void _resetPassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final phone =
    ModalRoute.of(context)!.settings.arguments as String; // ✅ ambil no HP

    setState(() => _isLoading = true);

    final success = await AuthService()
        .resetPassword(phone, _passwordC.text.trim()); // 🔥 kirim ke backend

    if (!mounted) return;

    if (success) {
      // 🔥 popup sukses
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            NotifPopup.success(context, "Password kamu berhasil direset"),
      );

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.error,
          content: Text(
            "Gagal mereset password",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  // ----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.primaryCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Image.asset(
                  'assets/images/logo3.png',
                  width: 146,
                  height: 146,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Madura Store',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryRed,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Set New password',
                style: GoogleFonts.poppins(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.balckicon,
                ),
              ),
              const SizedBox(height: 32),

              // === FORM PASSWORD ===
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === NEW PASSWORD ===
                    Text(
                      'New Password',
                      style: GoogleFonts.poppins(
                        color: AppTheme.balckicon,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordC,
                      obscureText: _obscurePass,
                      decoration: _dec(
                        hint: 'Enter new password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscurePass,
                        toggleObscure: () =>
                            setState(() => _obscurePass = !_obscurePass),
                        fill: Theme.of(context).colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        } else if (value.length < 8) {
                          return "Minimal 8 karakter";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // === CONFIRM PASSWORD ===
                    Text(
                      'Confirm Password',
                      style: GoogleFonts.poppins(
                        color: AppTheme.balckicon,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _confirmC,
                      obscureText: _obscureConfirm,
                      decoration: _dec(
                        hint: 'Enter confirm password',
                        icon: Icons.lock_outline_rounded,
                        obscure: _obscureConfirm,
                        toggleObscure: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        fill: Theme.of(context).colorScheme.surface,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Konfirmasi password tidak boleh kosong";
                        } else if (value != _passwordC.text) {
                          return "Password tidak cocok";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // === BUTTON RESET ===
              Button(
                label: 'Reset Password',
                onPressed: _isLoading ? null : _resetPassword,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 28),

              // === FOOTER ===
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    "Don’t have an account?",
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, AppRoutes.register),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        color: AppTheme.primaryRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              InkWell(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      "Back to login",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
