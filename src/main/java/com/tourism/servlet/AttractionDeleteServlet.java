package com.tourism.servlet;

import com.tourism.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class AttractionDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        String cityIdParam = request.getParameter("cityId");

        if (idParam == null || idParam.isEmpty() || cityIdParam == null || cityIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("景点ID或城市ID不能为空！", "UTF-8"));
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            int cityId = Integer.parseInt(cityIdParam);

            String sql = "DELETE FROM attractions WHERE id = ?";
            int result = DBUtil.executeUpdate(sql, id);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/attraction/list?cityId="
                        + cityId + "&msg=" + URLEncoder.encode("景点删除成功！", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/attraction/list?cityId="
                        + cityId + "&error=" + URLEncoder.encode("景点删除失败，请重试！", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("非法的景点ID或城市ID！", "UTF-8"));
        }
    }
}
