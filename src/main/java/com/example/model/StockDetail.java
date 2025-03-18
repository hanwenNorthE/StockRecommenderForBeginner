package com.example.model;

import java.util.ArrayList;
import java.util.List;

public class StockDetail {
    private String code;
    private String description;
    private List<PriceData> priceHistory = new ArrayList<>();

    public StockDetail() {
    }

    public StockDetail(String code, String description) {
        this.code = code;
        this.description = description;
    }

    // getters and setters
    public String getCode() {
        return code;
    }
    
    public void setCode(String code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<PriceData> getPriceHistory() {
        return priceHistory;
    }
    
    public void setPriceHistory(List<PriceData> priceHistory) {
        this.priceHistory = priceHistory;
    }
} 