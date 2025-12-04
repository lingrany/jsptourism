package com.tourism.util;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DBUtil {

    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
    private static final String USERNAME = "root";//改成你自己的数据库用户名，不变就不用改
    private static final String PASSWORD = "123456";//改成你自己的数据库密码

    static {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError("数据库驱动加载失败！");
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            setParameters(pstmt, params);

            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库更新操作失败: " + e.getMessage(), e);
        } finally {
            close(null, pstmt, conn);
        }
    }

    public static <T> T queryOne(String sql, RowMapper<T> mapper, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            setParameters(pstmt, params);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapper.mapRow(rs);
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库查询操作失败: " + e.getMessage(), e);
        } finally {
            close(rs, pstmt, conn);
        }
    }

    public static <T> List<T> queryList(String sql, RowMapper<T> mapper, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);

            setParameters(pstmt, params);

            rs = pstmt.executeQuery();
            List<T> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapper.mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("数据库查询操作失败: " + e.getMessage(), e);
        } finally {
            close(rs, pstmt, conn);
        }
    }

    private static void setParameters(PreparedStatement pstmt, Object... params) throws SQLException {
        if (params != null && params.length > 0) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
        }
    }

    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
