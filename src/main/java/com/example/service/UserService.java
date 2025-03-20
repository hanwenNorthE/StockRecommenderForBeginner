package com.example.service;

import com.example.dao.UserDao;
import com.example.model.Name;
import com.example.model.User;
import com.example.model.UserPreference;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 用户服务接口实现类
 */
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
        
        // 这里应该进行密码加密，但为了简化，暂不处理
        System.out.println("register user: " + user.getEmail());
        
        // 保存用户
        userDao.save(user);
        System.out.println("user registered");
    }
    
    /**
     * 用户登录
     */
    public User login(String email, String password) {
        User user = userDao.findByEmail(email);
        if (user != null && password.equals(user.getPassword())) {
            return user;
        }
        return null;
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
        
        // 设置用户偏好并保存
        user.setPreferences(preference);
        userDao.update(user);
    }
    
    /**
     * 根据邮箱查找用户
     */
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }
} 