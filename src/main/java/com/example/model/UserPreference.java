package com.example.model;

import java.util.ArrayList;
import java.util.List;

/**
 * user preference class
 * relations:
 *  - one to many: Preference -> User
 */

public class UserPreference {
    private Long id;
    private Long userId;
    private RiskLevel riskLevel;
    private List<String> industries = new ArrayList<>();

    public UserPreference() {
    }

    public UserPreference(Long userId, RiskLevel riskLevel, List<String> industries) {
        this.userId = userId;
        this.riskLevel = riskLevel;
        this.industries = industries;
    }

    // getters and setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public RiskLevel getRiskLevel() {
        return riskLevel;
    }
    
    public void setRiskLevel(RiskLevel riskLevel) {
        this.riskLevel = riskLevel;
    }
    
    public List<String> getIndustries() {
        return industries;
    }
    
    public void setIndustries(List<String> industries) {
        this.industries = industries;
    }

    // 风险级别枚举
    public enum RiskLevel {
        LOW, MEDIUM, HIGH
    }
} 