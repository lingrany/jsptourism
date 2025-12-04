package com.tourism.servlet;

import com.tourism.model.User;
import com.tourism.util.DBUtil;
import com.tourism.util.RowMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("用户名或密码不能为空！", "UTF-8") + "&username=" + URLEncoder.encode(username, "UTF-8"));
            return;
        }

        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        User user = DBUtil.queryOne(sql, new RowMapper<User>() {
            @Override
            public User mapRow(ResultSet rs) throws SQLException {
                return new User(rs.getInt("id"), rs.getString("username"), rs.getString("password"));
            }
        }, username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/city/list");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("用户名或密码错误！", "UTF-8") + "&username=" + URLEncoder.encode(username, "UTF-8"));
        }
    }
}
