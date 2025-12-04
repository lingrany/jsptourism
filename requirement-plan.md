## 旅游景点管理系统需求计划文档

### 1. 项目概述

#### 1.1 基本信息
- **项目名称**：旅游景点管理系统
- **技术栈**：JSP + Maven + MySQL（或HSQLDB）
- **教材依据**：《jsp实用教程》清华大学出版第四版
- **开发模式**：传统Web应用（Form提交 + Servlet处理 + 结果页面显示）

#### 1.2 核心功能
系统实现用户对城市和旅游景点的管理功能，包括：
- 用户登录
- 城市管理（增删改查）
- 景点管理（增删查、上传图片）
- 景点图片管理（上传、显示）

---

### 2. 功能模块划分

#### 2.1 模块一：用户认证模块
- **登录页面** (login.jsp)：用户输入用户名和密码
- **登录Servlet** (LoginServlet)：验证用户信息，创建会话

#### 2.2 模块二：城市管理模块
- **显示所有城市** (CityListServlet → index.jsp)
  - 从数据库获取所有城市列表
  - 表格展示：编号、城市名、所属省
  - 操作链接：编辑、查看景点、新建

- **新建城市**
  - 新建城市页面 (city_add.jsp)
  - 保存城市Servlet (CityAddServlet)

- **编辑城市**
  - 获取城市信息Servlet (CityEditPrepareServlet)
  - 编辑城市页面 (city_edit.jsp)
  - 更新城市Servlet (CityUpdateServlet)

#### 2.3 模块三：景点管理模块
- **显示城市下所有景点** (AttractionListServlet → attraction_list.jsp)
  - 显示景点信息：id、名字、门票价格、简介、图片状态
  - 操作链接：上传图片、新增景点

- **新建景点**
  - 新建景点页面 (attraction_add.jsp)
  - 保存景点Servlet (AttractionAddServlet)

#### 2.4 模块四：图片管理模块
- **上传景点图片**
  - 上传图片页面 (image_upload.jsp)
  - 保存上传图片Servlet (ImageUploadServlet)

- **显示景点详细信息**
  - 获取景点详细信息Servlet (AttractionDetailServlet)
  - 显示景点详情页面 (attraction_detail.jsp)
  - 展示：id、名字、门票价格、简介、图片

#### 2.5 模块五：数据库操作模块
- **JDBC通用工具类** (DBUtil.java)
  - 数据库连接管理
  - 通用查询方法
  - 通用更新方法
- **实体类**
  - User.java
  - City.java
  - Attraction.java

---

### 3. 数据库设计

#### 3.1 MySQL数据库设计

```sql
-- 用户表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL
);

-- 城市表
CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL
);

-- 景点表
CREATE TABLE attractions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    description TEXT,
    image_path VARCHAR(500),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE
);
```

#### 3.2 HSQLDB脚本

```sql
-- 用户数据
INSERT INTO users (username, password) VALUES ('admin', '123456');

-- 城市数据
INSERT INTO cities (name, province) VALUES ('北京', '北京市');
INSERT INTO cities (name, province) VALUES ('上海', '上海市');
INSERT INTO cities (name, province) VALUES ('杭州', '浙江省');
INSERT INTO cities (name, province) VALUES ('西安', '陕西省');

-- 景点数据（示例）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('故宫', 80.00, '明清两代的皇家宫殿', NULL, 1);
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('长城', 40.00, '中国古代的军事防御工程', NULL, 1);
```

---

### 4. 技术实现细节

#### 4.1 Servlet实现清单

