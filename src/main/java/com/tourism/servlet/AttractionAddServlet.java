package com.tourism.servlet;

import com.tourism.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class AttractionAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String cityIdParam = request.getParameter("cityId");
        String name = request.getParameter("name");
        String ticketPriceParam = request.getParameter("ticketPrice");
        String description = request.getParameter("description");

        if (cityIdParam == null || name == null || ticketPriceParam == null ||
            cityIdParam.isEmpty() || name.trim().isEmpty() || ticketPriceParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/attraction_add.jsp?cityId=" + cityIdParam + "&error="
                    + URLEncoder.encode("城市ID、景点名称和门票价格不能为空！", "UTF-8"));
            return;
        }

        try {
            int cityId = Integer.parseInt(cityIdParam);
            double ticketPrice = Double.parseDouble(ticketPriceParam);

            String sql = "INSERT INTO attractions (name, ticket_price, description, city_id) VALUES (?, ?, ?, ?)";
            int result = DBUtil.executeUpdate(sql, name.trim(), ticketPrice,
                    description != null ? description.trim() : "", cityId);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/attraction/list?cityId=" + cityId + "&msg="
                        + URLEncoder.encode("景点添加成功！", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/attraction_add.jsp?cityId=" + cityId + "&error="
                        + URLEncoder.encode("景点添加失败，请重试！", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("非法的城市ID或门票价格！", "UTF-8"));
        }
    }
}
