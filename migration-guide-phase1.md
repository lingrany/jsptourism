# 阶段一：基础加固 - 详细实施指南

本指南提供从课程作业升级到企业级应用的详细步骤，包括代码示例和最佳实践。

---

## 1. Maven多模块架构改造

### 1.1 创建模块结构

```
tourism-management/
├── tourism-common            # 公共模块（实体、工具）
├── tourism-dao               # 数据访问层
├── tourism-service           # 业务逻辑层
├── tourism-web               # Web层（Controller）
└── tourism-admin             # 管理后台（新增）
```

### 1.2 根pom.xml配置

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
        <relativePath/>
    </parent>

    <groupId>com.tourism</groupId>
    <artifactId>tourism-management</artifactId>
    <version>1.5.0</version>
    <packaging>pom</packaging>

    <modules>
        <module>tourism-common</module>
        <module>tourism-dao</module>
        <module>tourism-service</module>
        <module>tourism-web</module>
        <module>tourism-admin</module>
    </modules>

    <properties>
        <java.version>17</java.version>
        <spring-boot.version>3.2.0</spring-boot.version>
        <mysql.version>8.0.33</mysql.version>
        <mybatis-plus.version>3.5.5</mybatis-plus.version>
        <lombok.version>1.18.30</lombok.version>
        <hutool.version>5.8.23</hutool.version>
        <knife4j.version>4.3.0</knife4j.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!-- Spring Boot Starter -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
                <version>${spring-boot.version}</version>
            </dependency>

            <!-- MyBatis Plus -->
            <dependency>
                <groupId>com.baomidou</groupId>
                <artifactId>mybatis-plus-boot-starter</artifactId>
                <version>${mybatis-plus.version}</version>
            </dependency>

            <!-- MySQL Driver -->
            <dependency>
                <groupId>mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version>${mysql.version}</version>
            </dependency>

            <!-- Lombok -->
            <dependency>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
            </dependency>

            <!-- HuTool -->
            <dependency>
                <groupId>cn.hutool</groupId>
                <artifactId>hutool-all</artifactId>
                <version>${hutool.version}</version>
            </dependency>

            <!-- Knife4j (Swagger) -->
            <dependency>
                <groupId>com.github.xiaoymin</groupId>
                <artifactId>knife4j-openapi3-jakarta-spring-boot-starter</artifactId>
                <version>${knife4j.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

### 1.3 tourism-common模块pom.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.tourism</groupId>
        <artifactId>tourism-management</artifactId>
        <version>1.5.0</version>
    </parent>

    <artifactId>tourism-common</artifactId>

    <dependencies>
        <!-- Lombok -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
        </dependency>

        <!-- HuTool -->
        <dependency>
            <groupId>cn.hutool</groupId>
            <artifactId>hutool-all</artifactId>
        </dependency>
    </dependencies>
</project>
```

---

## 2. 实体类重构（使用Lombok）

### 2.1 改造后的User实体（tourism-common模块）

```java
package com.tourism.common.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

/**
 * 用户实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("users")
public class User {

    @TableId(type = IdType.AUTO)
    private Long id;

    @TableField("username")
    private String username;

    @TableField("password")
    private String password;

    @TableField("email")
    private String email;

    @TableField("phone")
    private String phone;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    @TableField("deleted")
    private Integer deleted;
}
```

### 2.2 统一管理Result响应

```java
package com.tourism.common.result;

import lombok.Data;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

/**
 * 统一响应结果
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Result<T> {

    /**
     * 响应码
     */
    private Integer code;

    /**
     * 响应消息
     */
    private String message;

    /**
     * 响应数据
     */
    private T data;

    /**
     * 时间戳
     */
    private Long timestamp;

    public static <T> Result<T> success() {
        return success(null);
    }

    public static <T> Result<T> success(T data) {
        return Result.<T>builder()
                .code(200)
                .message("SUCCESS")
                .data(data)
                .timestamp(System.currentTimeMillis())
                .build();
    }

    public static <T> Result<T> error(String message) {
        return error(500, message);
    }

    public static <T> Result<T> error(Integer code, String message) {
        return Result.<T>builder()
                .code(code)
                .message(message)
                .data(null)
                .timestamp(System.currentTimeMillis())
                .build();
    }
}
```

---

## 3. 统一异常处理

### 3.1 自定义异常类

```java
package com.tourism.common.exception;

import lombok.Getter;

/**
 * 业务异常
 */
@Getter
public class BusinessException extends RuntimeException {

    private final Integer code;

    private final String message;

    public BusinessException(String message) {
        super(message);
        this.code = 500;
        this.message = message;
    }

    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }

    public BusinessException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.code = errorCode.getCode();
        this.message = errorCode.getMessage();
    }
}
```

### 3.2 错误码枚举

```java
package com.tourism.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 错误码枚举
 */
