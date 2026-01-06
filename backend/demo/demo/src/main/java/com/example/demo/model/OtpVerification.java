package com.example.demo.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Entity
@Table(name = "otp_verification")
public class OtpVerification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Setter
    private String phone;

    // =======================
    // [GANTI]
    // sebelumnya: private String otp;
    // sekarang disimpan HASH
    // =======================
    @Setter
    @Column(name = "otp_hash")
    private String otpHash;

    @Setter
    private LocalDateTime expiredAt;

    public OtpVerification() {}

    // =======================
    // [GANTI CONSTRUCTOR]
    // otp -> otpHash
    // =======================
    public OtpVerification(String phone, String otpHash, LocalDateTime expiredAt) {
        this.phone = phone;
        this.otpHash = otpHash;
        this.expiredAt = expiredAt;
    }
}
