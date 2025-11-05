package com.example.demo.controller;

import com.example.demo.dto.UserDtos;
import com.example.demo.mapper.UserMapper;
import com.example.demo.repository.UserRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * PUBLIC_INTERFACE
 * User management endpoints.
 */
@RestController
@RequestMapping("/api/users")
@Tag(name = "Users", description = "User management operations with pagination and filtering.")
public class UsersController {

    private final UserRepository users;
    private final UserMapper mapper;

    public UsersController(UserRepository users, UserMapper mapper) {
        this.users = users;
        this.mapper = mapper;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    @Operation(summary = "List users", description = "Returns paginated list of users filtered by username contains.")
    public Page<UserDtos.UserResponse> list(
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(defaultValue = "createdAt,desc") String sort) {

        Sort s = Sort.by(sort.split(",")[0]);
        if (sort.toLowerCase().endsWith(",desc")) s = s.descending();
        Pageable pageable = PageRequest.of(page, size, s);
        return users.findByUsernameContainingIgnoreCase(q, pageable).map(mapper::toDto);
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER','ENGINEER')")
    @Operation(summary = "Get user", description = "Returns a user by id.")
    public ResponseEntity<UserDtos.UserResponse> get(@PathVariable Long id) {
        return users.findById(id).map(mapper::toDto).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
