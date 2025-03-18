package com.example.dao.impl;

import com.example.dao.JdbcDaoSupport;
import com.example.dao.PortfolioDao;
import com.example.model.Portfolio;
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
 * Portfolio数据访问实现类
 */
@Repository
public class PortfolioDaoImpl extends JdbcDaoSupport implements PortfolioDao {

    private final RowMapper<Portfolio> rowMapper = new PortfolioRowMapper();

    @Override
    public Optional<Portfolio> findById(Long id) {
        String sql = "SELECT * FROM portfolios WHERE id = ?";
        try {
            Portfolio portfolio = getJdbcTemplate().queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(portfolio);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<Portfolio> findAll() {
        String sql = "SELECT * FROM portfolios";
        return getJdbcTemplate().query(sql, rowMapper);
    }

    @Override
    public Portfolio save(Portfolio entity) {
        if (entity.getId() != null && existsById(entity.getId())) {
            // 更新
            String sql = "UPDATE portfolios SET users_id = ?, cashBalance = ? WHERE id = ?";
            getJdbcTemplate().update(sql, 
                entity.getId(),  // 这里假设Portfolio关联的User的ID与Portfolio的ID一致，实际应根据业务调整
                entity.getCashBalance(),
                entity.getId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
            String sql = "INSERT INTO portfolios (users_id, cashBalance) VALUES (?, ?)";
            getJdbcTemplate().update(
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setLong(1, entity.getId());  // 同上，需根据实际业务调整
                    ps.setDouble(2, entity.getCashBalance());
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
        String sql = "DELETE FROM portfolios WHERE id = ?";
        return getJdbcTemplate().update(sql, id) > 0;
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM portfolios WHERE id = ?";
        Integer count = getJdbcTemplate().queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public Optional<Portfolio> findByUserId(Long userId) {
        String sql = "SELECT * FROM portfolios WHERE users_id = ?";
        try {
            Portfolio portfolio = getJdbcTemplate().queryForObject(sql, rowMapper, userId);
            return Optional.ofNullable(portfolio);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean updateCashBalance(Long portfolioId, double amount) {
        String sql = "UPDATE portfolios SET cashBalance = cashBalance + ? WHERE id = ?";
        return getJdbcTemplate().update(sql, amount, portfolioId) > 0;
    }

    /**
     * Portfolio行映射器
     */
    private static class PortfolioRowMapper implements RowMapper<Portfolio> {
        @Override
        public Portfolio mapRow(ResultSet rs, int rowNum) throws SQLException {
            Portfolio portfolio = new Portfolio();
            portfolio.setId(rs.getLong("id"));
            portfolio.setCashBalance(rs.getDouble("cashBalance"));
            return portfolio;
        }
    }
} 