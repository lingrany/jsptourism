package com.tourism.servlet;

import com.tourism.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;

@MultipartConfig
public class ImageUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String attractionIdParam = request.getParameter("attractionId");
        if (attractionIdParam == null || attractionIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("景点ID不能为空！", "UTF-8"));
            return;
        }

        try {
            int attractionId = Integer.parseInt(attractionIdParam);

            // 获取上传的文件
            Part filePart = request.getPart("imageFile");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect(request.getContextPath() + "/image_upload.jsp?attractionId="
                        + attractionId + "&error=" + URLEncoder.encode("请选择要上传的图片文件！", "UTF-8"));
                return;
            }

            // 获取上传目录（web应用根目录下的uploads文件夹）
            String uploadPath = getServletContext().getRealPath("/uploads");
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 获取文件名
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            // 保存文件
            String filePath = uploadPath + java.io.File.separator + fileName;
            filePart.write(filePath);

            // 相对路径（用于数据库存储和页面访问）
            String relativePath = "uploads/" + fileName;

            // 更新数据库
            String sql = "UPDATE attractions SET image_path = ? WHERE id = ?";
            int result = DBUtil.executeUpdate(sql, relativePath, attractionId);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/attraction/detail?id="
                        + attractionId + "&msg=" + URLEncoder.encode("图片上传成功！", "UTF-8"));
            } else {
                response.sendRedirect(request.getContextPath() + "/image_upload.jsp?attractionId="
                        + attractionId + "&error=" + URLEncoder.encode("图片上传失败，请重试！", "UTF-8"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/city/list?error="
                    + URLEncoder.encode("上传失败：系统错误！", "UTF-8"));
        }
    }
}
