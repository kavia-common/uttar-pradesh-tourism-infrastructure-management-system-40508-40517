package com.example.demo.controller;

import com.example.demo.domain.Role;
import com.example.demo.domain.User;
import com.example.demo.dto.AuthDtos;
import com.example.demo.repository.UserRepository;
import com.example.demo.security.jwt.JwtService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * PUBLIC_INTERFACE
 * Auth endpoints: register and login.
 */
@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "User registration and login endpoints with JWT issuance.")
public class AuthController {

    private final UserRepository userRepository;
    private final PasswordEncoder encoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    /**
     * Register a new user with roles; ADMIN only in production should create admins.
     */
    @PostMapping("/register")
    @Operation(summary = "Register user", description = "Registers a new user and returns a JWT token.")
    public ResponseEntity<AuthDtos.TokenResponse> register(@Valid @RequestBody AuthDtos.RegisterRequest req) {
        if (userRepository.existsByUsername(req.username())) {
            return ResponseEntity.badRequest().build();
        }
        if (userRepository.existsByEmail(req.email())) {
            return ResponseEntity.badRequest().build();
        }
        Set<Role> roles = Optional.ofNullable(req.roles()).filter(r -> !r.isEmpty()).orElseGet(() -> Set.of(Role.VIEWER));
        var user = User.builder()
                .username(req.username())
                .email(req.email())
                .passwordHash(encoder.encode(req.password()))
                .roles(roles)
                .build();
        userRepository.save(user);

        var token = jwtService.generateToken(user.getUsername(), Map.of(
                "roles", user.getRoles().stream().map(Enum::name).toList()
        ));
        return ResponseEntity.ok(new AuthDtos.TokenResponse(token, user.getUsername(), user.getRoles()));
    }

    /**
     * Login with username/password. Returns JWT token on success.
     */
    @PostMapping("/login")
    @Operation(summary = "Login", description = "Authenticates user credentials and returns a JWT token.")
    public ResponseEntity<AuthDtos.TokenResponse> login(@Valid @RequestBody AuthDtos.LoginRequest req) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.username(), req.password())
        );
        var principal = (org.springframework.security.core.userdetails.User) auth.getPrincipal();
        var roles = principal.getAuthorities().stream().map(a -> a.getAuthority().replace("ROLE_","")).toList();
        String token = jwtService.generateToken(principal.getUsername(), Map.of("roles", roles));
        return ResponseEntity.ok(new AuthDtos.TokenResponse(token, principal.getUsername(), new HashSet<>(roles.stream().map(Role::valueOf).toList())));
    }
}
