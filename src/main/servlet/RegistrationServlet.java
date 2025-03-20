package com.example.servlet;

import com.example.dao.UserDao;
import com.example.dao.UserDaoImpl;
import com.example.model.User;
import com.example.model.Name;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/registerUser")
public class RegistrationServlet extends HttpServlet {
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 修改为你自己的数据库连接信息，数据库名应与 SQL 中的保持一致（例如：StockRecommender）
            Connection connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/StockRecommender?useSSL=false&serverTimezone=UTC",
                "root",
                "ZZC22137qaz"
            );
            userDao = new UserDaoImpl(connection);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new ServletException("数据库初始化失败", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // 获取注册表单数据
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String middleName = request.getParameter("middleName");
        
        // 密码一致性验证
        if (!password.equals(confirmPassword)) {
            request.setAttribute("registerError", "两次密码不一致！");
            request.getRequestDispatcher("loginRegister.jsp#register").forward(request, response);
            return;
        }
        
        // 检查用户是否已存在
        Optional<User> existingUser = userDao.findByEmail(email);
        if (existingUser.isPresent()) {
            request.setAttribute("registerError", "该邮箱已被注册！");
            request.getRequestDispatcher("webapp/loginPage.jsp").forward(request, response);
            return;
        }
        
        // 构造新用户对象
        User user = new User();
        user.setEmail(email);
        user.setPassword(password);
        
        // 构造 Name 对象并设置用户姓名
        Name name = new Name();
        name.setFirstName(firstName);
        name.setLastName(lastName);
        name.setMiddleName(middleName);
        user.setName(name);
        
        // 插入用户到数据库
        boolean success = userDao.save(user);
        if (success) {
            // 注册成功后，将用户对象存入 session，并跳转到 profile page
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect("webapp/profilePage.jsp");
        } else {
            request.setAttribute("registerError", "注册失败，请稍后再试！");
            request.getRequestDispatcher("webapp/loginPage.jsp").forward(request, response);
        }
    }
}
