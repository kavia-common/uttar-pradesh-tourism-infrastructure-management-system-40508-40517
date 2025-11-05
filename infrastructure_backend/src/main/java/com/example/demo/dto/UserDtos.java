package com.example.demo.dto;

import com.example.demo.domain.Role;

import java.time.Instant;
import java.util.Set;

/**
 * PUBLIC_INTERFACE
 * DTOs for user resources.
 */
public class UserDtos {
    public record UserResponse(Long id, String username, String email, Set<Role> roles, Instant createdAt, Instant updatedAt) {}
}
