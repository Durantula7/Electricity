package com.electricity.controller;

import com.electricity.common.Result;
import com.electricity.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");
        return Result.ok(authService.login(username, password));
    }

    @GetMapping("/info")
    public Result<Map<String, String>> info() {
        return Result.ok(Map.of("status", "ok"));
    }
}
