#!/bin/bash

# --- 配置区 ---
# 测试用户信息
TEST_USERNAME="testuser"
TEST_EMAIL="test@example.com"
TEST_PASSWORD="testpassword"
BACKEND_PORT=5000

# 测试无人机信息
DRONE_NAME_1="TestDroneAlpha"
DRONE_SN_1="SN-ALPHA-001"
DRONE_MODEL_1="DJI Mavic 3"
DRONE_LAT_1=34.0522
DRONE_LON_1=-118.2437

DRONE_NAME_2="TestDroneBeta"
DRONE_SN_2="SN-BETA-002"
DRONE_MODEL_2="Parrot Anafi"

# 遥测数据
TELEMETRY_LAT=34.0523
TELEMETRY_LON=-118.2438
TELEMETRY_ALT=50.0
TELEMETRY_SPEED=15.5
TELEMETRY_BATTERY=85
TELEMETRY_FLIGHT_MODE="sport"

# 指令数据
COMMAND_TYPE="goto_waypoint"
COMMAND_TARGET_LAT=34.0525
COMMAND_TARGET_LON=-118.2440
COMMAND_TARGET_ALT=100.0
# --- 配置区结束 ---

# 函数：打印彩色消息
print_step() {
  echo -e "\n\033[1;34m--- STEP: $1 ---\033[0m"
}

print_success() {
  echo -e "\033[1;32mSUCCESS: $1\033[0m"
}

print_fail() {
  echo -e "\033[1;31mFAIL: $1\033[0m"
  exit 1
}

# --- 1. 清理、构建并启动服务 ---
print_step "1. 清理现有服务和数据卷，并重新构建、启动 Docker Compose 服务"
docker compose down --volumes --remove-orphans
if [ $? -ne 0 ]; then print_fail "Docker compose down failed."; fi

docker compose up -d --build
if [ $? -ne 0 ]; then print_fail "Docker compose up failed."; fi

print_step "等待后端服务启动 (最多等待 60 秒)"
# healthcheck是为db设计的，这里我们直接ping backend
for i in $(seq 1 60); do
  response=$(curl -s http://localhost:$BACKEND_PORT/api/ping)
  if echo "$response" | grep -q "pong"; then
    print_success "后端服务已启动!"
    break
  fi
  sleep 1
  if [ $i -eq 60 ]; then
    print_fail "后端服务未能启动，请检查日志 docker compose logs backend"
  fi
done

# --- 2. 注册并登录用户 ---
print_step "2.1 注册测试用户"
REGISTER_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"username": "'"$TEST_USERNAME"'", "email": "'"$TEST_EMAIL"'", "password": "'"$TEST_PASSWORD"'"}' \
http://localhost:$BACKEND_PORT/api/register)

if echo "$REGISTER_RESPONSE" | grep -q "User registered successfully!"; then
  print_success "用户 ${TEST_USERNAME} 注册成功."
else
  print_fail "用户注册失败: ${REGISTER_RESPONSE}"
fi

print_step "2.2 登录测试用户并获取 JWT Token"
LOGIN_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"username": "'"$TEST_USERNAME"'", "password": "'"$TEST_PASSWORD"'"}' \
http://localhost:$BACKEND_PORT/api/login)

JWT_TOKEN=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token', ''))")
USER_ID=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('user_id', ''))")

if [ -n "$JWT_TOKEN" ]; then
  print_success "成功获取 JWT Token: ${JWT_TOKEN:0:30}..."
else
  print_fail "获取 JWT Token 失败: ${LOGIN_RESPONSE}"
fi

