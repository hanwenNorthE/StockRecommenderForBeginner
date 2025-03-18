package com.example.dao;

import com.example.model.User;
import java.util.Optional;

/**
 * User数据访问接口
 */
public interface UserDao extends BaseDao<User, Long> {
    
    /**
     * 根据邮箱查找用户
     * @param email 邮箱
     * @return 可能的用户
     */
    Optional<User> findByEmail(String email);
    
    /**
     * 根据邮箱和密码查找用户（用于登录验证）
     * @param email 邮箱
     * @param password 密码
     * @return 可能的用户
     */
    Optional<User> findByEmailAndPassword(String email, String password);
    
    /**
     * 根据姓名查找用户
     * @param firstName 名
     * @param lastName 姓
     * @return 可能的用户
     */
    Optional<User> findByName(String firstName, String lastName);
} 