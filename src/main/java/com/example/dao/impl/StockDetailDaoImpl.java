package com.example.dao.impl;

import com.example.dao.StockDetailDao;
import com.example.model.StockDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

/**
 * StockDetail数据访问实现类
 */
@Repository
public class StockDetailDaoImpl implements StockDetailDao {

    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public StockDetailDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    private final RowMapper<StockDetail> rowMapper = new StockDetailRowMapper();

    @Override
    public Optional<StockDetail> findById(String code) {
        String sql = "SELECT * FROM stock_details WHERE code = ?";
        try {
            StockDetail stockDetail = jdbcTemplate.queryForObject(sql, rowMapper, code);
            return Optional.ofNullable(stockDetail);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<StockDetail> findAll() {
        String sql = "SELECT * FROM stock_details";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public StockDetail save(StockDetail entity) {
        if (existsById(entity.getCode())) {
            // 更新
            String sql = "UPDATE stock_details SET description = ? WHERE code = ?";
            jdbcTemplate.update(sql, entity.getDescription(), entity.getCode());
        } else {
            // 插入
            String sql = "INSERT INTO stock_details (code, description) VALUES (?, ?)";
            jdbcTemplate.update(sql, entity.getCode(), entity.getDescription());
        }
        return entity;
    }

    @Override
    public boolean deleteById(String code) {
        String sql = "DELETE FROM stock_details WHERE code = ?";
        return jdbcTemplate.update(sql, code) > 0;
    }

    @Override
    public boolean existsById(String code) {
        String sql = "SELECT COUNT(*) FROM stock_details WHERE code = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, code);
        return count != null && count > 0;
    }

    @Override
    public List<StockDetail> findByDescriptionContaining(String keyword) {
        String sql = "SELECT * FROM stock_details WHERE description LIKE ?";
        return jdbcTemplate.query(sql, rowMapper, "%" + keyword + "%");
    }

    @Override
    public StockDetail findByStockCode(String stockCode) {
        return findById(stockCode).orElse(null);
    }

    /**
     * StockDetail行映射器
     */
    private static class StockDetailRowMapper implements RowMapper<StockDetail> {
        @Override
        public StockDetail mapRow(ResultSet rs, int rowNum) throws SQLException {
            StockDetail stockDetail = new StockDetail();
            stockDetail.setCode(rs.getString("code"));
            stockDetail.setDescription(rs.getString("description"));
            return stockDetail;
        }
    }
} 