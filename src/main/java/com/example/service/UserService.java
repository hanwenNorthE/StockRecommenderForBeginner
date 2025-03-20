package com.example.service;

import com.example.dao.UserDao;
import com.example.model.Name;
import com.example.model.User;
import com.example.model.UserPreference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    
    private final UserDao userDao;
    
    @Autowired
    public UserService(UserDao userDao) {
        this.userDao = userDao;
    }
    
    /**
     * 用户注册
     */
    @Transactional
    public void register(User user) {
        // 检查邮箱是否已存在
        if (userDao.findByEmail(user.getEmail()) != null) {
            throw new RuntimeException("the email has been registered");
        }
        
        // 确保用户有Name对象
        if (user.getName() == null) {
            user.setName(new Name());
        }
        
        // TODO: 可以在此进行密码加密
        userDao.save(user);
        System.out.println("user registered: " + user.getEmail());
    }
    
    /**
     * 用户登录
     */
    public User login(String email, String password) {
        User user = userDao.findByEmail(email);
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null; // 找不到或密码不匹配
    }
    
    /**
     * 更新用户偏好
     */
    public void updatePreference(Long userId, UserPreference preference) {
        // 查找用户
        User user = userDao.findById(userId);
        if (user == null) {
            throw new RuntimeException("user not found");
        }
        // 设置用户偏好并更新
        user.setPreferences(preference);
        userDao.update(user);
    }

    /**
     * 根据邮箱查找用户
     */
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }
    
    // ========== 新增的两个方法，用于支持UPDATE/DELETE ==========

    /**
     * 更新用户资料（主要指 Email、Password 等）
     */
    @Transactional
    public void updateUser(User user) {
        // 可做更多业务校验，如检查新邮箱是否被占用
        userDao.update(user);
    }

    /**
     * 删除用户
     */
    @Transactional
    public void deleteUser(Long userId) {
        // 可以在这里做一些额外操作，如删除关联数据
        userDao.delete(userId);
    }
}