# --- 3. 测试基本路由 ---
print_step "3.1 测试根路由"
ROOT_RESPONSE=$(curl -s http://localhost:$BACKEND_PORT)
if echo "$ROOT_RESPONSE" | grep -q "Welcome to Drone Cluster Platform API!"; then
  print_success "根路由正常."
else
  print_fail "根路由测试失败: $ROOT_RESPONSE"
fi

print_step "3.2 测试 Ping 路由"
PING_RESPONSE=$(curl -s http://localhost:$BACKEND_PORT/api/ping)
if echo "$PING_RESPONSE" | grep -q "pong"; then
  print_success "Ping 路由正常."
else
  print_fail "Ping 路由测试失败: $PING_RESPONSE"
fi

print_step "3.3 测试数据库连接路由"
DB_TEST_RESPONSE=$(curl -s http://localhost:$BACKEND_PORT/api/db_test)
if echo "$DB_TEST_RESPONSE" | grep -q "Database connection successful!"; then
  print_success "数据库连接测试正常."
else
  print_fail "数据库连接测试失败: $DB_TEST_RESPONSE"
fi

# --- 4. 无人机 CRUD 测试 ---
print_step "4.1 创建无人机 (TestDroneAlpha)"
CREATE_DRONE_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $JWT_TOKEN" \
-d '{
    "name": "'"$DRONE_NAME_1"'",
    "serial_number": "'"$DRONE_SN_1"'",
    "model": "'"$DRONE_MODEL_1"'",
    "home_latitude": '"$DRONE_LAT_1"',
    "home_longitude": '"$DRONE_LON_1"'} ' \
http://localhost:$BACKEND_PORT/api/drones)

DRONE_ID_1=$(echo "$CREATE_DRONE_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('drone', {}).get('id', ''))")

if echo "$CREATE_DRONE_RESPONSE" | grep -q "Drone created successfully!" && [ -n "$DRONE_ID_1" ]; then
  print_success "无人机 ${DRONE_NAME_1} (ID: $DRONE_ID_1) 创建成功."
else
  print_fail "无人机 ${DRONE_NAME_1} 创建失败: $CREATE_DRONE_RESPONSE"
fi

print_step "4.2 获取所有无人机"
GET_ALL_DRONES_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones)

if echo "$GET_ALL_DRONES_RESPONSE" | grep -q "$DRONE_NAME_1"; then
  print_success "获取所有无人机列表成功."
else
  print_fail "获取所有无人机列表失败: $GET_ALL_DRONES_RESPONSE"
fi

print_step "4.3 获取单个无人机详情 (ID: $DRONE_ID_1)"
GET_DRONE_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1)

if echo "$GET_DRONE_RESPONSE" | grep -q "$DRONE_SN_1"; then
  print_success "获取单个无人机 ${DRONE_NAME_1} 详情成功."
else
  print_fail "获取单个无人机 ${DRONE_NAME_1} 详情失败: $GET_DRONE_RESPONSE"
fi

print_step "4.4 更新无人机信息 (ID: $DRONE_ID_1)"
UPDATE_DRONE_RESPONSE=$(curl -s -X PUT \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $JWT_TOKEN" \
-d '{"status": "maintenance", "model": "DJI Mavic Air 2"}' \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1)

if echo "$UPDATE_DRONE_RESPONSE" | grep -q "maintenance" && echo "$UPDATE_DRONE_RESPONSE" | grep -q "DJI Mavic Air 2"; then
  print_success "无人机 ${DRONE_ID_1} 信息更新成功."
else
  print_fail "无人机 ${DRONE_ID_1} 信息更新失败: $UPDATE_DRONE_RESPONSE"
fi

# --- 5. 无人机遥测数据测试 ---
print_step "5.1 上传无人机 ${DRONE_ID_1} 遥测数据"
UPLOAD_TELEMETRY_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $JWT_TOKEN" \
-d '{
    "current_latitude": '"$TELEMETRY_LAT"',
    "current_longitude": '"$TELEMETRY_LON"',
    "current_altitude": '"$TELEMETRY_ALT"',
    "speed": '"$TELEMETRY_SPEED"',
    "battery_level": '"$TELEMETRY_BATTERY"',
    "flight_mode": "'"$TELEMETRY_FLIGHT_MODE"'",
    "is_flying": true
}' \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1/telemetry)

if echo "$UPLOAD_TELEMETRY_RESPONSE" | grep -q "Telemetry updated successfully!"; then
  print_success "无人机 ${DRONE_ID_1} 遥测数据上传成功."
else
  print_fail "无人机 ${DRONE_ID_1} 遥测数据上传失败: $UPLOAD_TELEMETRY_RESPONSE"
fi

print_step "5.2 获取无人机 ${DRONE_ID_1} 最新遥测数据"
GET_TELEMETRY_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1/telemetry/latest)

if echo "$GET_TELEMETRY_RESPONSE" | grep -q "$TELEMETRY_BATTERY" && echo "$GET_TELEMETRY_RESPONSE" | grep -q "$TELEMETRY_FLIGHT_MODE"; then
  print_success "获取无人机 ${DRONE_ID_1} 最新遥测数据成功."
else
  print_fail "获取无人机 ${DRONE_ID_1} 最新遥测数据失败: $GET_TELEMETRY_RESPONSE"
