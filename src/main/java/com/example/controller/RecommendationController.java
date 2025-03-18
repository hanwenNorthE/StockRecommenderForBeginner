package com.example.controller;

import com.example.model.Stock;
import com.example.model.User;
import com.example.service.RecommendationService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendations")
public class RecommendationController {
    
    private RecommendationService recommendationService = new RecommendationService();

    @GetMapping
    public List<Stock> getRecommendations(@RequestParam String email) {
        // 出于示例目的，直接构造一个User对象。实际应从已登录用户获取信息
        User user = new User();
        user.setEmail(email);
        return recommendationService.getRecommendations(user);
    }
} 