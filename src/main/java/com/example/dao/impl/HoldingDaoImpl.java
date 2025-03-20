package com.example.dao.impl;

import com.example.dao.HoldingDao;
import com.example.dao.JdbcDaoSupport;
import com.example.model.Holding;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.List;
import java.util.Optional;

/**
 * Holding数据访问实现类
 */
@Repository
public class HoldingDaoImpl extends JdbcDaoSupport implements HoldingDao {

<<<<<<< Updated upstream
    private final RowMapper<Holding> rowMapper = new HoldingRowMapper();
=======
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public HoldingDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    private final RowMapper<Holding> rowMapper = (rs, rowNum) -> {
        Holding holding = new Holding();
        holding.setId(rs.getLong("id"));
        holding.setPortfolioId(rs.getLong("portfolio_id"));
        // 注意这里使用 stock_code
        holding.setStockCode(rs.getString("stock_code"));
        holding.setQuantity(rs.getInt("quantity"));
        return holding;
    };
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
            String sql = "UPDATE holdings SET portfolio_id = ?, stockCode = ?, quantity = ?, purchasePrice = ? WHERE id = ?";
            getJdbcTemplate().update(sql, 
=======
            String sql = "UPDATE holdings SET portfolio_id = ?, stock_code = ?, quantity = ? WHERE id = ?";
            jdbcTemplate.update(sql,
>>>>>>> Stashed changes
                entity.getPortfolioId(),
                entity.getStockCode(), // Java字段stockCode -> 数据库列stock_code
                entity.getQuantity(),
                entity.getId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
<<<<<<< Updated upstream
            String sql = "INSERT INTO holdings (portfolio_id, stockCode, quantity, purchasePrice) VALUES (?, ?, ?, ?)";
            getJdbcTemplate().update(
=======
            String sql = "INSERT INTO holdings (portfolio_id, stock_code, quantity) VALUES (?, ?, ?)";
            jdbcTemplate.update(
>>>>>>> Stashed changes
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setLong(1, entity.getPortfolioId());
                    ps.setString(2, entity.getStockCode());
                    ps.setInt(3, entity.getQuantity());
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
        String sql = "SELECT * FROM holdings WHERE portfolio_id = ? AND stock_code = ?";
        try {
            Holding holding = getJdbcTemplate().queryForObject(sql, rowMapper, portfolioId, stockCode);
            return Optional.ofNullable(holding);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public boolean updateQuantity(Long holdingId, int quantity) {
        // 这里的逻辑是将quantity累加到现有的quantity上
        String sql = "UPDATE holdings SET quantity = quantity + ? WHERE id = ?";
        return getJdbcTemplate().update(sql, quantity, holdingId) > 0;
    }
}
