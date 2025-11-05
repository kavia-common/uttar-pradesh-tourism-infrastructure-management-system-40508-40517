package com.example.demo.repository;

import com.example.demo.domain.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

/**
 * PUBLIC_INTERFACE
 * Repository for Projects.
 */
public interface ProjectRepository extends JpaRepository<Project, Long>, PagingAndSortingRepository<Project, Long> {
}
