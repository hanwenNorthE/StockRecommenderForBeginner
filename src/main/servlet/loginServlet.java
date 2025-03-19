@WebServlet("/loginUser")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 假设通过某种方式验证用户，如 userDao.findByEmailAndPassword(...)
        User user = userDao.findByEmailAndPassword(email, password);

        if (user != null) {
            // 登录成功，将用户对象存入 session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            // 重定向到个人主页
            response.sendRedirect("webapp/profilePage.jsp");
        } else {
            // 登录失败，设置错误信息并回到登录Tab
            request.setAttribute("loginError", "邮箱或密码错误！");
            request.getRequestDispatcher("loginRegister.jsp#login").forward(request, response);
        }
    }
}