fi

# --- 6. 无人机指令测试 ---
print_step "6.1 发布无人机 ${DRONE_ID_1} 控制指令"
ISSUE_COMMAND_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $JWT_TOKEN" \
-d '{
    "command_type": "'"$COMMAND_TYPE"'",
    "target_latitude": '"$COMMAND_TARGET_LAT"',
    "target_longitude": '"$COMMAND_TARGET_LON"',
    "target_altitude": '"$COMMAND_TARGET_ALT"',
    "target_speed": 10.0
}' \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1/commands)

COMMAND_ID=$(echo "$ISSUE_COMMAND_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('command', {}).get('id', ''))")

if echo "$ISSUE_COMMAND_RESPONSE" | grep -q "Command issued successfully!" && [ -n "$COMMAND_ID" ]; then
  print_success "无人机 ${DRONE_ID_1} 指令发布成功 (ID: $COMMAND_ID)."
else
  print_fail "无人机 ${DRONE_ID_1} 指令发布失败: $ISSUE_COMMAND_RESPONSE"
fi

print_step "6.2 获取无人机 ${DRONE_ID_1} 所有指令"
GET_COMMANDS_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1/commands)

if echo "$GET_COMMANDS_RESPONSE" | grep -q "$COMMAND_TYPE"; then
  print_success "获取无人机 ${DRONE_ID_1} 所有指令成功."
else
  print_fail "获取无人机 ${DRONE_ID_1} 所有指令失败: $GET_COMMANDS_RESPONSE"
fi

print_step "6.3 更新指令 ${COMMAND_ID} 状态为 completed"
UPDATE_COMMAND_STATUS_RESPONSE=$(curl -s -X PUT \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $JWT_TOKEN" \
-d '{"status": "completed", "completion_message": "Reached target waypoint."}' \
http://localhost:$BACKEND_PORT/api/commands/$COMMAND_ID/status)

if echo "$UPDATE_COMMAND_STATUS_RESPONSE" | grep -q "completed"; then
  print_success "指令 ${COMMAND_ID} 状态更新成功."
else
  print_fail "指令 ${COMMAND_ID} 状态更新失败: $UPDATE_COMMAND_STATUS_RESPONSE"
fi

# --- 7. 清理：删除无人机 ---
print_step "7.1 删除无人机 (ID: $DRONE_ID_1)"
DELETE_DRONE_RESPONSE=$(curl -s -X DELETE \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones/$DRONE_ID_1)

if echo "$DELETE_DRONE_RESPONSE" | grep -q "Drone deleted successfully!"; then
  print_success "无人机 ${DRONE_ID_1} 删除成功."
else
  print_fail "无人机 ${DRONE_ID_1} 删除失败: $DELETE_DRONE_RESPONSE"
fi

print_step "7.2 再次获取所有无人机 (应为空)"
GET_ALL_DRONES_AFTER_DELETE_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/drones)

if [ "$GET_ALL_DRONES_AFTER_DELETE_RESPONSE" = "[]" ]; then
  print_success "所有无人机列表为空，删除成功验证."
else
  print_fail "所有无人机列表不为空，删除失败验证: $GET_ALL_DRONES_AFTER_DELETE_RESPONSE"
fi

# --- 8. 受保护路由和认证失败测试 ---
print_step "8.1 测试受保护路由 (成功)"
PROTECTED_RESPONSE=$(curl -s -X GET \
-H "Authorization: Bearer $JWT_TOKEN" \
http://localhost:$BACKEND_PORT/api/protected)

if echo "$PROTECTED_RESPONSE" | grep -q "You are authorized"; then
  print_success "受保护路由访问成功."
else
  print_fail "受保护路由访问失败: $PROTECTED_RESPONSE"
fi

print_step "8.2 测试受保护路由 (无 Token)"
UNAUTHORIZED_RESPONSE=$(curl -s -X GET http://localhost:$BACKEND_PORT/api/protected)

if echo "$UNAUTHORIZED_RESPONSE" | grep -q "Token is missing!"; then
  print_success "无 Token 访问受保护路由测试成功 (返回 401)."
else
  print_fail "无 Token 访问受保护路由测试失败: $UNAUTHORIZED_RESPONSE"
fi

# 可以在这里添加更多关于 Token 过期的测试，但这需要等待一段时间或模拟过期 Token。
# 为了保持脚本的快速性，我们暂时跳过。

print_step "所有后端功能测试通过！"