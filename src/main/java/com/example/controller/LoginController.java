package com.example.controller;

import com.example.model.Name;
import com.example.model.User;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

/**
 * 登录控制器
 */
@Controller
public class LoginController {
    
    private final UserService userService;
    
    @Autowired
    public LoginController(UserService userService) {
        this.userService = userService;
    }
    
    /**
     * 显示登录页面
     */
    @GetMapping("/login")
    public String showLoginPage() {
        return "loginPage";
    }
    
    /**
     * 处理登录请求
     */
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                      @RequestParam("password") String password,
                      HttpSession session,
                      Model model) {
        
        System.out.println("login方法被调用，email=" + email);
        
        try {
            // 查找用户
            User user = userService.findByEmail(email);
            
            // 检查用户是否存在且密码是否匹配
            if (user != null && user.getPassword().equals(password)) {
                System.out.println("用户登录成功，email=" + email);
                
                // 将用户信息存入session
                session.setAttribute("user", user);
                System.out.println("用户信息已存入session，user.id=" + user.getId());
                
                // 返回用户资料页面
                return "profilePage";
            } else {
                System.out.println("用户登录失败，email=" + email);
                model.addAttribute("error", "邮箱或密码错误");
                return "loginPage";
            }
        } catch (Exception e) {
            System.out.println("登录过程中发生异常: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "登录失败：" + e.getMessage());
            return "loginPage";
        }
    }
    
    /**
     * 处理用户注册请求
     */
    @PostMapping("/register")
    public String register(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        @RequestParam("firstName") String firstName,
                        @RequestParam("lastName") String lastName,
                        Model model) {
        
        System.out.println("register方法被调用，email=" + email);
        
        try {
            // 检查用户是否已存在
            if (userService.findByEmail(email) != null) {
                System.out.println("用户已存在，email=" + email);
                model.addAttribute("error", "该邮箱已被注册");
                return "loginPage";
            }
            
            // 创建新用户
            User user = new User();
            user.setEmail(email);
            user.setPassword(password);
            
            // 设置用户姓名
            Name name = new Name();
            name.setFirstName(firstName);
            name.setLastName(lastName);
            user.setName(name);
            
            // 保存用户
            userService.register(user);
            System.out.println("用户注册成功，email=" + email);
            
            // 返回登录页面并显示成功消息
            model.addAttribute("successMessage", "注册成功，请登录");
            return "loginPage";
            
        } catch (Exception e) {
            System.out.println("注册过程中发生异常: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "注册失败：" + e.getMessage());
            return "loginPage";
        }
    }
    
    /**
     * 显示用户资料页面
     */
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        System.out.println("=== 进入showProfile方法 ===");
        
        // 打印session中的所有属性
        System.out.println("Session属性列表:");
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            System.out.println("  - " + name + ": " + session.getAttribute(name));
        }
        
        // 检查用户是否登录
        User user = (User) session.getAttribute("user");
        System.out.println("从session获取user: " + (user != null ? "存在" : "不存在"));
        
        if (user == null) {
            System.out.println("用户未登录，返回登录页面");
            model.addAttribute("error", "请先登录");
            return "loginPage";
        }
        
        System.out.println("用户已登录: " + user.getEmail());
        System.out.println("用户ID: " + user.getId());
        System.out.println("用户姓名: " + (user.getName() != null ? user.getName().getFirstName() : "null"));
        
        // 将用户信息添加到模型
        model.addAttribute("user", user);
        System.out.println("用户信息已添加到模型");
        
        // 添加一些默认数据
        model.addAttribute("accountBalance", "10000.00");
        model.addAttribute("userHoldings", new java.util.ArrayList<>());
        model.addAttribute("recommendedStocks", new java.util.ArrayList<>());
        
        System.out.println("准备返回profilePage视图");
        return "profilePage";
    }
    
    /**
     * 处理登出请求
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, Model model) {
        // 清除session
        session.invalidate();
        model.addAttribute("successMessage", "您已成功退出登录");
        return "loginPage";
    }
} 