<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>旅游景点管理系统 - 城市列表</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4CAF50;
        }
        .header h1 {
            margin: 0;
            color: #333;
        }
        .welcome {
            color: #666;
            font-size: 14px;
        }
        .btn {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            margin: 0 5px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-danger {
            background-color: #f44336;
        }
        .btn-danger:hover {
            background-color: #d32f2f;
        }
        .btn-info {
            background-color: #2196F3;
        }
        .btn-info:hover {
            background-color: #1976D2;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            border-left: 4px solid #4CAF50;
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        .message-error {
            border-left-color: #f44336;
            background-color: #ffebee;
            color: #c62828;
        }
        .add-btn-container {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .action-links {
            white-space: nowrap;
        }
        .no-data {
            text-align: center;
            color: #666;
            padding: 50px;
            font-size: 16px;
        }
        .logout-btn {
            background-color: #ff9800;
        }
        .logout-btn:hover {
            background-color: #f57c00;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <h1>旅游景点管理系统</h1>
                <div class="welcome">
                    欢迎，${user.username}！
                </div>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/logout" class="btn logout-btn">退出登录</a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="message">
                ${message}
            </div>
        </c:if>

        <div class="add-btn-container">
            <h2>城市列表</h2>
            <a href="${pageContext.request.contextPath}/city_add.jsp" class="btn">+ 新建城市</a>
        </div>

        <c:choose>
            <c:when test="${not empty cityList and cityList.size() > 0}">
                <table>
                    <thead>
                        <tr>
                            <th>编号</th>
                            <th>城市名称</th>
                            <th>所属省份</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cityList}" var="city">
                            <tr>
                                <td>${city.id}</td>
                                <td>${city.name}</td>
                                <td>${city.province}</td>
                                <td class="action-links">
                                    <a href="${pageContext.request.contextPath}/city/edit/prepare?id=${city.id}" class="btn">编辑</a>
                                    <a href="${pageContext.request.contextPath}/city/delete?id=${city.id}" class="btn btn-danger" onclick="return confirm('确定要删除城市 ${city.name} 吗？该城市下的所有景点也会被删除！');">删除</a>
                                    <a href="${pageContext.request.contextPath}/attraction/list?cityId=${city.id}" class="btn btn-info">查看景点</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    暂无城市数据，请先添加城市。
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
