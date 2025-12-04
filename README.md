# 旅游景点管理系统

基于JSP + Maven + MySQL的Web应用程序开发大作业

## 项目结构

```
jsplv/
├── pom.xml                                   # Maven项目配置文件
├── README.md                                 # 项目说明文档
├── requirement-plan.md                       # 需求计划文档
├── javawebhw.md                              # 作业需求文档
├── src/
│   ├── main/
│   │   ├── java/com/tourism/
│   │   │   ├── model/                     # 实体类
│   │   │   │   ├── User.java              # 用户实体
│   │   │   │   ├── City.java              # 城市实体
│   │   │   │   └── Attraction.java        # 景点实体
│   │   │   ├── util/
│   │   │   │   ├── DBUtil.java            # 数据库工具类
│   │   │   │   └── RowMapper.java         # 结果集映射接口
│   │   │   └── servlet/                   # Servlets
│   │   ├── resources/
│   │   │   └── init-tables.sql            # 数据库初始化脚本
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml                # Web应用配置文件
│   │       ├── uploads/                   # 图片上传目录（自动生成）
│   │       ├── login.jsp                  # 用户登录页面（需创建）
│   │       ├── index.jsp                  # 城市列表主页（需创建）
│   │       ├── city_add.jsp               # 添加城市页面（需创建）
│   │       ├── city_edit.jsp              # 编辑城市页面（需创建）
│   │       ├── attraction_list.jsp        # 景点列表页面（需创建）
│   │       ├── attraction_add.jsp         # 添加景点页面（需创建）
│   │       ├── attraction_detail.jsp      # 景点详情页面（需创建）
│   │       └── image_upload.jsp           # 图片上传页面（需创建）
```

## 环境要求

- JDK 17 或更高版本
- MySQL 8.0 或更高版本
- Maven 3.6 或更高版本
- Tomcat 11.0 或更高版本（Jakarta Servlet 6.0+）
- IntelliJ IDEA 或其他Java IDE

## 环境配置步骤

### 1. 配置MySQL数据库

1. 登录MySQL（使用root账号或具有创建数据库权限的账号）：

```bash
mysql -u root -p
```

2. 创建数据库：

```sql
CREATE DATABASE tourism_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. 验证数据库创建成功：

```sql
SHOW DATABASES;
```

### 2. 导入表结构和初始数据

方法一：使用MySQL命令行

```bash
mysql -u root -p tourism_db < "d:\aiproject\jsplv\src\main\resources\init-tables.sql"
```

方法二：使用MySQL Workbench或Navicat等工具

1. 打开已创建的tourism_db数据库
2. 打开并执行`src/main/resources/init-tables.sql`文件
3. 验证数据导入成功（应看到：2个用户，5个城市，11个景点）

### 3. 修改数据库连接配置

打开文件：`src/main/java/com/tourism/util/DBUtil.java`

修改以下参数为你的MySQL配置：

```java
private static final String URL = "jdbc:mysql://localhost:3306/tourism_db?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
private static final String USERNAME = "root";      // 你的MySQL用户名
private static final String PASSWORD = "123456";    // 你的MySQL密码
```

### 4. 创建uploads目录（用于存放上传的图片）

在以下位置创建uploads文件夹：

```
src/main/webapp/uploads/
```

请确保Tomcat对该目录有写入权限。

### 5. 使用IDEA打开项目（重要）

1. 打开IntelliJ IDEA
2. 选择`File → Open`
3. 导航到`d:\aiproject\jsplv`目录
4. 选择`pom.xml`文件
5. 在弹出的对话框中选择`Open as Project`
6. 等待IDEA加载并下载依赖（可能需要几分钟）
7. IDEA会自动识别为Maven项目并下载必要的依赖包

### 6. 配置Tomcat服务器

1. 在IDEA右上角点击`Add Configuration`（或`Edit Configurations`）
2. 点击`+`号，选择`Tomcat Server → Local`
3. 配置Tomcat：
   - Name: 任意名称（如"Tourism Tomcat"）
   - Application server: 选择已安装的Tomcat目录
   - URL: `http://localhost:8080/tourism-management/`
   - JRE: 选择JDK 11或更高版本
4. 切换到"Deployment"标签页
5. 点击`+`，选择`Artifact → tourism-management:war exploded`
6. 在"Application context"中输入：`/tourism-management`
7. 点击"OK"保存配置

## 测试账号

系统预置了以下测试账号：

| 用户名 | 密码   | 说明         |
|--------|--------|--------------|
| admin  | 123456 | 管理员账号   |
| test   | test123| 普通测试账号 |

## 测试数据

### 城市数据（5个）
- 北京、上海、杭州、西安、成都

### 景点数据（11个）
- 北京：故宫博物院、八达岭长城、天坛公园
- 上海：外滩、东方明珠、豫园
- 杭州：西湖、灵隐寺
- 西安：秦始皇兵马俑、大雁塔
- 成都：都江堰、青城山

## 功能模块待实现

