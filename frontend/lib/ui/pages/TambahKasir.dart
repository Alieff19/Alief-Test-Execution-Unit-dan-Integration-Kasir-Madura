import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_theme.dart';


class TambahKasir extends StatefulWidget {
  final String? initialNama;
  final String? initialTelp;
  final String? initialPass;
  final Future<void> Function(String nama, String telp, String pass) onSave;

  const TambahKasir({
    super.key,
    required this.onSave,
    this.initialNama,
    this.initialTelp,
    this.initialPass,
  });

  @override
  State<TambahKasir> createState() => _TambahKasirState();
}

class _TambahKasirState extends State<TambahKasir> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaC;
  late TextEditingController telpC;
  late TextEditingController passC;

  bool _obscure = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.initialNama ?? "");
    telpC = TextEditingController(text: widget.initialTelp ?? "");
    passC = TextEditingController(text: widget.initialPass ?? "");
  }

  // VALIDATOR NAMA
  String? _vNama(String? v) {
    if (v == null || v.trim().isEmpty) return "Nama kasir tidak boleh kosong";
    return null;
  }

  // VALIDATOR NOMOR HP
  String? _vPhone(String? v) {
    if (v == null || v.trim().isEmpty) {
      return "Nomor telepon tidak boleh kosong";
    }
    final re = RegExp(r'^(?:\+62|0)[0-9]{9,13}$');
    if (!re.hasMatch(v.trim())) {
      return "Nomor tidak valid (contoh: 08xxxxxxxxxx)";
    }
    return null;
  }

  // VALIDATOR PASSWORD
  String? _vPass(String? v) {
    if (v == null || v.trim().isEmpty) return "Password tidak boleh kosong";
    if (v.trim().length < 8) return "Minimal 8 karakter";
    return null;
  }

  // DECORATION INPUT
  InputDecoration _dec(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.textSubtle),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),

      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: BoxDecoration(
          color: AppTheme.primaryCream,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              color: Color(0x15000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // HEADER
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryRed,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  widget.initialPass == null ? "Tambah Kasir" : "Edit Kasir",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryOrange,
                  ),
                ),

                const SizedBox(height: 28),

                // INPUT NAMA
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Input nama kasir",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.balckicon,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                TextFormField(
                  controller: namaC,
                  validator: _vNama,
                  decoration: _dec("Input nama kasir anda", Icons.person_outline_rounded),
                ),

                const SizedBox(height: 18),

                // INPUT TELEPON
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Input Nomor Telepon",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.balckicon,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                TextFormField(
                  controller: telpC,
                  keyboardType: TextInputType.phone,
                  validator: _vPhone,
                  decoration: _dec("Input Nomor Kasir", Icons.phone_in_talk_rounded),
                ),

                const SizedBox(height: 18),

                // INPUT PASSWORD (TAMPIL HANYA SAAT TAMBAH)
                if (widget.initialPass == null) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Input Password",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.balckicon,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  TextFormField(
                    controller: passC,
                    obscureText: _obscure,
                    validator: _vPass, // password wajib jika tambah
                    decoration: _dec("Input Password anda", Icons.lock_outline_rounded).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppTheme.textSubtle,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                ],

                // BUTTON SIMPAN
                GestureDetector(
                  onTap: _isSaving ? null : () async {
                    if (!(_formKey.currentState?.validate() ?? false)) return;

                    setState(() => _isSaving = true);

                    try {
                      // MODE EDIT → password tidak dikirim
                      if (widget.initialPass != null) {
                        await widget.onSave(
                          namaC.text.trim(),
                          telpC.text.trim(),
                          "", // password kosong karena tidak diedit
                        );
                      }
                      else {
                        await widget.onSave(
                          namaC.text.trim(),
                          telpC.text.trim(),
                          passC.text.trim(),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isSaving = false);
                      }
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: _isSaving ? null : AppTheme.primaryGradient,
                      color: _isSaving ? Colors.grey : null,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              "Simpan",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
}