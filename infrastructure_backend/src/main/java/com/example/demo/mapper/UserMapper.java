package com.example.demo.mapper;

import com.example.demo.domain.User;
import com.example.demo.dto.UserDtos;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

/**
 * PUBLIC_INTERFACE
 * Maps between User entity and DTO.
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface UserMapper {

    @Mapping(target = "passwordHash", ignore = true)
    User toEntity(UserDtos.UserResponse dto);

    UserDtos.UserResponse toDto(User user);
}
