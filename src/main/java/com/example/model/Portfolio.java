package com.example.model;

import java.util.ArrayList;
import java.util.List;

/**
 * portfolio class
 */
public class Portfolio {
    private Long id;
    private double cashBalance;
    private List<Holding> holdings = new ArrayList<>();

    public Portfolio() {
    }

    public Portfolio(Long id, double cashBalance, List<Holding> holdings) {
        this.id = id;
        this.cashBalance = cashBalance;
        this.holdings = holdings;
    }

    // getters and setters
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public double getCashBalance() {
        return cashBalance;
    }
    public void setCashBalance(double cashBalance) {
        this.cashBalance = cashBalance;
    }
    public List<Holding> getHoldings() {
        return holdings;
    }
    public void setHoldings(List<Holding> holdings) {
        this.holdings = holdings;
    }
    
    // convenient methods: add/remove holdings
    public void addHolding(Holding holding) {
        this.holdings.add(holding);
        holding.setPortfolioId(this.id);
    }
    
    public void removeHolding(Holding holding) {
        this.holdings.remove(holding);
        holding.setPortfolioId(null);
    }
} 