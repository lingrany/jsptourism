package com.tourism.servlet;

import com.tourism.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class CityUpdateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String idParam = request.getParameter("id");
        String name = request.getParameter("name");
        String province = request.getParameter("province");

        if (idParam == null || name == null || province == null ||
            idParam.isEmpty() || name.trim().isEmpty() || province.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/edit/prepare?id=" + idParam + "&error="
                    + URLEncoder.encode("参数不能为空！", "UTF-8"));
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            String sql = "UPDATE cities SET name = ?, province = ? WHERE id = ?";
            int result = DBUtil.executeUpdate(sql, name.trim(), province.trim(), id);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/city/list?msg="
                        + URLEncoder.encode("城市更新成功！", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/city/edit/prepare?id=" + id + "&error="
                        + URLEncoder.encode("城市更新失败，请重试！", "UTF-8"));
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("非法的城市ID！", "UTF-8"));
        }
    }
}
