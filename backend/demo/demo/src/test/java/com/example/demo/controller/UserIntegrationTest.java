package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class UserIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @BeforeEach
    void setUp() {
        // Bersihkan database agar test tidak terpengaruh data sebelumnya
        userRepository.deleteAll();

        // Seed data: 1 Admin, 1 Kasir
        User admin = new User();
        admin.setUsername("admin_test");
        admin.setPassword(passwordEncoder.encode("password"));
        admin.setRole("ADMIN");
        admin.setDeleted(false);
        userRepository.save(admin);

        User kasir = new User();
        kasir.setUsername("kasir_test");
        kasir.setPassword(passwordEncoder.encode("password"));
        kasir.setRole("KASIR");
        kasir.setDeleted(false);
        userRepository.save(kasir);
    }

    // TC-14 (Integration): Admin Get All Users -> 200 OK + Real Data from DB
    @Test
    @WithMockUser(username = "admin_test", authorities = "ADMIN")
    void testGetAllUsers_Admin_Success() throws Exception {
        mockMvc.perform(get("/api/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2))) // Harus ada 2 user yang di-insert di setUp()
                .andExpect(jsonPath("$[0].username", is("admin_test")))
                .andExpect(jsonPath("$[1].username", is("kasir_test")));
    }

    // TC-15: Kasir Get All Users -> 403 Forbidden
    @Test
    @WithMockUser(username = "kasir_test", authorities = "KASIR")
    void testAccessUser_Kasir_Forbidden() throws Exception {
        mockMvc.perform(get("/api/users"))
                .andExpect(status().isForbidden());
    }

    // TC-16: Create User -> 200 OK & Stored in DB
    @Test
    @WithMockUser(username = "admin_test", authorities = "ADMIN")
    void testCreateUser_Success() throws Exception {
        String newUserJson = "{\"username\": \"new_kasir\", \"password\": \"pass123\", \"role\": \"KASIR\"}";

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post("/api/users/add")
                .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                .content(newUserJson)
                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                        .csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is("new_kasir")));

        // Verify DB side
        assert userRepository.findByUsername("new_kasir").isPresent();
    }

    // TC-17: Delete User -> 200 OK & Soft Deleted in DB
    @Test
    @WithMockUser(username = "admin_test", authorities = "ADMIN")
    void testDeleteUser_Success() throws Exception {
        // Cari ID kasir yang di-seed di setUp()
        User kasir = userRepository.findByUsername("kasir_test").get();

        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders
                .delete("/api/users/delete/" + kasir.getId())
                .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                        .csrf()))
                .andExpect(status().isOk());

        // Verify DB side (Soft Delete check)
        User deletedUser = userRepository.findById(kasir.getId()).get();
        assert deletedUser.isDeleted();
    }

    // TC-18: Delete User Invalid -> 404 Not Found
    @Test
    @WithMockUser(username = "admin_test", authorities = "ADMIN")
    void testDeleteUser_NotFound() throws Exception {
        mockMvc.perform(
                org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete("/api/users/delete/9999")
                        .with(org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors
                                .csrf()))
                .andExpect(status().isNotFound());
    }
}
