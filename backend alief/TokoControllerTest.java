package com.example.demo.controller;

import com.example.demo.config.JwtAuthenticationFilter;
import com.example.demo.config.SecurityConfig;
import com.example.demo.dto.TokoRequest;
import com.example.demo.model.Toko;
import com.example.demo.model.User;
import com.example.demo.repository.TokoRepository;
import com.example.demo.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.http.MediaType;

import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.is;

@WebMvcTest(TokoController.class)
@Import({ SecurityConfig.class, JwtAuthenticationFilter.class })
public class TokoControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private TokoRepository tokoRepository;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    // TC-19: Admin Add Toko -> 200 OK
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testAddToko_Success() throws Exception {
        User kasir = new User();
        kasir.setId(1L);
        kasir.setUsername("kasir1");

        Toko savedToko = new Toko();
        savedToko.setId(10L);
        savedToko.setNamaToko("Toko Baru");
        savedToko.setKasir(kasir);

        when(userRepository.findById(1L)).thenReturn(Optional.of(kasir));
        when(tokoRepository.save(any(Toko.class))).thenReturn(savedToko);

        mockMvc.perform(post("/api/toko/add")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"namaToko\": \"Toko Baru\", \"alamat\": \"Jl. Merdeka\", \"kasirId\": 1}")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.namaToko", is("Toko Baru")));
    }

    // TC-20: Admin Update Toko -> 200 OK
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testUpdateToko_Success() throws Exception {
        Toko existingToko = new Toko();
        existingToko.setId(10L);
        existingToko.setNamaToko("Toko Lama");

        when(tokoRepository.findById(10L)).thenReturn(Optional.of(existingToko));
        when(tokoRepository.save(any(Toko.class))).thenReturn(existingToko);

        mockMvc.perform(put("/api/toko/10")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"namaToko\": \"Toko Update\"}")
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.namaToko", is("Toko Update")));
    }

    // TC-23: KASIR Get Toko Owner -> 200 OK
    @Test
    @WithMockUser(username = "kasir", authorities = "KASIR")
    void testGetTokoByKasir_Success() throws Exception {
        User kasir = new User();
        kasir.setId(2L);

        Toko toko = new Toko();
        toko.setId(20L);
        toko.setNamaToko("Toko Kasir");
        toko.setKasir(kasir);

        when(userRepository.findById(2L)).thenReturn(Optional.of(kasir));
        when(tokoRepository.findByKasirAndDeletedFalse(kasir)).thenReturn(Optional.of(toko));

        mockMvc.perform(get("/api/toko/kasir/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.namaToko", is("Toko Kasir")));
    }

    // TC-21: Admin Delete Toko (Valid ID) -> 200 OK
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testDeleteToko_Success() throws Exception {
        Toko toko = new Toko();
        toko.setId(30L);
        toko.setDeleted(false);

        when(tokoRepository.findById(30L)).thenReturn(Optional.of(toko));
        when(tokoRepository.save(any(Toko.class))).thenReturn(toko);

        mockMvc.perform(delete("/api/toko/delete/30").with(csrf()))
                .andExpect(status().isOk());
    }

    // TC-22: Admin Delete Toko (Invalid ID) -> 404 Not Found
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testDeleteToko_NotFound() throws Exception {
        when(tokoRepository.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(delete("/api/toko/delete/99").with(csrf()))
                .andExpect(status().isNotFound());
    }
}
