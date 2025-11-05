package com.example.demo.controller;

import com.example.demo.domain.Project;
import com.example.demo.repository.ProjectRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

/**
 * PUBLIC_INTERFACE
 * CRUD endpoints for Projects (basic subset).
 */
@RestController
@RequestMapping("/api/projects")
@Tag(name = "Projects", description = "Projects CRUD with pagination.")
public class ProjectsController {

    private final ProjectRepository projects;

    public ProjectsController(ProjectRepository projects) {
        this.projects = projects;
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER','ENGINEER','VIEWER')")
    @Operation(summary = "List projects", description = "Paginated list of projects.")
    public Page<Project> list(@RequestParam(defaultValue = "0") int page,
                              @RequestParam(defaultValue = "20") int size) {
        return projects.findAll(PageRequest.of(page, size, Sort.by("createdAt").descending()));
    }

    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER')")
    @Operation(summary = "Create project", description = "Creates a new project.")
    public ResponseEntity<Project> create(@Valid @RequestBody Project p) {
        return ResponseEntity.ok(projects.save(p));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN','MANAGER','ENGINEER','VIEWER')")
    @Operation(summary = "Get project", description = "Fetch a project by id.")
    public ResponseEntity<Project> get(@PathVariable Long id) {
        return projects.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }
}
