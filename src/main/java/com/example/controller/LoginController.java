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
 * login controller
 */
@Controller
public class LoginController {
    
    private final UserService userService;
    
    @Autowired
    public LoginController(UserService userService) {
        this.userService = userService;
    }
    
    /**
     * show login page
     */
    @GetMapping("/login")
    public String showLoginPage() {
        return "loginPage";
    }
    
    /**
     * handle login request
     */
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                      @RequestParam("password") String password,
                      HttpSession session,
                      Model model) {
        
        System.out.println("login method called, email=" + email);
        
        try {
            // 查找用户
            User user = userService.findByEmail(email);
            
            // 检查用户是否存在且密码是否匹配
            if (user != null && user.getPassword().equals(password)) {
                System.out.println("user login successfully, email=" + email);
                
                // 将用户信息存入session
                session.setAttribute("user", user);
                System.out.println("user info added to session, user.id=" + user.getId());
                
                // 返回用户资料页面
                return "profilePage";
            } else {
                System.out.println("user login failed, email=" + email);
                model.addAttribute("error", "wrong email or password");
                return "loginPage";
            }
        } catch (Exception e) {
            System.out.println("login failed: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "login failed: " + e.getMessage());
            return "loginPage";
        }
    }
    
    /**
     * handle user register request
     */
    @PostMapping("/register")
    public String register(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        @RequestParam("firstName") String firstName,
                        @RequestParam("lastName") String lastName,
                        Model model) {
        
        System.out.println("register method called, email=" + email);
        
        try {
            // check if user already exists
            if (userService.findByEmail(email) != null) {
                System.out.println("user already exist, email=" + email);
                model.addAttribute("error", "the email has been registered");
                return "loginPage";
            }
            
            // create new user
            User user = new User();
            user.setEmail(email);
            user.setPassword(password);
            
            // set user name
            Name name = new Name();
            name.setFirstName(firstName);
            name.setLastName(lastName);
            user.setName(name);
            
            // save user
            userService.register(user);
            System.out.println("user register successfully, email=" + email);
            
            // return login page and show success message
            model.addAttribute("successMessage", "register successfully, please login");
            return "loginPage";
            
        } catch (Exception e) {
            System.out.println("register failed: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "register failed: " + e.getMessage());
            return "loginPage";
        }
    }
    
    /**
     * show user profile page
     */
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        System.out.println("=== enter showProfile method ===");
        
        // print all attributes in session
        System.out.println("Session attribute list:");
        java.util.Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
            System.out.println("  - " + name + ": " + session.getAttribute(name));
        }
        
        // check if user is logged in
        User user = (User) session.getAttribute("user");
        System.out.println("get user from session: " + (user != null ? "exist" : "not exist"));
        
        if (user == null) {
            System.out.println("user not login, return login page");
            model.addAttribute("error", "please login first");
            return "loginPage";
        }
        
        System.out.println("user login: " + user.getEmail());
        System.out.println("user id: " + user.getId());
        System.out.println("user name: " + (user.getName() != null ? user.getName().getFirstName() : "null"));
        
        // add user info to model
        model.addAttribute("user", user);
        System.out.println("user info added to model");
        
        // add some default data, may need change later
        model.addAttribute("accountBalance", "10000.00");
        model.addAttribute("userHoldings", new java.util.ArrayList<>());
        model.addAttribute("recommendedStocks", new java.util.ArrayList<>());
        
        System.out.println("prepare to return profilePage view");
        return "profilePage";
    }
    
    /**
     * handle logout request
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, Model model) {
        // invalidate session
        session.invalidate();
        model.addAttribute("successMessage", "you have successfully logged out");
        return "loginPage";
    }
} 