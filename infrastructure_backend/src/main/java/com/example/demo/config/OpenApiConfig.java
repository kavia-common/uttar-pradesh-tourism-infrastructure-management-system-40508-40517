package com.example.demo.config;

import io.swagger.v3.oas.models.ExternalDocumentation;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.*;
import io.swagger.v3.oas.models.tags.Tag;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * PUBLIC_INTERFACE
 * Configures OpenAPI/Swagger metadata and tags.
 */
@Configuration
public class OpenApiConfig {

    // PUBLIC_INTERFACE
    @Bean
    public OpenAPI api() {
        return new OpenAPI()
                .info(new Info()
                        .title("UPSTDC Infrastructure API")
                        .version("1.0.0")
                        .description("REST API for Uttar Pradesh Tourism infrastructure monitoring")
                        .contact(new Contact().name("UPSTDC").email("support@upstdc.example")))
                .addTagsItem(new Tag().name("Authentication").description("Auth endpoints"))
                .addTagsItem(new Tag().name("Users").description("User management"))
                .addTagsItem(new Tag().name("Projects").description("Projects CRUD with pagination"))
                .externalDocs(new ExternalDocumentation()
                        .description("Swagger UI")
                        .url("/swagger"));
    }
}
