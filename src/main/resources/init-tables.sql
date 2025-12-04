-- 旅游景点管理系统数据库初始化脚本
-- 数据库名称: tourism_db
CREATE DATABASE tourism_db;
-- 删除旧表（如果存在）
DROP TABLE IF EXISTS attractions;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS users;

-- 创建用户表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建城市表
CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='城市表';

-- 创建景点表
CREATE TABLE attractions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    description TEXT,
    image_path VARCHAR(500),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='景点表';

-- 插入测试用户数据
INSERT INTO users (username, password) VALUES ('admin', '123456');
INSERT INTO users (username, password) VALUES ('test', 'test123');

-- 插入城市数据
INSERT INTO cities (name, province) VALUES ('北京', '北京市');
INSERT INTO cities (name, province) VALUES ('上海', '上海市');
INSERT INTO cities (name, province) VALUES ('杭州', '浙江省');
INSERT INTO cities (name, province) VALUES ('西安', '陕西省');
INSERT INTO cities (name, province) VALUES ('成都', '四川省');

-- 插入景点数据（北京）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('故宫博物院', 80.00, '明清两代的皇家宫殿，世界文化遗产', NULL, 1);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('八达岭长城', 40.00, '中国古代的军事防御工程，世界文化遗产', NULL, 1);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('天坛公园', 35.00, '明清皇帝祭天祈谷的场所', NULL, 1);

-- 插入景点数据（上海）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('外滩', 0.00, '上海的标志性景观，万国建筑博览群', NULL, 2);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('东方明珠', 120.00, '上海的地标性建筑，可登塔观光', NULL, 2);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('豫园', 40.00, '明代私家园林，江南园林代表', NULL, 2);

-- 插入景点数据（杭州）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('西湖', 0.00, '世界文化遗产，杭州标志性景点', NULL, 3);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('灵隐寺', 45.00, '杭州最早的古寺，佛教圣地', NULL, 3);

-- 插入景点数据（西安）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('秦始皇兵马俑', 120.00, '世界第八大奇迹，秦始皇陵陪葬坑', NULL, 4);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('大雁塔', 50.00, '唐代佛教建筑，西安标志', NULL, 4);

-- 插入景点数据（成都）
INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('都江堰', 80.00, '世界文化遗产，古代水利工程', NULL, 5);

INSERT INTO attractions (name, ticket_price, description, image_path, city_id)
VALUES ('青城山', 90.00, '道教名山，天下第五名山', NULL, 5);

-- 查询验证数据
SELECT '用户表数据' AS table_name, COUNT(*) AS record_count FROM users
UNION ALL
SELECT '城市表数据', COUNT(*) FROM cities
UNION ALL
SELECT '景点表数据', COUNT(*) FROM attractions;
