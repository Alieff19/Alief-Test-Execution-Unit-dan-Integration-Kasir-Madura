package com.example.demo.controller;

import com.example.demo.dto.SignupRequest;
import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import lombok.Getter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class SignupController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupRequest signupRequest) {

        // Validasi input
        if (signupRequest.getUsername() == null || signupRequest.getPassword() == null || signupRequest.getPhone() == null
                || signupRequest.getUsername().isEmpty() || signupRequest.getPassword().isEmpty() || signupRequest.getPhone().isEmpty()) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Username, password, dan nomor handphone wajib diisi"));
        }

        // Check double username
        if (userRepository.existsByUsername(signupRequest.getUsername())) {
            return ResponseEntity.badRequest().body(new ErrorResponse("Username sudah digunakan"));
        }

        // Simpan user baru
        User newUser = new User();
        newUser.setUsername(signupRequest.getUsername());
        newUser.setPassword(passwordEncoder.encode(signupRequest.getPassword()));
        newUser.setPhone(signupRequest.getPhone());
        newUser.setRole("ADMIN"); // signup otomatis ADMIN

        userRepository.save(newUser);

        return ResponseEntity.ok(new SignupResponse(
                "Signup berhasil",
                newUser.getUsername(),
                newUser.getRole()
        ));
    }

    // Response success
    @Getter
    public static class SignupResponse {
        private final String message;
        private final String username;
        private final String role;

        public SignupResponse(String message, String username, String role) {
            this.message = message;
            this.username = username;
            this.role = role;
        }
    }

    // Response error
    @Getter
    public static class ErrorResponse {
        private final String message;

        public ErrorResponse(String message) {
            this.message = message;
        }
    }
}
