package com.tourism.servlet;

import com.tourism.model.Attraction;
import com.tourism.model.User;
import com.tourism.util.DBUtil;
import com.tourism.util.RowMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AttractionDetailServlet extends HttpServlet {

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

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("景点ID不能为空！", "UTF-8"));
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            String sql = "SELECT * FROM attractions WHERE id = ?";
            Attraction attraction = DBUtil.queryOne(sql, new RowMapper<Attraction>() {
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
            }, id);

            if (attraction == null) {
                response.sendRedirect(request.getContextPath() + "/city/list?error="
                        + URLEncoder.encode("景点不存在！", "UTF-8"));
                return;
            }

            User user = (User) session.getAttribute("user");
            request.setAttribute("user", user);
            request.setAttribute("attraction", attraction);

            request.getRequestDispatcher("/attraction_detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("非法的景点ID！", "UTF-8"));
        }
    }
}
