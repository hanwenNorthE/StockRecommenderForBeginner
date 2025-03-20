package com.example.servlet;

import com.example.dao.UserDao;
import com.example.dao.UserDaoImpl;
import com.example.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet("/loginUser")
public class LoginServlet extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/StockRecommender?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
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
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 根据 UserDao 接口，使用 Optional 判断用户是否存在
        Optional<User> optionalUser = userDao.findByEmailAndPassword(email, password);
        if (optionalUser.isPresent()) {
            // 登录成功，将用户对象存入 session
            User user = optionalUser.get();
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // 重定向到个人主页，这里的路径根据实际 JSP 文件位置来调整
            response.sendRedirect("profilePage.jsp");
        } else {
            // 登录失败，设置错误信息并回到登录页面
            request.setAttribute("loginError", "邮箱或密码错误！");
            request.getRequestDispatcher("loginPage.jsp").forward(request, response);
        }
    }
}
