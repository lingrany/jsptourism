package com.tourism.servlet;

import com.tourism.model.City;
import com.tourism.model.User;
import com.tourism.util.DBUtil;
import com.tourism.util.RowMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class CityListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=" + URLEncoder.encode("请先登录！", "UTF-8"));
            return;
        }

        User user = (User) session.getAttribute("user");

        String sql = "SELECT * FROM cities ORDER BY id";
        List<City> cityList = DBUtil.queryList(sql, new RowMapper<City>() {
            @Override
            public City mapRow(ResultSet rs) throws SQLException {
                return new City(rs.getInt("id"), rs.getString("name"), rs.getString("province"));
            }
        });

        request.setAttribute("user", user);
        request.setAttribute("cityList", cityList);

        String messageParam = request.getParameter("msg");
        if (messageParam != null && !messageParam.isEmpty()) {
            try {
                String decodedMessage = URLDecoder.decode(messageParam, "UTF-8");
                request.setAttribute("message", decodedMessage);
            } catch (Exception e) {
                request.setAttribute("message", messageParam);
            }
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
