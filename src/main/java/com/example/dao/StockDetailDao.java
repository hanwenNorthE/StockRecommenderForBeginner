package com.example.dao;

import com.example.model.StockDetail;
import java.util.List;

/**
 * StockDetail数据访问接口
 */
public interface StockDetailDao extends BaseDao<StockDetail, String> {
    
    /**
     * 根据描述关键词查找股票详情
     * @param keyword 关键词
     * @return 符合条件的股票详情列表
     */
    List<StockDetail> findByDescriptionContaining(String keyword);
    
    /**
     * 根据股票代码获取股票详情
     * @param stockCode 股票代码
     * @return 可能的股票详情
     */
    StockDetail findByStockCode(String stockCode);
} 