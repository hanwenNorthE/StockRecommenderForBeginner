package com.example.dao.impl;

import com.example.dao.StockNewsDao;
import com.example.model.StockNews;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.List;
import java.util.Optional;

/**
 * StockNews数据访问实现类
 */
@Repository
public class StockNewsDaoImpl implements StockNewsDao {

    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public StockNewsDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    private final RowMapper<StockNews> rowMapper = new StockNewsRowMapper();

    @Override
    public Optional<StockNews> findById(Long id) {
        String sql = "SELECT * FROM stock_news WHERE id = ?";
        try {
            StockNews stockNews = jdbcTemplate.queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(stockNews);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<StockNews> findAll() {
        String sql = "SELECT * FROM stock_news";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public StockNews save(StockNews entity) {
        if (entity.getId() != null && existsById(entity.getId())) {
            // 更新
            String sql = "UPDATE stock_news SET code = ?, title = ?, summary = ?, url = ?, publishDate = ? WHERE id = ?";
            jdbcTemplate.update(sql, 
                entity.getCode(),
                entity.getTitle(),
                entity.getSummary(),
                entity.getUrl(),
                entity.getPublishDate(),
                entity.getId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
            String sql = "INSERT INTO stock_news (code, title, summary, url, publishDate) VALUES (?, ?, ?, ?, ?)";
            jdbcTemplate.update(
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setString(1, entity.getCode());
                    ps.setString(2, entity.getTitle());
                    ps.setString(3, entity.getSummary());
                    ps.setString(4, entity.getUrl());
                    ps.setTimestamp(5, new java.sql.Timestamp(entity.getPublishDate().getTime()));
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
        String sql = "DELETE FROM stock_news WHERE id = ?";
        return jdbcTemplate.update(sql, id) > 0;
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM stock_news WHERE id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public List<StockNews> findByCode(String code) {
        String sql = "SELECT * FROM stock_news WHERE code = ? ORDER BY publishDate DESC";
        return jdbcTemplate.query(sql, rowMapper, code);
    }

    @Override
    public List<StockNews> findByPublishDateBetween(Date startDate, Date endDate) {
        String sql = "SELECT * FROM stock_news WHERE publishDate BETWEEN ? AND ? ORDER BY publishDate DESC";
        return jdbcTemplate.query(sql, rowMapper, 
                new java.sql.Timestamp(startDate.getTime()), 
                new java.sql.Timestamp(endDate.getTime()));
    }

    @Override
    public List<StockNews> findByTitleContaining(String keyword) {
        String sql = "SELECT * FROM stock_news WHERE title LIKE ? ORDER BY publishDate DESC";
        return jdbcTemplate.query(sql, rowMapper, "%" + keyword + "%");
    }

    @Override
    public List<StockNews> findBySummaryContaining(String keyword) {
        String sql = "SELECT * FROM stock_news WHERE summary LIKE ? ORDER BY publishDate DESC";
        return jdbcTemplate.query(sql, rowMapper, "%" + keyword + "%");
    }

    /**
     * StockNews行映射器
     */
    private static class StockNewsRowMapper implements RowMapper<StockNews> {
        @Override
        public StockNews mapRow(ResultSet rs, int rowNum) throws SQLException {
            StockNews stockNews = new StockNews();
            stockNews.setId(rs.getLong("id"));
            stockNews.setCode(rs.getString("code"));
            stockNews.setTitle(rs.getString("title"));
            stockNews.setSummary(rs.getString("summary"));
            stockNews.setUrl(rs.getString("url"));
            stockNews.setPublishDate(rs.getTimestamp("publishDate"));
            return stockNews;
        }
    }
} 