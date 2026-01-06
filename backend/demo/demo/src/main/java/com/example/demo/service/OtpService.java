package com.example.demo.service;

import com.example.demo.model.OtpVerification;
import com.example.demo.model.User;
import com.example.demo.repository.OtpVerificationRepository;
import com.example.demo.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class OtpService {

    private static final Logger log = LoggerFactory.getLogger(OtpService.class);

    private final OtpVerificationRepository otpRepo;
    private final UserRepository userRepo;

    // =======================
    // [TAMBAH]
    // untuk hash OTP
    // =======================
    private final PasswordEncoder passwordEncoder;

    // =======================
    // TOKEN TELEGRAM
    // (sebaiknya dari properties)
    // =======================
    private final String TELEGRAM_TOKEN = "7935351869:AAEMJZG0s2kAX9-Wdu9JTjP5xVnTG2zOEGw";
    private final String CHAT_ID = "8278108288";

    // =======================
    // [GANTI CONSTRUCTOR]
    // tambah PasswordEncoder
    // =======================
    public OtpService(OtpVerificationRepository otpRepo,
                      UserRepository userRepo,
                      PasswordEncoder passwordEncoder) {
        this.otpRepo = otpRepo;
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
    }

    // ===============================================================
    //              GENERATE + HASH + SAVE OTP
    // ===============================================================
    @Transactional
    public void generateAndSaveOtp(String phone) {

        // =======================
        // Generate OTP PLAIN
        // =======================
        String otp = String.format("%04d", new Random().nextInt(9000) + 1000);
        LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

        // =======================
        // [TAMBAH]
        // hapus OTP lama (1 OTP aktif)
        // =======================
        otpRepo.deleteByPhone(phone);

        // =======================
        // [TAMBAH]
        // HASH OTP sebelum simpan
        // =======================
        String otpHash = passwordEncoder.encode(otp);

        // =======================
        // [GANTI]
        // simpan HASH ke DB
        // =======================
        otpRepo.save(new OtpVerification(phone, otpHash, expiredAt));

        // =======================
        // OTP ASLI hanya dikirim
        // =======================
        sendOtpTelegram(phone, otp);

        log.info("OTP untuk {} adalah {}", phone, otp);
    }

    // ===============================================================
    //              KIRIM OTP VIA TELEGRAM
    // ===============================================================
    public void sendOtpTelegram(String phone, String otp) {
        try {
            String namaKasir = userRepo.findByPhone(phone)
                    .map(User::getUsername)
                    .orElse("Tidak diketahui");

            String message =
                    "🔐 *Kode OTP MaduraStore*\n\n" +
                            "• Kasir: *" + namaKasir + "*\n" +
                            "• Nomor: " + phone + "\n" +
                            "• OTP: *" + otp + "*\n\n" +
                            "Jangan berikan kode ini kepada siapa pun!";

            message = message.replace(" ", "%20")
                    .replace("\n", "%0A")
                    .replace("*", "%2A");

            String urlString =
                    "https://api.telegram.org/bot" +
                            TELEGRAM_TOKEN +
                            "/sendMessage?chat_id=" +
                            CHAT_ID +
                            "&text=" + message +
                            "&parse_mode=Markdown";

            URL url = new URL(urlString);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            log.info("Telegram response = {}", con.getResponseCode());

        } catch (Exception e) {
            log.error("Gagal kirim OTP Telegram", e);
        }
    }

    // ===============================================================
    //              VERIFIKASI OTP (SEKALI PAKAI)
    // ===============================================================
    @Transactional
    public boolean verifyOtp(String phone, String inputOtp) {

        Optional<OtpVerification> optionalOtp = otpRepo.findByPhone(phone);

        if (optionalOtp.isEmpty()) {
            return false;
        }

        OtpVerification otpData = optionalOtp.get();

        // =======================
        // [TAMBAH]
        // cocokkan HASH + cek expired
        // =======================
        boolean valid = passwordEncoder.matches(inputOtp, otpData.getOtpHash())
                && otpData.getExpiredAt().isAfter(LocalDateTime.now());

        if (valid) {
            // =======================
            // [TAMBAH]
            // OTP sekali pakai
            // =======================
            otpRepo.deleteByPhone(phone);
            return true;
        }

        return false;
    }
}
