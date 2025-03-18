package com.example.dao;

import com.example.model.Stock;
import java.util.List;
import java.util.Optional;

/**
 * Stock数据访问接口
 */
public interface StockDao extends BaseDao<Stock, String> {
    
    /**
     * 根据公司名称查找股票
     * @param companyName 公司名称
     * @return 符合条件的股票列表
     */
    List<Stock> findByCompanyName(String companyName);
    
    /**
     * 根据行业查找股票
     * @param industry 行业
     * @return 符合条件的股票列表
     */
    List<Stock> findByIndustry(String industry);
    
    /**
     * 查找价格变动超过指定值的股票
     * @param changePercent 变动百分比
     * @return 符合条件的股票列表
     */
    List<Stock> findByPriceChangeGreaterThan(double changePercent);
    
    /**
     * 根据市值范围查找股票
     * @param minValue 最小市值
     * @param maxValue 最大市值
     * @return 符合条件的股票列表
     */
    List<Stock> findByMarketValueBetween(double minValue, double maxValue);
} 