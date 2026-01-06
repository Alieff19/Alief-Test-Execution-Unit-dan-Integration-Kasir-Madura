package com.example.demo.repository;

import com.example.demo.model.Toko;
import com.example.demo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TokoRepository extends JpaRepository<Toko, Long> {

    // ============================================
    // TOKO AKTIF MILIK KASIR (PALING PENTING ✅)
    // ============================================
    Optional<Toko> findByKasirAndDeletedFalse(User kasir);

    // ============================================
    // SEMUA TOKO YANG MASIH AKTIF
    // ============================================
    List<Toko> findByDeletedFalse();

    // ============================================
    // TOKO AKTIF BY ID
    // ============================================
    Optional<Toko> findByIdAndDeletedFalse(Long id);
    Optional<Toko> findByKasirId(Long kasirId);

}
