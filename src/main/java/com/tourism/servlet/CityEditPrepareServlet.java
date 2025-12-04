package com.tourism.servlet;

import com.tourism.model.City;
import com.tourism.util.DBUtil;
import com.tourism.util.RowMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CityEditPrepareServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/list?error=null");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            String sql = "SELECT * FROM cities WHERE id = ?";
            City city = DBUtil.queryOne(sql, new RowMapper<City>() {
                @Override
                public City mapRow(ResultSet rs) throws SQLException {
                    return new City(rs.getInt("id"), rs.getString("name"), rs.getString("province"));
                }
            }, id);

            if (city != null) {
                request.setAttribute("city", city);
                request.getRequestDispatcher("/city_edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/city/list?error=notfound");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error=invalid");
        }
    }
}
