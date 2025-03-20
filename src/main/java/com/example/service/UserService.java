package com.example.service;

import org.springframework.stereotype.Service;

import com.example.model.User;
import com.example.model.UserPreference;

@Service
public class UserService {
    
    // 用户注册
    public void register(User user) {
        // 此处添加注册逻辑，比如保存到数据库
        System.out.println("Registering user: " + user.getEmail());
    }

    // 用户登录
    public User login(String email, String password) {
        // 这里可添加登录逻辑，如验证密码等
        System.out.println("Logging in user: " + email);
        return new User();
    }

    // 更新用户偏好
    public void updatePreference(Long userId, UserPreference preference) {
        // 查找用户并更新偏好
        System.out.println("Updating preference for user id: " + userId);
    }
} 