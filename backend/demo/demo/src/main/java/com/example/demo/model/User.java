package com.example.demo.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
public class User {

    @Setter @Getter
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Setter @Getter
    @Column(unique = true, nullable = false)
    private String username;

    @Setter @Getter
    @Column(nullable = false)
    private String password;

    @Setter @Getter
    private String phone;

    @Setter @Getter
    private String role;

    // ==========================
    // RELASI KE TOKO
    // ==========================
    @OneToOne(mappedBy = "kasir", fetch = FetchType.EAGER) // EAGER supaya otomatis ter-fetch
    @JsonBackReference
    @Getter @Setter
    private Toko toko;

    // ==========================
    // SOFT DELETE
    // ==========================
    @Setter @Getter
    private boolean deleted = false;

    @Setter @Getter
    private LocalDateTime deletedAt;
}
