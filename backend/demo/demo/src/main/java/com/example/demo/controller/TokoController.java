package com.example.demo.controller;

import com.example.demo.dto.TokoRequest;
import com.example.demo.model.Toko;
import com.example.demo.model.User;
import com.example.demo.repository.TokoRepository;
import com.example.demo.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;
import java.util.List;

@RestController
@RequestMapping("/api/toko")
@RequiredArgsConstructor
public class TokoController {

    private final TokoRepository tokoRepository;
    private final UserRepository userRepository;

    // ================= GET ALL TOKO =================
    @GetMapping
    public ResponseEntity<?> getAllToko() {
        List<Toko> all = tokoRepository.findAll();
        return ResponseEntity.ok(all);
    }

    // ================= ADD TOKO =================
    @PostMapping("/add")
    public ResponseEntity<?> addToko(@RequestBody TokoRequest request) {

        Optional<User> kasirOpt = userRepository.findById(request.getKasirId());
        if (kasirOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("Kasir tidak ditemukan");
        }

        Toko toko = new Toko();
        toko.setNamaToko(request.getNamaToko());
        toko.setAlamat(request.getAlamat());
        toko.setKasir(kasirOpt.get());

        tokoRepository.save(toko);

        return ResponseEntity.ok(toko);
    }

    // ================= GET TOKO BY KASIR =================
    @GetMapping("/kasir/{kasirId}")
    public ResponseEntity<?> getTokoByKasir(@PathVariable Long kasirId) {

        Optional<User> kasirOpt = userRepository.findById(kasirId);
        if (kasirOpt.isEmpty()) {
            return ResponseEntity.ok(null);
        }

        Toko toko = tokoRepository.findByKasirAndDeletedFalse(kasirOpt.get())
                .orElse(null);

        return ResponseEntity.ok(toko);
    }

    // ================= UPDATE TOKO =================
    @PutMapping("/{id}")
    public ResponseEntity<?> updateToko(
            @PathVariable Long id,
            @RequestBody TokoRequest request) {

        Optional<Toko> tokoOpt = tokoRepository.findById(id);
        if (tokoOpt.isEmpty()) {
            return ResponseEntity.badRequest().body("Toko tidak ditemukan");
        }

        Toko toko = tokoOpt.get();

        if (request.getNamaToko() != null)
            toko.setNamaToko(request.getNamaToko());
        if (request.getAlamat() != null)
            toko.setAlamat(request.getAlamat());

        if (request.getKasirId() != null) {
            Optional<User> kasirOpt = userRepository.findById(request.getKasirId());
            if (kasirOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Kasir tidak ditemukan");
            }
            toko.setKasir(kasirOpt.get());
        }

        tokoRepository.save(toko);

        return ResponseEntity.ok(toko);
    }

    // ================= DELETE TOKO =================
    @DeleteMapping("/delete/{id}")
    public ResponseEntity<?> deleteToko(@PathVariable Long id) {
        Optional<Toko> tokoOpt = tokoRepository.findById(id);
        if (tokoOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Toko toko = tokoOpt.get();
        toko.setDeleted(true);
        tokoRepository.save(toko);

        return ResponseEntity.ok("Toko berhasil dihapus");
    }

}
