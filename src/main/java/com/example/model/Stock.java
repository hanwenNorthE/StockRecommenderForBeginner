package com.example.model;

public class Stock {
    private String code;
    private String companyName;
    private double currentPrice;
    private double priceChange;
    private double marketValue;
    private String industry;

    public Stock() {
    }

    public Stock(String code, String companyName, double currentPrice, double priceChange, double marketValue, String industry) {
        this.code = code;
        this.companyName = companyName;
        this.currentPrice = currentPrice;
        this.priceChange = priceChange;
        this.marketValue = marketValue;
        this.industry = industry;
    }

    // getters and setters
    public String getCode() {
        return code;
    }
    public void setCode(String code) {
        this.code = code;
    }
    public String getCompanyName() {
        return companyName;
    }
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    public double getCurrentPrice() {
        return currentPrice;
    }
    public void setCurrentPrice(double currentPrice) {
        this.currentPrice = currentPrice;
    }
    public double getPriceChange() {
        return priceChange;
    }
    public void setPriceChange(double priceChange) {
        this.priceChange = priceChange;
    }
    public double getMarketValue() {
        return marketValue;
    }
    public void setMarketValue(double marketValue) {
        this.marketValue = marketValue;
    }
    public String getIndustry() {
        return industry;
    }
    public void setIndustry(String industry) {
        this.industry = industry;
    }
    
    // example method: return stock details (should be implemented in the actual development)
    public StockDetail getStockDetails() {
        return new StockDetail();
    }
} 