| 功能 | Servlet名称 | 输入 | 输出 | 跳转目标 |
|------|------------|------|------|---------|
| 用户登录 | LoginServlet | username, password | session, message | index.jsp |
| 显示所有城市 | CityListServlet | - | cityList, message | index.jsp |
| 新建城市页面 | - | - | - | city_add.jsp |
| 保存城市 | CityAddServlet | name, province | message | CityListServlet |
| 编辑城市准备 | CityEditPrepareServlet | cityId | city | city_edit.jsp |
| 更新城市 | CityUpdateServlet | cityId, name, province | message | CityListServlet |
| 显示景点列表 | AttractionListServlet | cityId | attractionList, cityId | attraction_list.jsp |
| 新建景点页面 | - | cityId | cityId | attraction_add.jsp |
| 保存景点 | AttractionAddServlet | name, price, description, cityId | message | AttractionListServlet |
| 上传图片页面 | - | attractionId | attractionId | image_upload.jsp |
| 上传图片 | ImageUploadServlet | attractionId, imageFile | message | AttractionDetailServlet |
| 显示景点详情 | AttractionDetailServlet | attractionId | attraction | attraction_detail.jsp |

#### 4.2 JSP页面清单

| 页面名称 | 主要功能 | 包含元素 |
|---------|---------|---------|
| login.jsp | 用户登录界面 | 登录表单（用户名、密码） |
| index.jsp | 城市列表主页面 | 城市表格、操作链接、消息显示 |
| city_add.jsp | 新建城市表单 | 城市名、所属省输入框 |
| city_edit.jsp | 编辑城市表单 | 城市信息回显、修改表单 |
| attraction_list.jsp | 景点列表页面 | 景点表格、上传图片链接、新增景点链接 |
| attraction_add.jsp | 新增景点表单 | 景点名称、价格、简介输入框 |
| image_upload.jsp | 图片上传页面 | 文件选择、提交按钮 |
| attraction_detail.jsp | 景点详情页 | 景点详细信息、图片展示 |

#### 4.3 公共方法清单

**DBUtil类** (通用JDBC操作类)
```java
// 获取数据库连接
public static Connection getConnection()

// 增删改操作
public static int executeUpdate(String sql, Object... params)

// 查询操作，返回单条数据
public static <T> T queryOne(String sql, RowMapper<T> mapper, Object... params)

// 查询操作，返回多条数据
public static <T> List<T> queryList(String sql, RowMapper<T> mapper, Object... params)

// 关闭资源
public static void close(ResultSet rs, Statement stmt, Connection conn)
```

**实体类**
```java
// User类：id, username, password属性
// City类：id, name, province属性
// Attraction类：id, name, ticketPrice, description, imagePath, cityId属性
```

**文件上传工具**
```java
// 保存上传的文件
public static String saveUploadFile(Part filePart, String saveDir)

// 生成文件名（不使用）
public static String generateFileName(String originalName)
```

---

### 5. 开发计划

#### 5.1 第一阶段：环境搭建（预计：1天）
- [ ] 创建Maven Web项目结构
- [ ] 配置pom.xml（Servlet、JSP、JSTL、MySQL驱动依赖）
- [ ] 配置web.xml（Servlet映射）
- [ ] 创建数据库和表结构
- [ ] 测试数据库连接

#### 5.2 第二阶段：基础功能开发（预计：2-3天）
- [ ] 创建DBUtil工具类（连接池 + 通用方法）
- [ ] 创建实体类（User, City, Attraction）
- [ ] 实现用户登录功能
- [ ] Web应用基础框架搭建

#### 5.3 第三阶段：城市管理（预计：2天）
- [ ] 实现CityListServlet和index.jsp（显示所有城市）
- [ ] 实现新建城市功能（city_add.jsp + CityAddServlet）
- [ ] 实现编辑城市功能（CityEditPrepareServlet + city_edit.jsp + CityUpdateServlet）
- [ ] 测试城市管理的增删改查

#### 5.4 第四阶段：景点管理（预计：2-3天）
- [ ] 实现AttractionListServlet和attraction_list.jsp
- [ ] 实现新建景点功能（attraction_add.jsp + AttractionAddServlet）
- [ ] 实现景点详情显示功能（AttractionDetailServlet + attraction_detail.jsp）
- [ ] 测试景点管理的增删查

#### 5.5 第五阶段：图片上传（预计：1-2天）
- [ ] 实现图片上传页面（image_upload.jsp）
- [ ] 实现ImageUploadServlet
- [ ] 配置文件上传存储路径
- [ ] 测试图片上传和显示功能

