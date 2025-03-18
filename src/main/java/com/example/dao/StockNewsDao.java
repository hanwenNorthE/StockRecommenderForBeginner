package com.example.dao;

import com.example.model.StockNews;
import java.util.Date;
import java.util.List;

/**
 * StockNews数据访问接口
 */
public interface StockNewsDao extends BaseDao<StockNews, Long> {
    
    /**
     * 根据股票代码查找新闻
     * @param code 股票代码
     * @return 符合条件的新闻列表
     */
    List<StockNews> findByCode(String code);
    
    /**
     * 根据发布日期范围查找新闻
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 符合条件的新闻列表
     */
    List<StockNews> findByPublishDateBetween(Date startDate, Date endDate);
    
    /**
     * 根据标题关键词查找新闻
     * @param keyword 关键词
     * @return 符合条件的新闻列表
     */
    List<StockNews> findByTitleContaining(String keyword);
    
    /**
     * 根据摘要关键词查找新闻
     * @param keyword 关键词
     * @return 符合条件的新闻列表
     */
    List<StockNews> findBySummaryContaining(String keyword);
} 