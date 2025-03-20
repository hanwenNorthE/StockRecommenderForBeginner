package com.example.controller;

import com.example.model.User;
import com.example.model.UserPreference;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class UserController {
    
    private final UserService userService;
    
    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public String register(@RequestBody User user) {
        userService.register(user);
        return "User registered successfully!";
    }

    @PostMapping("/login")
    public User login(@RequestParam String email, @RequestParam String password) {
        return userService.login(email, password);
    }

    @PutMapping("/{userId}/preference")
    public String updatePreference(@PathVariable Long userId, @RequestBody UserPreference preference) {
        userService.updatePreference(userId, preference);
        return "User preference updated successfully!";
    }
} 