-- 1. 用户信息表 (users)
CREATE TABLE IF NOT EXISTS users (  -- 添加 IF NOT EXISTS 防止重复创建报错
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP WITHOUT TIME ZONE
);

-- 2. 无人机基础信息表 (drones)
CREATE TABLE IF NOT EXISTS drones (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    serial_number VARCHAR(100) UNIQUE NOT NULL,
    model VARCHAR(50),
    status VARCHAR(50) DEFAULT 'offline',
    home_latitude DECIMAL(10, 8),
    home_longitude DECIMAL(11, 8),
    video_feed_url VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_config_update TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. 无人机实时遥测数据表 (drone_telemetry)
CREATE TABLE IF NOT EXISTS drone_telemetry (
    id SERIAL PRIMARY KEY,
    drone_id INTEGER NOT NULL REFERENCES drones(id) ON DELETE CASCADE,
    current_latitude DECIMAL(10, 8) NOT NULL,
    current_longitude DECIMAL(11, 8) NOT NULL,
    current_altitude DECIMAL(7, 2) DEFAULT 0.0,
    speed DECIMAL(7, 2) DEFAULT 0.0,
    battery_level INTEGER DEFAULT 100,
    flight_mode VARCHAR(50) DEFAULT 'manual',
    is_flying BOOLEAN DEFAULT FALSE,
    error_message TEXT,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 为 drone_telemetry 添加一个唯一索引，确保每架无人机只有最新的遥测记录
-- 如果表已存在，DROP INDEX IF EXISTS 和 CREATE UNIQUE INDEX 可以安全地更新索引
DROP INDEX IF EXISTS idx_drone_latest_telemetry;
CREATE UNIQUE INDEX idx_drone_latest_telemetry
ON drone_telemetry (drone_id);

-- 4. 无人机指令信息表 (commands)
CREATE TABLE IF NOT EXISTS commands (
    id SERIAL PRIMARY KEY,
    drone_id INTEGER NOT NULL REFERENCES drones(id) ON DELETE CASCADE,
    command_type VARCHAR(50) NOT NULL,
    target_latitude DECIMAL(10, 8),
    target_longitude DECIMAL(11, 8),
    target_altitude DECIMAL(7, 2),
    target_speed DECIMAL(7, 2),
    status VARCHAR(50) DEFAULT 'pending',
    issued_by INTEGER REFERENCES users(id),
    issued_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    executed_at TIMESTAMP WITHOUT TIME ZONE,
    completion_message TEXT
);

-- (可选) 5. 历史记录表
-- CREATE TABLE IF NOT EXISTS drone_telemetry_history (
--     id SERIAL PRIMARY KEY,
--     drone_id INTEGER NOT NULL REFERENCES drones(id) ON DELETE CASCADE,
--     timestamp TIMESTAMP WITHOUT TIME ZONE NOT NULL,
--     latitude DECIMAL(10, 8),
--     longitude DECIMAL(11, 8),
--     altitude DECIMAL(7, 2),
--     speed DECIMAL(7, 2),
--     battery_level INTEGER,
--     status VARCHAR(50)
-- );
-- DROP INDEX IF EXISTS idx_drone_telemetry_history_drone_id_timestamp;
-- CREATE INDEX idx_drone_telemetry_history_drone_id_timestamp
-- ON drone_telemetry_history (drone_id, timestamp DESC);

-- 插入一些初始数据 (可选，用于测试)
INSERT INTO users (username, password_hash, email, role) VALUES
('admin', 'your_hashed_admin_password', 'admin@example.com', 'admin') ON CONFLICT (username) DO NOTHING;
-- 注意：'your_hashed_admin_password' 应该是通过 BCrypt 或其他安全哈希算法处理后的密码，
-- 而不是明文密码。在实际应用中，你应该在后端注册时生成哈希。