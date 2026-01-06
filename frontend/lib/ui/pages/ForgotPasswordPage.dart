import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';
import '../../core/app_routes.dart';
import '../widgets/button.dart';
import '../../data/models/forgot_password_request.dart';
import '../../data/services/forgot_password_service.dart';



class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  // ---- dekorasi input (sama seperti LoginPage) ----
  OutlineInputBorder _rounded(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: c, width: 1),
  );

  InputDecoration _dec({
    required String hint,
    required IconData icon,
    required Color iconColor,
    required Color fieldFill,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      fillColor: fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: _rounded(Colors.transparent),
      enabledBorder: _rounded(Colors.transparent),
      focusedBorder: _rounded(Colors.transparent),
      errorBorder: _rounded(AppTheme.error),
      focusedErrorBorder: _rounded(AppTheme.error),
    );
  }

  String? _vPhone(String? v) {
    final x = (v ?? '').trim();
    if (x.isEmpty) return 'Nomor handphone tidak boleh kosong';
    final re = RegExp(r'^(?:\+62|0)[0-9]{9,13}$');
    if (!re.hasMatch(x)) return 'Nomor tidak valid (contoh: 08xxxxxxxxxx / +628xxxxxxxxx)';
    return null;
  }

  void _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final req = ForgotPasswordRequest(phone: _phoneCtrl.text.trim());
    final res = await ForgotPasswordService().sendOtp(req);

    if (!mounted) return;

    if (res.success) {
      Navigator.pushNamed(
        context,
        AppRoutes.forgotOTP,
        arguments: _phoneCtrl.text.trim(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res.message)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    final topH = size.height * 0.42;

    return Scaffold(
      backgroundColor: AppTheme.primaryRed,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // ===== HEADER MERAH (gradient + rounded) =====
            Container(
              height: topH,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryRed, AppTheme.primaryRed.withOpacity(0.95)],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),

            // Panel pink + logo + title
            Positioned(
              top: 64,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 314,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    color: AppTheme.primaryCream.withOpacity(.45),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        const Positioned(
                          top: 0,
                          child: SizedBox(
                            width: 146, height: 146,
                            child: Image(
                              image: AssetImage('assets/images/logo3.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 146,
                          child: Text(
                            'Madura Store',
                            style: GoogleFonts.poppins(
                              color: AppTheme.primaryRed,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ===== PANEL BAWAH (FORM) =====
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                // 💡 tambahkan tinggi minimal biar area krem terlihat lebih tinggi
                constraints: const BoxConstraints(
                  minHeight: 531, // sesuai desain Figma kamu
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryCream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    24, 32, 24, 36 + MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          Center(
                            child: Text(
                              'Forgot Password',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),

                          Text(
                            'Nomer hanphone', // mengikuti teks di Figma kamu
                            style: text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(),
                            decoration: _dec(
                              hint: 'Enter your number',
                              icon: Icons.phone_outlined,
                              iconColor: AppTheme.textPrimary,
                              fieldFill: cs.surface,
                            ),
                            validator: _vPhone,
                          ),

                          const SizedBox(height:50),

                          Button(
                            label: 'Send',
                            onPressed: _submit,
                          ),

                          const SizedBox(height: 20),

                          // Link Sign Up
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                Text("Don’t have an account?",
                                  style: text.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                ),
                                InkWell(
                                  onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                                    child: Text("Sign Up",
                                      style: text.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.primaryRed,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
