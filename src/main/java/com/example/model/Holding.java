package com.example.model;

/**
 * holding class
 */
public class Holding {
    private Long id;
    private Long portfolioId;
    private String stockCode;
    private int quantity;  // 持有数量
    private double purchasePrice;

    public Holding() {
    }

    public Holding(String stockCode, int quantity, double purchasePrice) {
        this.stockCode = stockCode;
        this.quantity = quantity;
        this.purchasePrice = purchasePrice;
    }

    // getters and setters
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getPortfolioId() {
        return portfolioId;
    }
    public void setPortfolioId(Long portfolioId) {
        this.portfolioId = portfolioId;
    }
    public String getStockCode() {
        return stockCode;
    }
    public void setStockCode(String stockCode) {
        this.stockCode = stockCode;
    }
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    public double getPurchasePrice() {
        return purchasePrice;
    }
    public void setPurchasePrice(double purchasePrice) {
        this.purchasePrice = purchasePrice;
    }
} 