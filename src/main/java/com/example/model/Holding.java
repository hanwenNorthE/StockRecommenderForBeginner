package com.example.model;

public class Holding {
    private Long id;
    private Long portfolioId;
    private String stockCode;  // Java 字段
    private int quantity;      // 持有数量

    public Holding() {
    }

    // 可选的构造方法
    public Holding(String stockCode, int quantity) {
        this.stockCode = stockCode;
        this.quantity = quantity;
    }

    // =========== Getters & Setters ===========

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
}
