package com.example.dao.impl;    
import com.example.dao.PriceDataDao;
import com.example.model.PriceData;
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
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.ArrayList;

/**
 * PriceData数据访问实现类
 */
@Repository
public class PriceDataDaoImpl implements PriceDataDao {

    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public PriceDataDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    private final RowMapper<PriceData> rowMapper = new PriceDataRowMapper();

    @Override
    public Optional<PriceData> findById(Long id) {
        String sql = "SELECT * FROM price_data WHERE priceDataId = ?";
        try {
            PriceData priceData = jdbcTemplate.queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(priceData);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<PriceData> findAll() {
        String sql = "SELECT * FROM price_data";
        return jdbcTemplate.query(sql, rowMapper);
    }

    @Override
    public PriceData save(PriceData entity) {
        if (entity.getPriceDataId() != null && existsById(entity.getPriceDataId())) {
            // 更新
            String sql = "UPDATE price_data SET code = ?, date = ?, open = ?, high = ?, low = ?, close = ?, volume = ?, OpenInt = ? WHERE priceDataId = ?";
            jdbcTemplate.update(sql, 
                entity.getCode(),
                entity.getDate(),
                entity.getOpen(),
                entity.getHigh(),
                entity.getLow(),
                entity.getClose(),
                entity.getVolume(),
                entity.getOpenInt(),
                entity.getPriceDataId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
            String sql = "INSERT INTO price_data (code, date, open, high, low, close, volume, OpenInt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            jdbcTemplate.update(
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setString(1, entity.getCode());
                    ps.setTimestamp(2, new java.sql.Timestamp(entity.getDate().getTime()));
                    ps.setDouble(3, entity.getOpen());
                    ps.setDouble(4, entity.getHigh());
                    ps.setDouble(5, entity.getLow());
                    ps.setDouble(6, entity.getClose());
                    ps.setLong(7, entity.getVolume());
                    ps.setInt(8, entity.getOpenInt());
                    return ps;
                },
                keyHolder
            );
            Number key = keyHolder.getKey();
            if (key != null) {
                entity.setPriceDataId(key.longValue());
            }
        }
        return entity;
    }

    @Override
    public boolean deleteById(Long id) {
        String sql = "DELETE FROM price_data WHERE priceDataId = ?";
        return jdbcTemplate.update(sql, id) > 0;
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM price_data WHERE priceDataId = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public List<PriceData> findByCode(String code) {
        String sql = "SELECT * FROM price_data WHERE code = ? ORDER BY date DESC";
        return jdbcTemplate.query(sql, rowMapper, code);
    }

    @Override
    public List<PriceData> findByCodeAndDateBetween(String code, Date startDate, Date endDate) {
        String sql = "SELECT * FROM price_data WHERE code = ? AND date BETWEEN ? AND ? ORDER BY date";
        return jdbcTemplate.query(sql, rowMapper, code, 
                new java.sql.Timestamp(startDate.getTime()), 
                new java.sql.Timestamp(endDate.getTime()));
    }

    @Override
    public PriceData findLatestByCode(String code) {
        String sql = "SELECT * FROM price_data WHERE code = ? ORDER BY date DESC LIMIT 1";
        List<PriceData> results = jdbcTemplate.query(sql, rowMapper, code);
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public List<PriceData> saveAll(List<PriceData> priceDataList) {
        List<PriceData> result = new ArrayList<>();
        for (PriceData data : priceDataList) {
            result.add(save(data));
        }
        return result;
    }

    /**
     * PriceData行映射器
     */
    private static class PriceDataRowMapper implements RowMapper<PriceData> {
        @Override
        public PriceData mapRow(ResultSet rs, int rowNum) throws SQLException {
            PriceData priceData = new PriceData();
            priceData.setPriceDataId(rs.getLong("priceDataId"));
            priceData.setCode(rs.getString("code"));
            priceData.setDate(rs.getTimestamp("date"));
            priceData.setOpen(rs.getDouble("open"));
            priceData.setHigh(rs.getDouble("high"));
            priceData.setLow(rs.getDouble("low"));
            priceData.setClose(rs.getDouble("close"));
            priceData.setVolume(rs.getLong("volume"));
            priceData.setOpenInt(rs.getInt("OpenInt"));
            return priceData;
        }
    }
} 