@Getter
@AllArgsConstructor
public enum ErrorCode {

    SUCCESS(200, "操作成功"),

    PARAM_ERROR(400, "参数错误"),
    UNAUTHORIZED(401, "未登录"),
    FORBIDDEN(403, "无权限"),
    NOT_FOUND(404, "资源不存在"),

    INTERNAL_ERROR(500, "系统内部错误"),
    DATABASE_ERROR(501, "数据库操作失败"),
    FILE_UPLOAD_ERROR(502, "文件上传失败"),

    USERNAME_EXISTS(1001, "用户名已存在"),
    USER_NOT_FOUND(1002, "用户不存在"),
    PASSWORD_ERROR(1003, "密码错误"),

    CITY_NOT_FOUND(2001, "城市不存在"),
    ATTRACTION_NOT_FOUND(3001, "景点不存在");

    private final Integer code;
    private final String message;
}
```

### 3.3 全局异常处理器

```java
package com.tourism.web.handler;

import com.tourism.common.exception.BusinessException;
import com.tourism.common.exception.ErrorCode;
import com.tourism.common.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

/**
 * 全局异常处理器
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 处理业务异常
     */
    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException e) {
        log.error("业务异常：code={}, message={}", e.getCode(), e.getMessage());
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 处理参数校验异常
     */
    @ExceptionHandler(BindException.class)
    public Result<Void> handleBindException(BindException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        log.error("参数校验异常：{}", message);
        return Result.error(ErrorCode.PARAM_ERROR.getCode(), message);
    }

    /**
     * 处理系统异常
     */
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        log.error("系统异常：", e);
        return Result.error(ErrorCode.INTERNAL_ERROR.getCode(),
                          ErrorCode.INTERNAL_ERROR.getMessage());
    }
}
```

---

## 4. 日志系统改造

### 4.1 日志配置（logback-spring.xml）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 控制台输出 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%logger{50}:%line] - %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>

    <!-- 文件输出（按天滚动） -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/tourism-management.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/tourism-management.%d{yyyy-MM-dd}.%i.log</fileNamePattern>
            <maxFileSize>100MB</maxFileSize>
            <maxHistory>30</maxHistory>
            <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
        <encoder class="ch.qos.logback.classic.encoder.PatternLayoutEncoder">
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level [%logger{50}:%line] - %msg%n</pattern>
            <charset>UTF-8</charset>
        </encoder>
    </appender>

    <!-- 异步日志 -->
    <appender name="ASYNC_FILE" class="ch.qos.logback.classic.AsyncAppender">
        <appender-ref ref="FILE"/>
        <queueSize>512</queueSize>
        <discardingThreshold>0</discardingThreshold>
        <includeCallerData>true</includeCallerData>
    </appender>

    <!-- Logger配置 -->
    <logger name="com.tourism" level="DEBUG"/>
    <logger name="org.springframework" level="INFO"/>
    <logger name="org.mybatis" level="DEBUG"/>

    <!-- Root配置 -->
    <root level="INFO">
        <appender-ref ref="CONSOLE"/>
        <appender-ref ref="ASYNC_FILE"/>
    </root>
</configuration>
```

### 4.2 使用MDC记录请求上下文

```java
@Component
public class MdcFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;

        try {
            // 设置MDC变量
            MDC.put("requestId", UUID.randomUUID().toString().replace("-", ""));
            MDC.put("userId", getUserIdFromSession(req));
            MDC.put("requestUri", req.getRequestURI());

            chain.doFilter(request, response);
        } finally {
            // 清理MDC
            MDC.clear();
        }
    }

    private String getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            return String.valueOf(user.getId());
        }
        return "anonymous";
    }
}
```

---

## 5. 数据访问层改造

### 5.1 MyBatis Plus配置

#### pom.xml

```xml
dependencies>
    <!-- MyBatis Plus -->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-boot-starter</artifactId>
    </dependency>

    <!-- MySQL -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>

    <!-- Druid连接池 -->
    <dependency>
        <groupId>com.alibaba</groupId>
        <artifactId>druid-spring-boot-starter</artifactId>
        <version>1.2.20</version>
    </dependency>
</dependencies>
```

#### application.yml配置

```yaml
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    druid:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://localhost:3306/tourism_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC
      username: root
      password: your_password
      # Druid连接池配置
      initial-size: 10
      min-idle: 10
      max-active: 100
      max-wait: 60000
      time-between-eviction-runs-millis: 60000
      min-evictable-idle-time-millis: 300000

mybatis-plus:
  # Mapper XML文件位置
  mapper-locations: classpath*:/mapper/**/*.xml
  # 实体类包名
  type-aliases-package: com.tourism.common.entity
  configuration:
    # 打印SQL日志
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
    # 开启下划线转驼峰
    map-underscore-to-camel-case: true
  global-config:
    db-config:
      # 主键策略
      id-type: auto
      # 逻辑删除
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0
```

