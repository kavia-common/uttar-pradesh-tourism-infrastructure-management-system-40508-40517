package com.example.demo.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * PUBLIC_INTERFACE
 * Provides documentation endpoint for any future WebSocket usage.
 */
@RestController
@Tag(name = "Realtime")
public class WebSocketDocsController {

    @GetMapping("/api/realtime/docs")
    @Operation(summary = "WebSocket Usage", description = "This project currently does not use websockets. If added, connect via ws(s)://<host>/ws and authenticate with Bearer token.")
    public String docs() {
        return "No websocket endpoints currently. Future usage: connect to /ws with Bearer token.";
    }
}
