package com.example.controller;

import com.example.model.User;
import com.example.model.UserPreference;
import com.example.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/users")
public class UserController {

    private final UserService userService;
    
    @Autowired
    public UserController(UserService userService) {
         this.userService = userService;
    }
    
    /**
     * 用户注册
     * 使用 @ModelAttribute 自动绑定表单数据到 User 对象
     * 注册成功后将用户对象存入 session，并重定向到个人主页（profile 页面）
     */
    @PostMapping("/register")
    public String register(@ModelAttribute User user, HttpSession session, Model model) {
        try {
            // 调用 service 进行注册（此方法为 void，如果注册失败可能抛异常）
            userService.register(user);
            session.setAttribute("user", user);
            return "redirect:/profilePage.jsp"; // 成功后跳转到个人主页
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("registerError", "注册失败，请稍后再试！");
            return "loginPage"; // 返回注册登录页面
        }
    }
    
    /**
     * 用户登录
     * 登录成功后，将用户存入 session，并重定向到个人主页
     * 登录失败则返回登录页面并显示错误信息
     */
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        HttpSession session,
                        Model model) {
        User user = userService.login(email, password);
        if (user != null) {
            session.setAttribute("user", user);
            return "redirect:/profilePage.jsp";
        } else {
            model.addAttribute("loginError", "邮箱或密码错误！");
            return "loginPage";
        }
    }
    
    /**
     * 更新用户偏好（示例方法）
     * 更新成功后重定向到个人主页，更新失败返回偏好设置页面
     */
    @PutMapping("/{userId}/preference")
    public String updatePreference(@PathVariable Long userId,
                                   @ModelAttribute UserPreference preference,
                                   Model model) {
        try {
            userService.updatePreference(userId, preference);
            return "redirect:/profilePage.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("preferenceError", "更新偏好失败！");
            return "preference";  // 根据实际情况返回偏好设置页面
        }
    }
}
