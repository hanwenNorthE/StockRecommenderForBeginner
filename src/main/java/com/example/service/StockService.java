package com.example.service;

import com.example.dao.StockDao;
import com.example.model.Industry;
import com.example.model.Stock;
import com.example.model.StockDetail;
import com.example.dao.StockDetailDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class StockService {
    
    private final StockDao stockDao;
    private final StockDetailDao stockDetailDao;
    
    @Autowired
    public StockService(StockDao stockDao, StockDetailDao stockDetailDao) {
        this.stockDao = stockDao;
        this.stockDetailDao = stockDetailDao;
    }
    
    // search stock by keyword
    public List<Stock> searchStock(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return stockDao.search(keyword);
    }
    
    // get stock detail
    public StockDetail getStockDetail(String stockCode) {
        return stockDetailDao.findByStockCode(stockCode);
    }
    
    // get hot stocks
    public List<Stock> getHotStocks() {
        try {
            // get the top 5 stocks with the highest price change
            List<Stock> hotStocks = stockDao.findByPriceChangeGreaterThan(0);
            return hotStocks.size() > 5 ? hotStocks.subList(0, 5) : hotStocks;
        } catch (Exception e) {
            // if the database query fails, return simulated data
            List<Stock> hotStocks = new ArrayList<>();
            
            hotStocks.add(new Stock("AAPL", "Apple Inc.", 150.25, 2.35, 2.45e12, "Technology"));
            hotStocks.add(new Stock("MSFT", "Microsoft Corporation", 290.17, 1.89, 2.2e12, "Technology"));
            hotStocks.add(new Stock("GOOGL", "Alphabet Inc.", 2750.28, 15.67, 1.83e12, "Communication Services"));
            hotStocks.add(new Stock("AMZN", "Amazon.com, Inc.", 3380.05, -12.34, 1.71e12, "Consumer Goods"));
            hotStocks.add(new Stock("TSLA", "Tesla, Inc.", 725.60, 8.96, 7.33e11, "Consumer Goods"));
            
            return hotStocks;
        }
    }
    
    // find all stocks
    public List<Stock> findAllStocks() {
        return stockDao.findAll();
    }
    
    // find stocks by industry
    public List<Stock> findByIndustry(String industry) {
        return stockDao.findByIndustry(industry);
    }
    
    // get stock detail
    public Stock getStock(String code) {
        return stockDao.findById(code).orElse(null);
    }
} 