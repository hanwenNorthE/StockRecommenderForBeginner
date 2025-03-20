package com.example.dao;

import com.example.model.Stock;
import java.util.List;
import java.util.Optional;

/**
 * Stock data access interface
 */
public interface StockDao extends BaseDao<Stock, String> {
    
    /**
     * find stocks by company name
     * @param companyName company name
     * @return list of stocks
     */
    List<Stock> findByCompanyName(String companyName);
    
    /**
     * comprehensive search stocks, support code and company name
     * @param keyword search keyword
     * @return list of stocks
     */
    List<Stock> search(String keyword);
    
    /**
     * find stocks by industry
     * @param industry industry
     * @return list of stocks
     */
    List<Stock> findByIndustry(String industry);
    
    /**
     * find stocks by price change greater than specified value
     * @param changePercent change percent
     * @return list of stocks
     */
    List<Stock> findByPriceChangeGreaterThan(double changePercent);
    
    /**
     * find stocks by market value between specified value
     * @param minValue minimum market value
     * @param maxValue maximum market value
     * @return list of stocks
     */
    List<Stock> findByMarketValueBetween(double minValue, double maxValue);
} 