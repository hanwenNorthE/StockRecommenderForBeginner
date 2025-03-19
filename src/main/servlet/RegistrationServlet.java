@WebServlet("/registerUser")
public class RegistrationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // 1. 获取注册表单数据
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. 验证两次密码是否一致
        if (!password.equals(confirmPassword)) {
            request.setAttribute("registerError", "两次密码不一致！");
            request.getRequestDispatcher("loginRegister.jsp#register").forward(request, response);
            return;
        }

        // 3. 检查用户是否已存在
        if (userDao.findByEmail(email) != null) {
            request.setAttribute("registerError", "该邮箱已被注册！");
            request.getRequestDispatcher("loginRegister.jsp#register").forward(request, response);
            return;
        }

        // 4. 创建新用户并保存
        User user = new User();
        user.setEmail(email);
        user.setPassword(password);
        boolean success = userDao.save(user);

        if (success) {
            // 注册成功后，将用户存入 session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // 跳转到个人主页
            response.sendRedirect("webapp/profilePage.jsp");
        } else {
            request.setAttribute("registerError", "注册失败，请稍后再试！");
            request.getRequestDispatcher("loginRegister.jsp#register").forward(request, response);
        }
    }
}
