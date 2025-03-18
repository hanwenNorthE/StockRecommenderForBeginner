package com.example.dao.impl;

import com.example.dao.JdbcDaoSupport;
import com.example.dao.StockDao;
import com.example.model.Stock;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Stock数据访问实现类
 */
@Repository
public class StockDaoImpl extends JdbcDaoSupport implements StockDao {

    private final RowMapper<Stock> rowMapper = new StockRowMapper();

    @Override
    public Optional<Stock> findById(String code) {
        String sql = "SELECT * FROM stocks WHERE code = ?";
        try {
            Stock stock = getJdbcTemplate().queryForObject(sql, rowMapper, code);
            return Optional.ofNullable(stock);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Stock> findAll() {
        String sql = "SELECT * FROM stocks";
        return getJdbcTemplate().query(sql, rowMapper);
    }

    @Override
    public Stock save(Stock entity) {
        if (existsById(entity.getCode())) {
            // 更新
            String sql = "UPDATE stocks SET companyName = ?, currentPrice = ?, priceChange = ?, marketValue = ?, industry = ? WHERE code = ?";
            getJdbcTemplate().update(sql, 
                entity.getCompanyName(),
                entity.getCurrentPrice(),
                entity.getPriceChange(),
                entity.getMarketValue(),
                entity.getIndustry(),
                entity.getCode()
            );
        } else {
            // 插入
            String sql = "INSERT INTO stocks (code, companyName, currentPrice, priceChange, marketValue, industry) VALUES (?, ?, ?, ?, ?, ?)";
            getJdbcTemplate().update(sql, 
                entity.getCode(),
                entity.getCompanyName(),
                entity.getCurrentPrice(),
                entity.getPriceChange(),
                entity.getMarketValue(),
                entity.getIndustry()
            );
        }
        return entity;
    }

    @Override
    public boolean deleteById(String code) {
        String sql = "DELETE FROM stocks WHERE code = ?";
        return getJdbcTemplate().update(sql, code) > 0;
    }

    @Override
    public boolean existsById(String code) {
        String sql = "SELECT COUNT(*) FROM stocks WHERE code = ?";
        Integer count = getJdbcTemplate().queryForObject(sql, Integer.class, code);
        return count != null && count > 0;
    }

    @Override
    public List<Stock> findByCompanyName(String companyName) {
        String sql = "SELECT * FROM stocks WHERE companyName LIKE ?";
        return getJdbcTemplate().query(sql, rowMapper, "%" + companyName + "%");
    }

    @Override
    public List<Stock> findByIndustry(String industry) {
        String sql = "SELECT * FROM stocks WHERE industry = ?";
        return getJdbcTemplate().query(sql, rowMapper, industry);
    }

    @Override
    public List<Stock> findByPriceChangeGreaterThan(double changePercent) {
        String sql = "SELECT * FROM stocks WHERE priceChange > ?";
        return getJdbcTemplate().query(sql, rowMapper, changePercent);
    }

    @Override
    public List<Stock> findByMarketValueBetween(double minValue, double maxValue) {
        String sql = "SELECT * FROM stocks WHERE marketValue BETWEEN ? AND ?";
        return getJdbcTemplate().query(sql, rowMapper, minValue, maxValue);
    }

    /**
     * Stock行映射器
     */
    private static class StockRowMapper implements RowMapper<Stock> {
        @Override
        public Stock mapRow(ResultSet rs, int rowNum) throws SQLException {
            Stock stock = new Stock();
            stock.setCode(rs.getString("code"));
            stock.setCompanyName(rs.getString("companyName"));
            stock.setCurrentPrice(rs.getDouble("currentPrice"));
            stock.setPriceChange(rs.getDouble("priceChange"));
            stock.setMarketValue(rs.getDouble("marketValue"));
            stock.setIndustry(rs.getString("industry"));
            return stock;
        }
    }
} 