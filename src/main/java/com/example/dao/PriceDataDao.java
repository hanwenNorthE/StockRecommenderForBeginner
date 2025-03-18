package com.example.dao;

import com.example.model.PriceData;
import java.util.Date;
import java.util.List;

/**
 * PriceData数据访问接口
 */
public interface PriceDataDao extends BaseDao<PriceData, Long> {
    
    /**
     * 根据股票代码查找价格数据
     * @param code 股票代码
     * @return 符合条件的价格数据列表
     */
    List<PriceData> findByCode(String code);
    
    /**
     * 根据日期范围查找价格数据
     * @param code 股票代码
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 符合条件的价格数据列表
     */
    List<PriceData> findByCodeAndDateBetween(String code, Date startDate, Date endDate);
    
    /**
     * 获取股票的最新价格数据
     * @param code 股票代码
     * @return 最新的价格数据
     */
    PriceData findLatestByCode(String code);
    
    /**
     * 批量保存价格数据
     * @param priceDataList 价格数据列表
     * @return 保存后的价格数据列表
     */
    List<PriceData> saveAll(List<PriceData> priceDataList);
} 