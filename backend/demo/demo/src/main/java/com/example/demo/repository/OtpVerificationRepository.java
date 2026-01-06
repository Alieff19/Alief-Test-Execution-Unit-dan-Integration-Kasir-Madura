package com.example.demo.repository;

import com.example.demo.model.OtpVerification;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface OtpVerificationRepository extends JpaRepository<OtpVerification, Long> {
    Optional<OtpVerification> findByPhone(String phone);
    void deleteByPhone(String phone);
}
