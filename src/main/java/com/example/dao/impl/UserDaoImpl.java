package com.example.dao.impl;

import com.example.dao.JdbcDaoSupport;
import com.example.dao.UserDao;
import com.example.model.Name;
import com.example.model.User;
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
 * User数据访问实现类
 */
@Repository
public class UserDaoImpl extends JdbcDaoSupport implements UserDao {

    private final RowMapper<User> rowMapper = new UserRowMapper();

    @Override
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            User user = getJdbcTemplate().queryForObject(sql, rowMapper, id);
            return Optional.ofNullable(user);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users";
        return getJdbcTemplate().query(sql, rowMapper);
    }

    @Override
    public User save(User entity) {
        if (entity.getId() != null && existsById(entity.getId())) {
            // 更新
            String sql = "UPDATE users SET email = ?, password = ?, firstName = ?, lastName = ?, middleName = ? WHERE id = ?";
            getJdbcTemplate().update(sql, 
                entity.getEmail(),
                entity.getPassword(),
                entity.getName().getFirstName(),
                entity.getName().getLastName(),
                entity.getName().getMiddleName(),
                entity.getId()
            );
        } else {
            // 插入
            KeyHolder keyHolder = new GeneratedKeyHolder();
            String sql = "INSERT INTO users (email, password, firstName, lastName, middleName) VALUES (?, ?, ?, ?, ?)";
            getJdbcTemplate().update(
                connection -> {
                    PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    ps.setString(1, entity.getEmail());
                    ps.setString(2, entity.getPassword());
                    ps.setString(3, entity.getName().getFirstName());
                    ps.setString(4, entity.getName().getLastName());
                    ps.setString(5, entity.getName().getMiddleName());
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
        String sql = "DELETE FROM users WHERE id = ?";
        return getJdbcTemplate().update(sql, id) > 0;
    }

    @Override
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM users WHERE id = ?";
        Integer count = getJdbcTemplate().queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }

    @Override
    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try {
            User user = getJdbcTemplate().queryForObject(sql, rowMapper, email);
            return Optional.ofNullable(user);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<User> findByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try {
            User user = getJdbcTemplate().queryForObject(sql, rowMapper, email, password);
            return Optional.ofNullable(user);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<User> findByName(String firstName, String lastName) {
        String sql = "SELECT * FROM users WHERE firstName = ? AND lastName = ?";
        try {
            User user = getJdbcTemplate().queryForObject(sql, rowMapper, firstName, lastName);
            return Optional.ofNullable(user);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    /**
     * User行映射器
     */
    private static class UserRowMapper implements RowMapper<User> {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setId(rs.getLong("id"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));
            
            Name name = new Name();
            name.setFirstName(rs.getString("firstName"));
            name.setLastName(rs.getString("lastName"));
            name.setMiddleName(rs.getString("middleName"));
            user.setName(name);
            
            return user;
        }
    }
} 