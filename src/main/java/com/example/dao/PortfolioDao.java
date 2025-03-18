package com.example.dao;

import com.example.model.Portfolio;
import java.util.Optional;

/**
 * Portfolio数据访问接口
 */
public interface PortfolioDao extends BaseDao<Portfolio, Long> {
    
    /**
     * 根据用户ID查找投资组合
     * @param userId 用户ID
     * @return 可能的投资组合
     */
    Optional<Portfolio> findByUserId(Long userId);
    
    /**
     * 更新投资组合现金余额
     * @param portfolioId 投资组合ID
     * @param amount 金额变化量（正数为增加，负数为减少）
     * @return 是否更新成功
     */
    boolean updateCashBalance(Long portfolioId, double amount);
} 