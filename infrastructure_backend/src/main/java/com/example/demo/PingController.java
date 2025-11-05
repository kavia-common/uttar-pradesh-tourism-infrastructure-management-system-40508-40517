package com.example.demo;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PUBLIC_INTERFACE
 * Simple health check endpoint separate from actuator for quick verification.
 */
@RestController
@Tag(name = "Public")
public class PingController {
  @GetMapping("/ping")
  @Operation(summary = "Ping", description = "Returns 'pong' for quick connectivity checks.")
  public String ping() { return "pong"; }
}
