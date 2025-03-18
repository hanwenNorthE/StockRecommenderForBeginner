package com.example.dao.impl;

import com.example.dao.HoldingDao;
import com.example.dao.JdbcDaoSupport;
import com.example.model.Holding;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

/**
 * Holding数据访问实现类
 */
@Repository
public class HoldingDaoImpl extends JdbcDaoSupport implements HoldingDao {

    private final RowMapper<Holding> rowMapper = new HoldingRowMapper();

    @Override
    public Optional<Holding> findById(Long id) {
        String sql = "SELECT * FROM holdings WHERE id = ?";
        try {
            Holding holding = getJdbcTemplate().queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(holding);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Holding> findAll() {
        String sql = "SELECT * FROM holdings";
        return getJdbcTemplate().query(sql, rowMapper);
    }

    @Override
    public Holding save(Holding entity) {
        if (entity.getId() != null && existsById(entity.getId())) {
            // 更新
            String sql = "UPDATE holdings SET portfolio_id = ?, stockCode = ?, quantity = ?, purchasePrice = ? WHERE id = ?";
            getJdbcTemplate().update(sql, 
                entity.getPortfolioId(),
                entity.getStockCode(),
                entity.getQuantity(),
                entity.getPurchasePrice(),
                entity.getId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
            String sql = "INSERT INTO holdings (portfolio_id, stockCode, quantity, purchasePrice) VALUES (?, ?, ?, ?)";
            getJdbcTemplate().update(
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setLong(1, entity.getPortfolioId());
                    ps.setString(2, entity.getStockCode());
                    ps.setInt(3, entity.getQuantity());
                    ps.setDouble(4, entity.getPurchasePrice());
                    return ps;
                },
                keyHolder
            );
            Number key = keyHolder.getKey();
            if (key != null) {
                entity.setId(key.longValue());
            }
        }
        return entity;
    }

    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM holdings WHERE id = ?";
        return getJdbcTemplate().update(sql, id) > 0;
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM holdings WHERE id = ?";
        Integer count = getJdbcTemplate().queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public List<Holding> findByPortfolioId(Long portfolioId) {
        String sql = "SELECT * FROM holdings WHERE portfolio_id = ?";
        return getJdbcTemplate().query(sql, rowMapper, portfolioId);
    }

    @Override
    public Optional<Holding> findByPortfolioIdAndStockCode(Long portfolioId, String stockCode) {
        String sql = "SELECT * FROM holdings WHERE portfolio_id = ? AND stockCode = ?";
        try {
            Holding holding = getJdbcTemplate().queryForObject(sql, rowMapper, portfolioId, stockCode);
            return Optional.ofNullable(holding);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean updateQuantity(Long holdingId, int quantity) {
        String sql = "UPDATE holdings SET quantity = quantity + ? WHERE id = ?";
        return getJdbcTemplate().update(sql, quantity, holdingId) > 0;
    }

    /**
     * Holding行映射器
     */
    private static class HoldingRowMapper implements RowMapper<Holding> {
        @Override
        public Holding mapRow(ResultSet rs, int rowNum) throws SQLException {
            Holding holding = new Holding();
            holding.setId(rs.getLong("id"));
            holding.setPortfolioId(rs.getLong("portfolio_id"));
            holding.setStockCode(rs.getString("stockCode"));
            holding.setQuantity(rs.getInt("quantity"));
            holding.setPurchasePrice(rs.getDouble("purchasePrice"));
            return holding;
        }
    }
} 