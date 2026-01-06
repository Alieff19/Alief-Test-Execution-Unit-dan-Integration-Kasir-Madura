package com.example.demo.controller;

import com.example.demo.model.Toko;
import com.example.demo.model.User;
import com.example.demo.repository.TokoRepository;
import com.example.demo.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@org.springframework.transaction.annotation.Transactional
public class TokoIntegrationTest {

        @Autowired
        private MockMvc mockMvc;

        @Autowired
        private TokoRepository tokoRepository;

        @Autowired
        private UserRepository userRepository;

        @Autowired
        private PasswordEncoder passwordEncoder;

        @BeforeEach
        void setUp() {
                tokoRepository.deleteAll();
                userRepository.deleteAll();

                // Seed Admin, Kasir 1, Kasir 2
                User admin = new User();
                admin.setUsername("admin_test");
                admin.setPassword(passwordEncoder.encode("password"));
                admin.setRole("ADMIN");
                admin.setDeleted(false);
                userRepository.save(admin);

                User kasir1 = new User();
                kasir1.setUsername("kasir1");
                kasir1.setPassword(passwordEncoder.encode("password"));
                kasir1.setRole("KASIR");
                kasir1.setDeleted(false);
                userRepository.save(kasir1);

                User kasir2 = new User();
                kasir2.setUsername("kasir2");
                kasir2.setPassword(passwordEncoder.encode("password"));
                kasir2.setRole("KASIR");
                kasir2.setDeleted(false);
                userRepository.save(kasir2);
        }

        // TC-19: Add Toko (Integration) -> 200 OK & DB Check
        @Test
        @WithMockUser(username = "admin_test", authorities = "ADMIN")
        void testAddToko_Success() throws Exception {
                User kasir = userRepository.findByUsername("kasir1").get();
                String jsonRequest = "{\"namaToko\": \"Toko A\", \"alamat\": \"Jl A\", \"kasirId\": " + kasir.getId()
                                + "}";

                mockMvc.perform(post("/api/toko/add")
                                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                                .content(jsonRequest)
                                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                                                .csrf()))
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.namaToko", is("Toko A")));

                assert tokoRepository.findAll().size() == 1;
        }

        // TC-20: Update Toko (Integration) -> 200 OK & DB Check
        // TC-20: Update Toko (Integration) -> 200 OK & DB Check
        @Test
        @WithMockUser(username = "admin_test", authorities = "ADMIN")
        void testUpdateToko_Success() throws Exception {
                // Create specific user
                User kasir = new User();
                kasir.setUsername("kasir_update");
                kasir.setPassword("pass");
                kasir.setRole("KASIR");
                kasir.setDeleted(false);
                userRepository.save(kasir);

                Toko toko = new Toko();
                toko.setNamaToko("Toko Lama");
                toko.setAlamat("Lama");
                toko.setKasir(kasir);
                tokoRepository.save(toko);

                String jsonUpdate = "{\"namaToko\": \"Toko Baru\"}"; // Partial update

                mockMvc.perform(put("/api/toko/" + toko.getId())
                                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                                .content(jsonUpdate)
                                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                                                .csrf()))
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.namaToko", is("Toko Baru")));

                Toko updated = tokoRepository.findById(toko.getId()).get();
                assert updated.getNamaToko().equals("Toko Baru");
        }

        // TC-21: Delete Toko (Integration) -> 200 OK & Soft Deleted in DB
        // TC-21: Delete Toko (Integration) -> 200 OK & Soft Deleted in DB
        @Test
        @WithMockUser(username = "admin_test", authorities = "ADMIN")
        void testDeleteToko_Success() throws Exception {
                // Create specific user
                User kasir = new User();
                kasir.setUsername("kasir_delete");
                kasir.setPassword("pass");
                kasir.setRole("KASIR");
                kasir.setDeleted(false);
                userRepository.save(kasir);

                Toko toko = new Toko();
                toko.setNamaToko("Toko Delete");
                toko.setAlamat("Delete");
                toko.setKasir(kasir);
                tokoRepository.save(toko);

                mockMvc.perform(delete("/api/toko/delete/" + toko.getId())
                                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                                                .csrf()))
                                .andExpect(status().isOk());

                Toko deleted = tokoRepository.findById(toko.getId()).get();
                assert deleted.isDeleted(); // Soft delete check
        }

        // TC-22: Delete Toko Invalid -> 404 Not Found
        @Test
        @WithMockUser(username = "admin_test", authorities = "ADMIN")
        void testDeleteToko_NotFound() throws Exception {
                mockMvc.perform(delete("/api/toko/delete/9999")
                                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                                                .csrf()))
                                .andExpect(status().isNotFound());
        }

        // TC-23: Get Toko By Kasir (Integration) -> 200 OK
        // TC-23: Get Toko By Kasir (Integration) -> 200 OK
        @Test
        @WithMockUser(username = "kasir_get", authorities = "KASIR")
        void testGetTokoByKasir_Success() throws Exception {
                // Create specific user
                User kasir = new User();
                kasir.setUsername("kasir_get");
                kasir.setPassword("pass");
                kasir.setRole("KASIR");
                kasir.setDeleted(false);
                userRepository.save(kasir);

                Toko toko = new Toko();
                toko.setNamaToko("Toko Milik Kasir 1");
                toko.setKasir(kasir);
                tokoRepository.save(toko);

                mockMvc.perform(get("/api/toko/kasir/" + kasir.getId()))
                                .andExpect(status().isOk())
                                .andExpect(jsonPath("$.namaToko", is("Toko Milik Kasir 1")));
        }
}
