package com.example.dao.impl;

import com.example.dao.UserDao;
import com.example.model.Name;
import com.example.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import javax.sql.DataSource;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * User数据访问实现类
 */
@Repository
public class UserDaoImpl implements UserDao {

    private final JdbcTemplate jdbcTemplate;
    
    @Autowired
    public UserDaoImpl(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
    
    /**
     * 用户RowMapper，用于将数据库结果映射为User对象
     */
    private static final class UserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setId(rs.getLong("id"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            
            // 使用Name类
            Name name = new Name();
            name.setFirstName(rs.getString("firstName"));
            name.setLastName(rs.getString("lastName"));
            name.setMiddleName(rs.getString("middleName"));
            user.setName(name);
            
            return user;
        }
    }
    
    private final RowMapper<User> rowMapper = new UserRowMapper();
    
    @Override
    public User findById(Long id) {
        try {
            String sql = "SELECT * FROM users WHERE id = ?";
            List<User> users = jdbcTemplate.query(sql, rowMapper, id);
            return users.isEmpty() ? null : users.get(0);
        } catch (Exception e) {
            System.err.println("查询用户失败: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    public User findByEmail(String email) {
        try {
            String sql = "SELECT * FROM users WHERE email = ?";
            List<User> users = jdbcTemplate.query(sql, rowMapper, email);
            return users.isEmpty() ? null : users.get(0);
        } catch (Exception e) {
            System.err.println("根据邮箱查询用户失败: " + e.getMessage());
            return null;
        }
    }
    
    @Override
    public void save(User user) {
        try {
            System.out.println("开始保存用户: " + user.getEmail());
            String sql = "INSERT INTO users (email, password, firstName, lastName, middleName) VALUES (?, ?, ?, ?, ?)";
            Name name = user.getName();
            String firstName = name != null ? name.getFirstName() : null;
            String lastName = name != null ? name.getLastName() : null;
            String middleName = name != null ? name.getMiddleName() : null;
            
            System.out.println("执行SQL: " + sql);
            System.out.println("参数: " + user.getEmail() + ", " + user.getPassword() + ", " + firstName + ", " + lastName + ", " + middleName);
            
            int rowsAffected = jdbcTemplate.update(sql, 
                user.getEmail(), 
                user.getPassword(), 
                firstName,
                lastName,
                middleName
            );
            
            System.out.println("用户保存成功，影响行数: " + rowsAffected);
        } catch (Exception e) {
            System.err.println("保存用户失败: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("保存用户失败", e);
        }
    }
    
    @Override
    public void update(User user) {
        try {
            String sql = "UPDATE users SET email = ?, password = ?, firstName = ?, lastName = ?, middleName = ? WHERE id = ?";
            Name name = user.getName();
            String firstName = name != null ? name.getFirstName() : null;
            String lastName = name != null ? name.getLastName() : null;
            String middleName = name != null ? name.getMiddleName() : null;
            
            jdbcTemplate.update(sql, 
                user.getEmail(), 
                user.getPassword(), 
                firstName,
                lastName,
                middleName,
                user.getId()
            );
        } catch (Exception e) {
            System.err.println("更新用户失败: " + e.getMessage());
            throw new RuntimeException("更新用户失败", e);
        }
    }
    
    @Override
    public void delete(Long id) {
        try {
            String sql = "DELETE FROM users WHERE id = ?";
            jdbcTemplate.update(sql, id);
        } catch (Exception e) {
            System.err.println("删除用户失败: " + e.getMessage());
            throw new RuntimeException("删除用户失败", e);
        }
    }
} 