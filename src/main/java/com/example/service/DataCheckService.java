package com.example.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.*;

@Service
public class DataCheckService {

    private final JdbcTemplate jdbcTemplate;
    
    // 表名列表，用于安全检查
    private static final List<String> ALLOWED_TABLES = Arrays.asList(
            "stock_details", "price_data", "stocks", "users", "portfolios", 
            "user_preferences", "user_industries", "user_favorites"
    );

    @Autowired
    public DataCheckService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * 获取所有表的数据计数
     */
    public Map<String, Long> getAllTableCounts() {
        Map<String, Long> counts = new HashMap<>();
        
        for (String table : ALLOWED_TABLES) {
            Long count = getTableCount(table);
            counts.put(table, count);
        }
        
        return counts;
    }

    /**
     * 获取单个表的记录数
     */
    public Long getTableCount(String tableName) {
        if (!isTableAllowed(tableName)) {
            return 0L;
        }
        
        try {
            String sql = "SELECT COUNT(*) FROM " + tableName;
            return jdbcTemplate.queryForObject(sql, Long.class);
        } catch (Exception e) {
            // 如果表不存在或者其他数据库错误，返回0
            return 0L;
        }
    }

    /**
     * 获取表的所有列名
     */
    public List<String> getTableColumns(String tableName) {
        if (!isTableAllowed(tableName)) {
            return Collections.emptyList();
        }
        
        try {
            // 使用LIMIT 0来只获取表的元数据，不实际检索数据
            String sql = "SELECT * FROM " + tableName + " LIMIT 0";
            
            return jdbcTemplate.query(
                sql,
                (ResultSet rs) -> {
                    List<String> columns = new ArrayList<>();
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();
                    
                    for (int i = 1; i <= columnCount; i++) {
                        columns.add(metaData.getColumnName(i));
                    }
                    
                    return columns;
                }
            );
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    /**
     * 获取表数据
     */
    public List<List<Object>> getTableData(String tableName, int limit) {
        if (!isTableAllowed(tableName)) {
            return Collections.emptyList();
        }
        
        try {
            // 限制查询记录数量
            int safeLimit = Math.min(limit, 1000); // 设置一个上限，防止请求过多数据
            String sql = "SELECT * FROM " + tableName + " LIMIT " + safeLimit;
            
            return jdbcTemplate.query(
                sql,
                (ResultSet rs) -> {
                    List<List<Object>> rows = new ArrayList<>();
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();
                    
                    while (rs.next()) {
                        List<Object> row = new ArrayList<>(columnCount);
                        for (int i = 1; i <= columnCount; i++) {
                            row.add(rs.getObject(i));
                        }
                        rows.add(row);
                    }
                    
                    return rows;
                }
            );
        } catch (Exception e) {
            return Collections.emptyList();
        }
    }

    /**
     * 检查表名是否在允许列表中，防止SQL注入
     */
    private boolean isTableAllowed(String tableName) {
        return ALLOWED_TABLES.contains(tableName);
    }
} 