#### 5.6 第六阶段：调试完善（预计：1天）
- [ ] 整体流程测试
- [ ] 异常处理测试
- [ ] 数据完整性验证
- [ ] 添加测试数据

#### 5.7 第七阶段：提交准备（预计：0.5天）
- [ ] 打包项目（包含所有依赖）
- [ ] 导出数据库脚本和数据
- [ ] 录制功能演示视频
- [ ] 整理项目说明文档

---

### 6. 技术规范

#### 6.1 代码规范
-
- 使用通用JDBC方法，不直接写Connection、PreparedStatement
- 所有Servlet需要处理请求和响应编码（UTF-8）
- 使用request.getParameter()接收表单数据
- 使用request.setAttribute()传递数据到JSP
- 使用request.getRequestDispatcher().forward()进行转发

#### 6.2 JSP规范
- 仅使用JSP基础语法和JSTL标签库
- 不使用复杂的CSS样式，保持简洁
- 表单使用method="POST"方式提交
- 隐藏域传递ID等参数（如cityId, attractionId）
- 使用EL表达式${}显示数据
- 使用<c:if>、<c:forEach>等JSTL标签

#### 6.3 数据库规范
- 使用DBUtil提供的通用方法
- SQL语句写在Servlet中（不作为参数传入）
- 参数使用占位符?，通过params传递
- 查询城市下的景点使用JOIN查询
- 外键约束设置ON DELETE CASCADE

#### 6.4 文件上传规范
- 上传路径：Web应用根目录下的uploads文件夹
- 文件命名：保持原名（不考虑重名问题）
- 图片路径保存到数据库attractions表的image_path字段
- 图片在attraction_detail.jsp中使用<img>标签显示

---

### 7. 提交物清单

#### 7.1 项目文件
- [ ] 完整的Maven项目工程（压缩包）
- [ ] 包含所有源代码（Java、JSP、配置文件）
- [ ] 包含数据库文件或脚本

#### 7.2 数据库文件
- **MySQL用户**：
  - 创建表的SQL脚本（create_table.sql）
  - 插入测试数据的SQL脚本（insert_data.sql）
  - 或者直接提供SQL转储文件

- 

#### 7.3 文档
- [ ] 需求计划文档（本文件）
- [ ] 系统使用说明（README.md）
  - 环境要求
  - 部署步骤
  - 功能介绍
  - 测试账号

#### 7.4 视频
- [ ] 功能演示视频（mp4格式）
  - 系统登录
  - 城市管理（增删改）
  - 景点管理（增删）
  - 图片上传和显示
  - 每页操作演示，逐一介绍功能

---

### 8. 注意事项

#### 8.1 课堂要求遵守
- 仅使用《jsp实用教程》第四版讲授的知识点
- 不使用超过课堂内容的样式或布局
- 不采用异步方式（fetch、axios）
- Servlet代码不包含import部分
- JDBC操作调用通用方法完成

#### 8.2 常见陷阱
- 中文乱码问题：确保JSP、Servlet都设置UTF-8编码
- 图片上传路径问题：使用绝对路径或getRealPath()
- 外键关联删除：设置ON DELETE CASCADE
- 文件命名冲突：按作业要求不考虑重名（可覆盖或保存多份）
- 表单提交后刷新问题：使用重定向或转发避免重复提交

#### 8.3 测试账号
建议准备以下测试数据：
- 用户名：admin，密码：123456
- 至少4个城市，每个城市2-3个景点
- 至少上传1个景点的图片

---

### 9. 参考资料

- 教材：《jsp实用教程》第四版（清华大学出版社）
- Maven依赖：javax.servlet-api、jsp-api、jstl、mysql-connector-java
- HSQLDB官方文档（如果使用HSQLDB）
- Java文件上传API：Part接口（Servlet 3.0+）

---

**文档版本**：v1.0
**创建日期**：2025-12-03
**最后更新**：2025-12-03