### 5.2 Mapper接口改造

```java
package com.tourism.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.tourism.common.entity.City;
import org.apache.ibatis.annotations.Mapper;

/**
 * 城市Mapper
 */
@Mapper
public interface CityMapper extends BaseMapper<City> {

    // 自定义查询可以在这里扩展
    // MyBatis Plus已经提供了基本的CRUD方法
}
```

### 5.3 分页查询示例

```java
@Service
public class CityService {

    @Autowired
    private CityMapper cityMapper;

    /**
     * 分页查询城市列表
     */
    public PageResult<City> getCityList(Integer page, Integer pageSize) {
        // 创建分页对象
        Page<City> cityPage = new Page<>(page, pageSize);

        // 执行查询
        cityMapper.selectPage(cityPage, null);

        // 返回分页结果
        return PageResult.<City>builder()
                .list(cityPage.getRecords())
                .total(cityPage.getTotal())
                .page(page)
                .pageSize(pageSize)
                .build();
    }
}
```

---

## 6. 安全配置增强（PasswordEncoder）

```java
@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // 使用BCrypt加密
        return new BCryptPasswordEncoder();
    }
}

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * 用户注册
     */
    public void register(String username, String password) {
        // 密码加密
        String encodedPassword = passwordEncoder.encode(password);

        User user = User.builder()
                .username(username)
                .password(encodedPassword)
                .build();

        userMapper.insert(user);
    }

    /**
     * 用户登录验证
     */
    public boolean login(String username, String rawPassword) {
        // 查询用户信息
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username);
        User user = userMapper.selectOne(wrapper);

        if (user == null) {
            return false;
        }

        // 验证密码
        return passwordEncoder.matches(rawPassword, user.getPassword());
    }
}
```

---

## 7. 文件上传改造

### 7.1 配置application.yml

```yaml
spring:
  servlet:
    multipart:
      enabled: true
      max-file-size: 5MB
      max-request-size: 10MB
      file-size-threshold: 0

# 文件上传路径
tourism:
  upload:
    path: /opt/tourism/uploads/
    url-prefix: /uploads/
```

### 7.2 文件上传Service

```java
@Service
public class FileUploadService {

    @Value("${tourism.upload.path}")
    private String uploadPath;

    @Value("${tourism.upload.url-prefix}")
    private String urlPrefix;

    /**
     * 上传图片
     */
    public UploadResult uploadImage(MultipartFile file) throws IOException {
        // 1. 校验文件
        validateImage(file);

        // 2. 生成文件名
        String originalFilename = file.getOriginalFilename();
        String extension = FileUtil.extName(originalFilename);
        String fileName = IdUtil.fastSimpleUUID() + "." + extension;

        // 3. 创建目录（按日期分片）
        String datePath = DateUtil.format(new Date(), "yyyy/MM/dd");
        File saveDir = new File(uploadPath + datePath);
        if (!saveDir.exists()) {
            saveDir.mkdirs();
        }

        // 4. 保存文件
        File saveFile = new File(saveDir, fileName);
        file.transferTo(saveFile);

        // 5. 返回结果
        String relativePath = datePath + "/" + fileName;
        String fullUrl = urlPrefix + relativePath;

        return UploadResult.builder()
                .fileName(originalFilename)
                .savedName(fileName)
                .filePath(relativePath)
                .fileUrl(fullUrl)
                .fileSize(file.getSize())
                .build();
    }

    /**
     * 校验图片文件
     */
    private void validateImage(MultipartFile file) throws BusinessException {
        if (file == null || file.isEmpty()) {
            throw new BusinessException("文件不能为空");
        }

        // 文件大小限制
        if (file.getSize() > 5 * 1024 * 1024) {
            throw new BusinessException("文件大小不能超过5MB");
        }

        // 文件类型验证
        String contentType = file.getContentType();
        if (!StrUtil.startWithAny(contentType, "image/")) {
            throw new BusinessException("只能上传图片文件");
        }

        // 扩展名白名单
        String originalFilename = file.getOriginalFilename();
        String extension = FileUtil.extName(originalFilename).toLowerCase();
        if (!ArrayUtil.contains(new String[]{"jpg", "jpeg", "png", "gif", "webp"}, extension)) {
            throw new BusinessException("不支持的文件格式");
        }
    }
}
```

---

## 8. 单元测试编写

### 8.1 Service层测试

