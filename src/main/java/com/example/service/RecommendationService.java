package com.example.service;

import com.example.model.Stock;
import com.example.model.User;

import java.util.ArrayList;
import java.util.List;

public class RecommendationService {
    
    // 根据用户偏好推荐股票
    public List<Stock> getRecommendations(User user) {
        System.out.println("Getting recommendations for user: " + user.getEmail());
        // 此处可根据用户偏好以及历史数据推荐股票
        return new ArrayList<>();
    }
} 