package com.example.dao;

import com.example.model.User;

public interface UserDao {
    
    /**
     * 根据ID查找用户
     */
    User findById(Long id);
    
    /**
     * 根据邮箱查找用户
     */
    User findByEmail(String email);
    
    /**
     * 保存用户
     */
    void save(User user);
    
    /**
     * 更新用户
     */
    void update(User user);
    
    /**
     * 删除用户
     */
    void delete(Long id);
} 