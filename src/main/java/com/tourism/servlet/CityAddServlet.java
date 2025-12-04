package com.tourism.servlet;

import com.tourism.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class CityAddServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        String province = request.getParameter("province");

        if (name == null || province == null || name.trim().isEmpty() || province.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/add.jsp?error="
                    + URLEncoder.encode("城市名称和省份不能为空！", "UTF-8"));
            return;
        }

        String sql = "INSERT INTO cities (name, province) VALUES (?, ?)";
        int result = DBUtil.executeUpdate(sql, name.trim(), province.trim());

        if (result > 0) {
            response.sendRedirect(request.getContextPath() + "/city/list?msg="
                    + URLEncoder.encode("城市添加成功！", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/city/add.jsp?error="
                    + URLEncoder.encode("城市添加失败，请重试！", "UTF-8"));
        }
    }
}
