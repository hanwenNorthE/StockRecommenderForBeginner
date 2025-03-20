package com.example.dao;

import com.example.model.Holding;
import java.util.List;
import java.util.Optional;

/**
 * Holding数据访问接口
 */
public interface HoldingDao extends BaseDao<Holding, Long> {

    /**
     * 根据投资组合ID查找持仓
     */
    List<Holding> findByPortfolioId(Long portfolioId);

    /**
     * 根据投资组合ID和股票代码查找持仓
     */
    Optional<Holding> findByPortfolioIdAndStockCode(Long portfolioId, String stockCode);

    /**
     * 更新持仓数量
     * @param holdingId 持仓ID
     * @param quantity 数量变化（正数为增加，负数为减少）
     * @return 是否更新成功
     */
    boolean updateQuantity(Long holdingId, int quantity);
}
