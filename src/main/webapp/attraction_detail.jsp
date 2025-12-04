<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>旅游景点管理系统 - ${attraction.name}详情</title>
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
            max-width: 1000px;
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
        h1 {
            color: #333;
            margin: 0;
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
        .btn-secondary {
            background-color: #757575;
        }
        .btn-secondary:hover {
            background-color: #616161;
        }
        .btn-info {
            background-color: #2196F3;
        }
        .btn-info:hover {
            background-color: #1976D2;
        }
        .btn-upload {
            background-color: #FF9800;
        }
        .btn-upload:hover {
            background-color: #F57C00;
        }
        .welcome {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .attraction-info {
            margin-bottom: 30px;
        }
        .info-item {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 4px;
            border-left: 4px solid #4CAF50;
        }
        .info-label {
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }
        .info-value {
            color: #333;
            font-size: 16px;
        }
        .price-tag {
            color: #f44336;
            font-size: 24px;
            font-weight: bold;
        }
        .description {
            line-height: 1.6;
            white-space: pre-wrap;
        }
        .image-container {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        .attraction-image {
            max-width: 100%;
            max-height: 500px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .no-image {
            color: #999;
            font-style: italic;
            padding: 50px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <div class="welcome">欢迎，${user.username}！</div>
                <h1>${attraction.name}</h1>
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/attraction/list?cityId=${attraction.cityId}" class="btn btn-secondary">返回景点列表</a>
                <a href="${pageContext.request.contextPath}/city/list" class="btn btn-secondary">返回城市列表</a>
            </div>
        </div>

        <div class="attraction-info">
            <div class="info-item">
                <div class="info-label">景点编号：</div>
                <div class="info-value">${attraction.id}</div>
            </div>

            <div class="info-item">
                <div class="info-label">门票价格：</div>
                <div class="info-value price-tag">¥${attraction.ticketPrice}</div>
            </div>

            <c:if test="${not empty attraction.description}">
                <div class="info-item">
                    <div class="info-label">景点简介：</div>
                    <div class="info-value description">${attraction.description}</div>
                </div>
            </c:if>

            <div class="info-item">
                <div class="info-label">所属城市ID：</div>
                <div class="info-value">${attraction.cityId}</div>
            </div>
        </div>

        <div class="image-container">
            <c:choose>
                <c:when test="${not empty attraction.imagePath}">
                    <img src="${pageContext.request.contextPath}/${attraction.imagePath}" alt="${attraction.name}" class="attraction-image">
                    <p style="margin-top: 10px; color: #666;">景点图片</p>
                </c:when>
                <c:otherwise>
                    <div class="no-image">
                        <p>暂无图片</p>
                        <a href="${pageContext.request.contextPath}/image_upload.jsp?attractionId=${attraction.id}" class="btn btn-upload" style="margin-top: 20px;">上传图片</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div style="text-align: center; margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/image_upload.jsp?attractionId=${attraction.id}" class="btn btn-upload">上传/更换图片</a>
        </div>
    </div>
</body>
</html>