### 第一阶段：基础功能（已完成配置）
- [x] 项目结构搭建
- [x] Maven配置（pom.xml）
- [x] Web配置（web.xml）
- [x] 数据库配置（DBUtil.java）
- [x] 实体类创建（User, City, Attraction）
- [x] 数据库初始化脚本

### 第二阶段：用户认证
- [x] login.jsp - 用户登录页面
- [x] LoginServlet - 处理登录请求

### 第三阶段：城市管理
- [x] index.jsp - 显示所有城市
- [x] CityListServlet - 获取城市列表
- [x] city_add.jsp - 添加城市表单
- [x] CityAddServlet - 保存城市
- [x] city_edit.jsp - 编辑城市表单
- [x] CityEditPrepareServlet - 准备编辑数据
- [x] CityUpdateServlet - 更新城市
- [x] CityDeleteServlet - 删除城市

### 第四阶段：景点管理
- [x] attraction_list.jsp - 显示城市下所有景点
- [x] AttractionListServlet - 获取景点列表
- [x] attraction_add.jsp - 添加景点表单
- [x] AttractionAddServlet - 保存景点
- [x] AttractionDeleteServlet - 删除景点
- [x] attraction_detail.jsp - 显示景点详细信息
- [x] AttractionDetailServlet - 获取景点详情

### 第五阶段：图片上传
- [x] image_upload.jsp - 上传图片页面
- [x] ImageUploadServlet - 处理图片上传（使用@MultipartConfig）

## 开发注意事项

### 编码规范
- 所有JSP文件必须包含UTF-8编码设置：
  ```jsp
  <%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
  ```

- 所有Servlet必须在开头设置编码：
  ```java
  request.setCharacterEncoding("UTF-8");
  response.setContentType("text/html;charset=UTF-8");
  ```

### Servlet编码要求
按照作业要求：Servlet代码不包含import导入部分

示例：
```java
package com.tourism.servlet;

public class CityListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // 不包含import部分
        // JDBC操作必须调用DBUtil的通用方法
    }
}
```

### JDBC操作规范
- 必须使用DBUtil提供的通用方法
- 不允许直接使用Connection、PreparedStatement等
- 示例：
```java
// 查询城市列表
String sql = "SELECT * FROM cities ORDER BY id";
List<City> cityList = DBUtil.queryList(sql, rs ->
    new City(rs.getInt("id"), rs.getString("name"), rs.getString("province"))
);
```

### 文件上传注意事项
ImageUploadServlet已配置multipart-config（支持最大5MB文件）：
- 上传路径：`src/main/webapp/uploads/`
- 文件名：保持原文件名（覆盖模式）
- 文件大小限制：5MB

## 项目运行

### 方式一：使用IDEA的Tomcat插件
1. 点击右上角的运行按钮（绿色三角形）
2. 等待Tomcat启动
3. 浏览器自动打开：`http://localhost:8080/tourism-management/`

### 方式二：使用Maven命令

1. 打包项目：
```bash
mvn clean package
```

2. 生成的WAR文件位于：`target/tourism-management-1.0.0.war`

3. 将WAR文件复制到Tomcat的`webapps`目录

4. 启动Tomcat：`startup.bat`或`startup.sh`

5. 访问：`http://localhost:8080/tourism-management/`

## 常见问题

### 1. Maven依赖下载失败
- 检查网络连接
- 配置Maven镜像（settings.xml）
- 在IDEA中点击`Maven → Reload All Maven Projects`

### 2. MySQL连接失败
- 检查MySQL服务是否启动
- 验证用户名密码是否正确
- 确认数据库tourism_db已创建
- 检查防火墙设置

### 3. JSP编译错误（ClassNotFoundException）
**原因**：Tomcat版本与依赖包不匹配
**解决方案**：本项目使用Tomcat 11.0+（Jakarta EE 9+）
- 确保使用Tomcat 11.0或更高版本
- 依赖包使用`jakarta.servlet-api:6.0.0`（非javax.servlet）
- JSTL标签库URI使用`jakarta.tags.core`

### 4. 中文乱码
- 检查MySQL字符集是否为utf8mb4
- 检查JVM文件编码：`-Dfile.encoding=UTF-8`
- 检查Tomcat Connector配置：URIEncoding="UTF-8"

### 5. 文件上传失败
- 确认uploads目录已创建
- 检查目录写入权限
- 确认文件大小不超过5MB

### 6. 图片无法显示
- 检查图片是否成功上传到uploads目录
- 确认数据库中image_path字段已更新
- 检查JSP中图片路径是否正确

### 7. ticket_price类型转换错误
**原因**：Java类型与数据库类型不匹配
**解决方案**：
- 数据库：`ticket_price DECIMAL(10,2)`
- Java实体类：`private BigDecimal ticketPrice`
- ResultSet获取：`rs.getBigDecimal("ticket_price")`

## 技术支持

- 教材：《jsp实用教程》第四版（清华大学出版社）
- Java版本：11+
- Servlet版本：6.0（Jakarta EE 9+，Tomcat 11.0+）
- JSP版本：3.1
- MySQL版本：8.0+

