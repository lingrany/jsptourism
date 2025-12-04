<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>旅游景点管理系统 - 编辑城市</title>
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
            max-width: 800px;
            margin: 20px auto;
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
        .form-group input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group input[type="text"]:focus {
            border-color: #4CAF50;
            outline: none;
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
        .btn-secondary {
            background-color: #757575;
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
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4CAF50;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>编辑城市</h1>
            <a href="${pageContext.request.contextPath}/city/list" class="btn">返回列表</a>
        </div>

        <c:if test="${not empty param.error}">
            <div class="error-message">
                ${param.error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/city/update" method="post">
            <input type="hidden" name="id" value="${city.id}">

            <div class="form-group">
                <label for="name">城市名称：</label>
                <input type="text" id="name" name="name" value="${city.name}" required autofocus>
            </div>

            <div class="form-group">
                <label for="province">所属省份：</label>
                <input type="text" id="province" name="province" value="${city.province}" required>
            </div>

            <button type="submit" class="btn">保存修改</button>
            <a href="${pageContext.request.contextPath}/city/list" class="btn btn-secondary">取消</a>
        </form>
    </div>
</body>
</html>
