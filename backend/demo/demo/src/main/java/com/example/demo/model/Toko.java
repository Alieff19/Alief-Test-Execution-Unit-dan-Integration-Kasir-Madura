package com.example.demo.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
public class Toko {

    @Getter @Setter
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Getter @Setter
    private String namaToko;

    @Getter @Setter
    private String alamat;

    @Getter @Setter
    @OneToOne
    @JoinColumn(name = "kasir_id")
    @JsonManagedReference
    private User kasir;

    // ==========================
    // SOFT DELETE
    // ==========================
    @Getter @Setter
    private boolean deleted = false;

    @Getter @Setter
    private LocalDateTime deletedAt;
}
