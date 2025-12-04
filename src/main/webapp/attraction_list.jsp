<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>旅游景点管理系统 - ${city.name}景点列表</title>
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
        .nav-links {
            display: flex;
            gap: 10px;
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
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-info {
            background-color: #2196F3;
        }
        .btn-info:hover {
            background-color: #1976D2;
        }
        .btn-danger {
            background-color: #f44336;
        }
        .btn-danger:hover {
            background-color: #d32f2f;
        }
        .btn-upload {
            background-color: #FF9800;
        }
        .btn-upload:hover {
            background-color: #F57C00;
        }
        .btn-secondary {
            background-color: #757575;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            border-left: 4px solid #4CAF50;
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        .add-btn-container {
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        .price-tag {
            color: #f44336;
            font-weight: bold;
        }
        .description {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .welcome {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <div class="welcome">欢迎，${user.username}！</div>
                <h1>${city.name} - 景点列表</h1>
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/city/list" class="btn btn-secondary">返回城市列表</a>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="message">
                ${message}
            </div>
        </c:if>

        <div class="add-btn-container">
            <h2>景点列表</h2>
            <div>
                <a href="${pageContext.request.contextPath}/attraction_add.jsp?cityId=${city.id}" class="btn">+ 新增景点</a>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty attractionList and attractionList.size() > 0}">
                <table>
                    <thead>
                        <tr>
                            <th>编号</th>
                            <th>景点名称</th>
                            <th>门票价格</th>
                            <th>简介</th>
                            <th>图片</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${attractionList}" var="attraction">
                            <tr>
                                <td>${attraction.id}</td>
                                <td>${attraction.name}</td>
                                <td><span class="price-tag">¥${attraction.ticketPrice}</span></td>
                                <td class="description">${attraction.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty attraction.imagePath}">
                                            <a href="${pageContext.request.contextPath}/attraction/detail?id=${attraction.id}">有图片</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/image_upload.jsp?attractionId=${attraction.id}" class="btn-upload">上传图片</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-links">
                                    <a href="${pageContext.request.contextPath}/attraction/detail?id=${attraction.id}" class="btn btn-info">详情</a>
                                    <a href="${pageContext.request.contextPath}/attraction/delete?id=${attraction.id}&cityId=${city.id}" class="btn btn-danger" onclick="return confirm('确定要删除景点 ${attraction.name} 吗？');">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-data">
                    暂无景点数据，请添加景点。
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
