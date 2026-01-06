package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth

                        // ================= PUBLIC =================
                        .requestMatchers(
                                "/api/login",
                                "/api/signup",
                                "/api/auth/**",
                                "/api/hello",
                                "/uploads/**",
                                "/api/produk/gambar/**")
                        .permitAll()

                        // ================= ADMIN ONLY =================
                        .requestMatchers("/api/users/**").hasAuthority("ADMIN")
                        .requestMatchers("/api/toko/add").hasAuthority("ADMIN")
                        .requestMatchers("/api/toko/delete/**").hasAuthority("ADMIN")
                        .requestMatchers("/api/toko/update/**").hasAuthority("ADMIN")
                        .requestMatchers("/api/toko").hasAuthority("ADMIN")       // <── FIX
                        .requestMatchers("/api/toko/").hasAuthority("ADMIN")// <── FIX
                        .requestMatchers("/api/laporan/**").hasAuthority("ADMIN")

                        // ================= ADMIN & KASIR =================
                        .requestMatchers("/api/toko/kasir/**").hasAnyAuthority("ADMIN", "KASIR")
                        .requestMatchers("/api/produk/**").hasAnyAuthority("ADMIN", "KASIR")
                        .requestMatchers("/api/transaksi/**").hasAnyAuthority("ADMIN", "KASIR")

                        // ================= DEFAULT =================
                        .anyRequest().authenticated());

        http.addFilterBefore(jwtFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public JwtAuthenticationFilter jwtFilter() {
        return new JwtAuthenticationFilter();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    GrantedAuthorityDefaults grantedAuthorityDefaults() {
        return new GrantedAuthorityDefaults("");
    }

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("*")
                        .allowedHeaders("*");
            }
        };
    }
}