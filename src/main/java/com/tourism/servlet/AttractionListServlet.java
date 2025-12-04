package com.tourism.servlet;

import com.tourism.model.Attraction;
import com.tourism.model.City;
import com.tourism.model.User;
import com.tourism.util.DBUtil;
import com.tourism.util.RowMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class AttractionListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error="
                    + URLEncoder.encode("请先登录！", "UTF-8"));
            return;
        }

        String cityIdParam = request.getParameter("cityId");
        if (cityIdParam == null || cityIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("城市ID不能为空！", "UTF-8"));
            return;
        }

        try {
            int cityId = Integer.parseInt(cityIdParam);

            // 查询城市信息
            String citySql = "SELECT * FROM cities WHERE id = ?";
            City city = DBUtil.queryOne(citySql, new RowMapper<City>() {
                @Override
                public City mapRow(ResultSet rs) throws SQLException {
                    return new City(rs.getInt("id"), rs.getString("name"), rs.getString("province"));
                }
            }, cityId);

            if (city == null) {
                response.sendRedirect(request.getContextPath() + "/city/list?error="
                        + URLEncoder.encode("城市不存在！", "UTF-8"));
                return;
            }

            // 查询该城市下的所有景点
            String attractionsSql = "SELECT * FROM attractions WHERE city_id = ? ORDER BY id";
            List<Attraction> attractionList = DBUtil.queryList(attractionsSql, new RowMapper<Attraction>() {
                @Override
                public Attraction mapRow(ResultSet rs) throws SQLException {
                    return new Attraction(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getBigDecimal("ticket_price"),
                        rs.getString("description"),
                        rs.getString("image_path"),
                        rs.getInt("city_id")
                    );
                }
            }, cityId);

            User user = (User) session.getAttribute("user");

            request.setAttribute("user", user);
            request.setAttribute("city", city);
            request.setAttribute("attractionList", attractionList);

            String messageParam = request.getParameter("msg");
            if (messageParam != null && !messageParam.isEmpty()) {
                request.setAttribute("message", messageParam);
            }

            request.getRequestDispatcher("/attraction_list.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("非法的城市ID！", "UTF-8"));
        }
    }
}
