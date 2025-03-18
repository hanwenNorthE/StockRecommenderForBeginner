package com.example.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;

/**
 * JDBC DAO支持类，为DAO实现类提供JdbcTemplate
 */
public class JdbcDaoSupport {
    
    private JdbcTemplate jdbcTemplate;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    protected JdbcTemplate getJdbcTemplate() {
        return this.jdbcTemplate;
    }
} 