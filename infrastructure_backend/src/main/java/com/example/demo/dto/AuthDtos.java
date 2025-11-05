package com.example.demo.dto;

import com.example.demo.domain.Role;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.util.Set;

/**
 * PUBLIC_INTERFACE
 * DTOs for auth endpoints.
 */
public class AuthDtos {

    public record LoginRequest(
            @NotBlank String username,
            @NotBlank String password) {}

    public record RegisterRequest(
            @NotBlank String username,
            @NotBlank String password,
            @Email @NotBlank String email,
            Set<Role> roles) {}

    public record TokenResponse(String token, String username, Set<Role> roles) {}
}
