package com.example.demo.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

/**
 * PUBLIC_INTERFACE
 * Project domain entity (skeleton for further expansion).
 */
@Entity
@Table(name = "projects")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Project {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 180)
    private String name;

    @Column(length = 1000)
    private String description;

    private Instant startDate;
    private Instant endDate;

    @Column(nullable = false)
    private Instant createdAt;

    private Instant updatedAt;

    @PrePersist
    void onCreate() { createdAt = Instant.now(); updatedAt = createdAt; }

    @PreUpdate
    void onUpdate() { updatedAt = Instant.now(); }
}
