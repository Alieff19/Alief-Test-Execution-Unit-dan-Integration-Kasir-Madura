package com.example.demo.controller;

import com.example.demo.config.JwtAuthenticationFilter;
import com.example.demo.config.SecurityConfig;
import com.example.demo.model.User;
import com.example.demo.repository.TokoRepository;
import com.example.demo.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.is;
import static org.mockito.ArgumentMatchers.any;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import org.springframework.http.MediaType;

@WebMvcTest(UserController.class)
@Import({ SecurityConfig.class, JwtAuthenticationFilter.class }) // Load Security to test 403
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private TokoRepository tokoRepository;

    @MockBean
    private PasswordEncoder passwordEncoder;

    // TC-14: Admin Get All Users -> 200 OK + List
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testGetAllUsers_Admin_Success() throws Exception {
        // Arrange
        User user1 = new User();
        user1.setId(1L);
        user1.setUsername("admin");
        user1.setRole("ADMIN");

        User user2 = new User();
        user2.setId(2L);
        user2.setUsername("kasir");
        user2.setRole("KASIR");

        when(userRepository.findAll()).thenReturn(Arrays.asList(user1, user2));

        // Act & Assert
        mockMvc.perform(get("/api/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)))
                .andExpect(jsonPath("$[0].username", is("admin")));
    }

    // TC-15: Kasir Get All Users -> 403 Forbidden
    @Test
    @WithMockUser(username = "kasir", authorities = "KASIR")
    void testAccessUser_Kasir_Forbidden() throws Exception {
        // Kasir mencoba akses endpoint yg khusus ADMIN
        mockMvc.perform(get("/api/users"))
                .andExpect(status().isForbidden());
    }

    // TC-16: User Create User (Kasir) -> 200 OK
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testCreateUser_Success() throws Exception {
        // Arrange
        User newUser = new User();
        newUser.setUsername("kasir_baru");
        newUser.setPassword("password123");
        newUser.setRole("KASIR");

        when(userRepository.save(any(User.class))).thenReturn(newUser);
        when(passwordEncoder.encode(any(String.class))).thenReturn("encodedPass");

        // Act & Assert
        mockMvc.perform(post("/api/users/add")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\": \"kasir_baru\", \"password\": \"password123\"}")
                .with(csrf())) // Butuh CSRF token kalau pakai WebMvcTest
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username", is("kasir_baru")));
    }

    // TC-17: Delete User (Valid ID) -> 200 OK
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testDeleteUser_Success() throws Exception {
        // Arrange
        User userToDelete = new User();
        userToDelete.setId(10L);
        userToDelete.setUsername("user_deleted");
        userToDelete.setDeleted(false);

        when(userRepository.findById(10L)).thenReturn(java.util.Optional.of(userToDelete));
        when(userRepository.save(any(User.class))).thenReturn(userToDelete);

        // Act & Assert
        mockMvc.perform(
                org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete("/api/users/delete/10")
                        .with(csrf()))
                .andExpect(status().isOk());
    }

    // TC-18: Delete User (Invalid ID) -> 404 Not Found
    @Test
    @WithMockUser(username = "admin", authorities = "ADMIN")
    void testDeleteUser_NotFound() throws Exception {
        // Arrange
        when(userRepository.findById(999L)).thenReturn(java.util.Optional.empty());

        // Act & Assert
        mockMvc.perform(
                org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete("/api/users/delete/999")
                        .with(csrf()))
                .andExpect(status().isNotFound());
    }
}