```java
@SpringBootTest
class UserServiceTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserMapper userMapper;

    @Test
    @DisplayName("测试用户注册")
    void testRegister() {
        // 准备数据
        String username = "test_user" + System.currentTimeMillis();
        String password = "123456";

        // 执行
        userService.register(username, password);

        // 验证
        User user = userMapper.selectOne(
            Wrappers.<User>lambdaQuery().eq(User::getUsername, username)
        );
        assertNotNull(user);
        assertTrue(passwordEncoder.matches(password, user.getPassword()));
    }

    @Test
    @DisplayName("测试用户名重复注册")
    void testDuplicateUsername() {
        String username = "duplicate_user";
        userService.register(username, "123456");

        // 期望抛出BusinessException
        BusinessException exception = assertThrows(
            BusinessException.class,
            () -> userService.register(username, "123456")
        );
        assertEquals("用户名已存在", exception.getMessage());
    }
}
```

### 8.2 Controller层测试

```java
@AutoConfigureMockMvc
@SpringBootTest
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @DisplayName("测试登录接口")
    void testLogin() throws Exception {
        LoginRequest request = new LoginRequest();
        request.setUsername("admin");
        request.setPassword("123456");

        MvcResult result = mockMvc.perform(post("/api/v1/users/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.code").value(200))
                .andReturn();
    }
}
```

---

## 9. 配置分离

### 9.1 多环境配置

```
src/main/resources/
├── application.yml          # 默认配置
├── application-dev.yml      # 开发环境
├── application-test.yml     # 测试环境
├── application-prod.yml     # 生产环境
└── application-docker.yml   # Docker环境
```

**application-dev.yml**:

```yaml
spring:
  datasource:
    druid:
      url: jdbc:mysql://localhost:3306/tourism_db_dev
      username: root
      password: dev_password

logging:
  level:
    com.tourism: DEBUG

server:
  port: 8080

# 开发环境配置
myapp:
  upload:
    path: /Users/username/tourism/uploads/
    max-file-size: 5MB
```

**application-prod.yml**:

```yaml
spring:
  datasource:
    druid:
      url: jdbc:mysql://prod-db-server:3306/tourism_db
      username: ${DB_USERNAME}
      password: ${DB_PASSWORD}

logging:
  level:
    com.tourism: INFO
  file:
    name: /opt/tourism/logs/tourism-management.log

server:
  port: 8080

# 生产环境配置
myapp:
  upload:
    path: /opt/tourism/uploads/
    max-file-size: 10MB
```

### 9.2 启动时指定环境

```bash
# 开发环境
java -jar tourism-web.jar --spring.profiles.active=dev

# 生产环境
java -jar tourism-web.jar --spring.profiles.active=prod
```

---

## 10. Docker化（可选）

### 10.1 Dockerfile

```dockerfile
# 基础镜像
FROM openjdk:17-jdk-slim

# 维护者
LABEL maintainer="lingrany@example.com"

# 设置工作目录
WORKDIR /app

# 复制jar包
COPY target/tourism-web-1.5.0.jar app.jar

# 暴露端口
EXPOSE 8080

# 挂载卷（日志和上传文件）
VOLUME ["/app/logs", "/app/uploads"]

# 启动命令
ENTRYPOINT ["java", "-jar", "-Xmx1g", "-Xms1g", "app.jar"]
```

### 10.2 docker-compose.yml

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: tourism-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: tourism_db
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d

  redis:
    image: redis:7-alpine
    container_name: tourism-redis
    ports:
      - "6379:6379"

  tourism-app:
    build: .
    container_name: tourism-app
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: docker
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/tourism_db
      SPRING_REDIS_HOST: redis
    depends_on:
      - mysql
      - redis
    volumes:
      - ./logs:/app/logs
      - ./uploads:/app/uploads

volumes:
  mysql-data:
```

---

## 11. 完成状态检查清单

### 代码质量
- [ ] Lombok集成完成
- [ ] MyBatis Plus配置完成
- [ ] 统一异常处理完成
- [ ] 统一响应格式完成
- [ ] 日志框架配置完成
- [ ] 密码加密完成
- [ ] 文件上传改造完成
- [ ] 单元测试覆盖 > 80%

### 架构升级
- [ ] 多模块Maven项目创建完成
- [ ] 代码分层清晰
- [ ] 配置分离完成（多环境）
- [ ] Docker支持完成

### 文档
- [ ] README.md已更新
- [ ] API文档（Swagger）已生成
- [ ] 数据库设计文档已更新
- [ ] 部署文档已编写

---

**阶段一总结**：完成以上改造后，系统将具备企业级应用的基本骨架，代码质量、安全性、可维护性都将大幅提升。此时可以进行全面测试，然后进入阶段二（Spring Boot + Vue前后端分离）。

**下一步**：阅读《migration-guide-phase2.md》了解前后端分离改造。
