<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>旅游景点管理系统 - 上传景点图片</title>
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
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        .form-group input[type="file"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            background-color: #f9f9f9;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #757575;
            margin-top: 10px;
        }
        .btn-secondary:hover {
            background-color: #616161;
        }
        .error-message {
            color: #f44336;
            padding: 10px;
            margin-bottom: 20px;
            background-color: #ffebee;
            border-radius: 4px;
            border-left: 4px solid #f44336;
        }
        .info {
            background-color: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 20px;
            color: #1976D2;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .note {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>上传景点图片</h1>
        </div>

        <div class="info">
            <strong>提示：</strong><br>
            • 请选择JPEG、PNG或GIF格式的图片文件<br>
            • 文件大小不超过5MB<br>
            • 上传后可直接在景点详情页查看
        </div>

        <c:if test="${not empty param.error}">
            <div class="error-message">
                ${param.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/image/upload" method="post" enctype="multipart/form-data">
            <input type="hidden" name="attractionId" value="${param.attractionId}">

            <div class="form-group">
                <label for="imageFile">选择图片文件：</label>
                <input type="file" id="imageFile" name="imageFile" accept="image/*" required>
                <div class="note">支持格式：JPG, PNG, GIF（最大5MB）</div>
            </div>

            <button type="submit" class="btn">上传图片</button>
            <a href="javascript:history.back()" class="btn btn-secondary">返回</a>
        </form>
    </div>
</body>
</html>
