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

# 全局变量
JWT_TOKEN=""
USER_ID=""
DRONE_ID_1=""

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

# 函数：安全地解析JSON响应，避免JSONDecodeError
parse_json_field() {
  local json_string="$1"
  local field_path="$2" # 例如: "token" 或 "user_id" 或 "drone.id"
  # 尝试解析JSON，并检查是否有效
  echo "$json_string" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # 模拟路径解析，简化为直接获取一层字段或 drone.id
    if '$field_path' == 'token':
        print(data.get('token', ''))
    elif '$field_path' == 'user_id':
        print(data.get('user_id', ''))
    elif '$field_path' == 'drone.id':
        drone_data = data.get('drone', {})
        print(drone_data.get('id', ''))
    elif '$field_path' == 'command.id':
        command_data = data.get('command', {})
        print(command_data.get('id', ''))
    else:
        print('') # fallback
except json.JSONDecodeError:
    sys.stderr.write('JSONDecodeError: Invalid JSON response\n')
    print('')
except Exception as e:
    sys.stderr.write(f'Parsing error: {e}\n')
    print('')
" 2>/dev/null # 将stderr重定向到/dev/null以隐藏Python内部错误信息
}

# --- 1. 启动服务（保留数据） ---
print_step "1. 启动 Docker Compose 服务（不清空数据卷）"
# 不使用 --volumes，避免删除数据卷
docker compose up -d --build
if [ $? -ne 0 ]; then print_fail "Docker compose up failed."; fi

print_step "等待后端服务启动 (最多等待 60 秒)"
# 增加重试机制和响应检查
for i in $(seq 1 60); do
  BACKEND_PING_RESPONSE=$(curl -s http://localhost:$BACKEND_PORT/api/ping)
  if echo "$BACKEND_PING_RESPONSE" | grep -q "pong"; then
    print_success "后端服务已启动!"
    break
  fi
  sleep 1
  if [ $i -eq 60 ]; then
    print_fail "后端服务未能启动，请检查日志 docker compose logs backend。最后响应: $BACKEND_PING_RESPONSE"
  fi
done

# --- 2. 尝试登录或注册用户 ---
print_step "2.1 尝试登录测试用户 ${TEST_USERNAME}"
LOGIN_RESPONSE=$(curl -s -X POST \
-H "Content-Type: application/json" \
-d '{"username": "'"$TEST_USERNAME"'", "password": "'"$TEST_PASSWORD"'"}' \
http://localhost:$BACKEND_PORT/api/login)

# 使用新的解析函数
JWT_TOKEN=$(parse_json_field "$LOGIN_RESPONSE" "token")
USER_ID=$(parse_json_field "$LOGIN_RESPONSE" "user_id")

if [ -n "$JWT_TOKEN" ]; then
  print_success "用户 ${TEST_USERNAME} 已存在，登录成功，获取到 JWT Token."
else
  print_step "2.2 用户 ${TEST_USERNAME} 不存在或登录失败，尝试注册."
  REGISTER_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"username": "'"$TEST_USERNAME"'", "email": "'"$TEST_EMAIL"'", "password": "'"$TEST_PASSWORD"'"}' \
  http://localhost:$BACKEND_PORT/api/register)

  # 检查注册响应是否包含成功信息
  if echo "$REGISTER_RESPONSE" | grep -q "User registered successfully!" || echo "$REGISTER_RESPONSE" | grep -q "Username already exists"; then
    print_success "用户 ${TEST_USERNAME} 注册成功或已存在."
    # 注册成功后再次登录以获取 JWT Token
    LOGIN_RESPONSE=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    -d '{"username": "'"$TEST_USERNAME"'", "password": "'"$TEST_PASSWORD"'"}' \
    http://localhost:$BACKEND_PORT/api/login)
    JWT_TOKEN=$(parse_json_field "$LOGIN_RESPONSE" "token")
    USER_ID=$(parse_json_field "$LOGIN_RESPONSE" "user_id")

    if [ -z "$JWT_TOKEN" ]; then
      print_fail "用户 ${TEST_USERNAME} 注册成功但获取 JWT Token 失败: ${LOGIN_RESPONSE}"
    fi
  else
    print_fail "用户 ${TEST_USERNAME} 注册失败: ${REGISTER_RESPONSE}"
  fi
fi

if [ -z "$JWT_TOKEN" ]; then
  print_fail "未能获取到 JWT Token，无法进行后续操作。"
else
  print_success "JWT Token 已获取: ${JWT_TOKEN:0:30}..."
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

print_step "所有后端功能测试通过！(数据已保留)"