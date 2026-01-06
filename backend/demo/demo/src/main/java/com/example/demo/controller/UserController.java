package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.repository.TokoRepository;
import com.example.demo.model.Toko;

import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokoRepository tokoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // ======================================================
    // GET ALL USERS (tanpa user deleted)
    // ======================================================
    @GetMapping
    public List<User> getAllUsers() {
        return userRepository.findAll()
                .stream()
                .filter(u -> !u.isDeleted())   // ← filter soft delete
                .toList();
    }

    // GET USER BY ID
    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {

        Optional<User> user = userRepository.findById(id);

        if (user.isEmpty() || user.get().isDeleted()) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(user.get());
    }

    // ======================================================
    // CREATE KASIR
    // ======================================================
    @PostMapping("/add")
    public User createUser(@RequestBody User user) {

        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            throw new RuntimeException("Username wajib diisi");
        }

        user.setRole("KASIR");
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setDeleted(false);

        return userRepository.save(user);
    }

    // CREATE ADMIN
    @PostMapping("/signup")
    public User signUp(@RequestBody User user) {

        if (user.getUsername() == null || user.getUsername().isEmpty()) {
            throw new RuntimeException("Username wajib diisi");
        }

        user.setRole("ADMIN");
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setDeleted(false);

        return userRepository.save(user);
    }

    // ======================================================
    // UPDATE USER
    // ======================================================
    @PutMapping("/update/{id}")
    public ResponseEntity<User> updateUser(@PathVariable Long id, @RequestBody User userDetails) {

        Optional<User> optionalUser = userRepository.findById(id);

        if (optionalUser.isEmpty() || optionalUser.get().isDeleted()) {
            return ResponseEntity.notFound().build();
        }

        User user = optionalUser.get();

        if (userDetails.getUsername() != null) user.setUsername(userDetails.getUsername());
        if (userDetails.getPassword() != null)
            user.setPassword(passwordEncoder.encode(userDetails.getPassword()));
        if (userDetails.getPhone() != null) user.setPhone(userDetails.getPhone());
        if (userDetails.getRole() != null) user.setRole(userDetails.getRole());

        return ResponseEntity.ok(userRepository.save(user));
    }

    // ======================================================
    // SOFT DELETE USER + SOFT DELETE TOKO
    // ======================================================
    @DeleteMapping("/delete/{id}")
    @Transactional
    public ResponseEntity<?> deleteUser(@PathVariable Long id) {

        Optional<User> userOpt = userRepository.findById(id);

        if (userOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        User user = userOpt.get();

        // Jika sudah soft deleted sebelumnya
        if (user.isDeleted()) {
            return ResponseEntity.ok("User sudah dihapus sebelumnya (soft delete).");
        }

        // ============================
        // Jika KASIR → soft delete toko
        // ============================
        if ("KASIR".equals(user.getRole())) {

            Toko toko = tokoRepository.findByKasirAndDeletedFalse(user)
                    .orElse(null);

            if (toko != null) {
                toko.setDeleted(true);
                toko.setDeletedAt(LocalDateTime.now());
                tokoRepository.save(toko);
            }
        }


        // ============================
        // Soft delete user
        // ============================
        user.setDeleted(true);
        user.setDeletedAt(LocalDateTime.now());
        userRepository.save(user);

        return ResponseEntity.ok("User berhasil di-soft delete");
    }
}
