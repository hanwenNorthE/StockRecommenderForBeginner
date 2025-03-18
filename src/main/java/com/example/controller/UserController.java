package com.example.controller;

import com.example.model.User;
import com.example.model.UserPreference;
import com.example.service.UserService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    // 为简化示例，直接 new 对象，实际项目中建议使用依赖注入（@Autowired）
    private UserService userService = new UserService();  

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