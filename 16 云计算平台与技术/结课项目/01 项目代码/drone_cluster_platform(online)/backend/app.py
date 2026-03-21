# backend/app.py (更新后的完整内容，替换你现有 app.py 的所有内容)

import os
import datetime
import jwt
from functools import wraps
import random
from apscheduler.schedulers.background import BackgroundScheduler

from flask import Flask, jsonify, request # 导入 request
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash # 用于密码哈希
from sqlalchemy import text # 用于 db_test 中执行原始 SQL 语句
from sqlalchemy.exc import IntegrityError # 用于处理数据库完整性错误

from config import Config # 导入配置模块


# --------------------------------------------------------------------------------
# 初始化 Flask 应用
# --------------------------------------------------------------------------------
app = Flask(__name__)
app.config.from_object(Config) # 从 config.py 加载配置

# 初始化 SQLAlchemy 数据库连接
db = SQLAlchemy(app)

# --------------------------------------------------------------------------------
# 数据库模型定义 (与 init.sql 保持一致以进行映射)
# --------------------------------------------------------------------------------
class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(100), unique=True)
    role = db.Column(db.String(20), default='user')
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    last_login_at = db.Column(db.DateTime)

    # 定义与 Commands 的一对多关系
    commands = db.relationship('Command', backref='issuer', lazy='dynamic')

    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'role': self.role,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_login_at': self.last_login_at.isoformat() if self.last_login_at else None
        }

    def __repr__(self):
        return f'<User {self.username}>'

class Drone(db.Model):
    __tablename__ = 'drones'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), unique=True, nullable=False)
    serial_number = db.Column(db.String(100), unique=True, nullable=False)
    model = db.Column(db.String(50))
    status = db.Column(db.String(50), default='offline')
    home_latitude = db.Column(db.Numeric(10, 8))
    home_longitude = db.Column(db.Numeric(11, 8))
    video_feed_url = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.datetime.now)
    last_config_update = db.Column(db.DateTime, default=datetime.datetime.now)

    # 定义与 DroneTelemetry 和 Commands 的关系
    # 'uselist=False' 表示这对关系返回的是单条记录，而不是列表
    # 'primaryjoin' 明确了 JOIN 条件，确保获取的是最新的 telemetry (因为 drone_id 是 unique 的)
    telemetry = db.relationship('DroneTelemetry', backref='drone', lazy=True, uselist=False,
                                primaryjoin="Drone.id==DroneTelemetry.drone_id")
    commands = db.relationship('Command', backref='drone', lazy='dynamic')

    def to_dict(self, include_telemetry=False):
        data = {
            'id': self.id,
            'name': self.name,
            'serial_number': self.serial_number,
            'model': self.model,
            'status': self.status,
            'home_latitude': str(self.home_latitude) if self.home_latitude else None,
            'home_longitude': str(self.home_longitude) if self.home_longitude else None,
            'video_feed_url': self.video_feed_url,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'last_config_update': self.last_config_update.isoformat() if self.last_config_update else None
        }
        if include_telemetry and self.telemetry:
            data['latest_telemetry'] = self.telemetry.to_dict()
        else:
            data['latest_telemetry'] = None
        return data

    def __repr__(self):
        return f'<Drone {self.name}>'

class DroneTelemetry(db.Model):
    __tablename__ = 'drone_telemetry'
    id = db.Column(db.Integer, primary_key=True)
    drone_id = db.Column(db.Integer, db.ForeignKey('drones.id'), nullable=False, unique=True, index=True) # unique=True 确保每架无人机只有最新的遥测记录
    current_latitude = db.Column(db.Numeric(10, 8), nullable=False)
    current_longitude = db.Column(db.Numeric(11, 8), nullable=False)
    current_altitude = db.Column(db.Numeric(7, 2), default=0.0)
    speed = db.Column(db.Numeric(7, 2), default=0.0)
    battery_level = db.Column(db.Integer, default=100)
    flight_mode = db.Column(db.String(50), default='manual')
    is_flying = db.Column(db.Boolean, default=False)
    error_message = db.Column(db.Text)
    updated_at = db.Column(db.DateTime, default=datetime.datetime.now, onupdate=datetime.datetime.now)

    def to_dict(self):
        return {
            'id': self.id,
            'drone_id': self.drone_id,
            'current_latitude': str(self.current_latitude),
            'current_longitude': str(self.current_longitude),
            'current_altitude': str(self.current_altitude),
            'speed': str(self.speed),
            'battery_level': self.battery_level,
            'flight_mode': self.flight_mode,
            'is_flying': self.is_flying,
            'error_message': self.error_message,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }

    def __repr__(self):
        return f'<DroneTelemetry drone_id={self.drone_id}>'

class Command(db.Model):
    __tablename__ = 'commands'
    id = db.Column(db.Integer, primary_key=True)
    drone_id = db.Column(db.Integer, db.ForeignKey('drones.id'), nullable=False, index=True)
    command_type = db.Column(db.String(50), nullable=False)
    target_latitude = db.Column(db.Numeric(10, 8))
    target_longitude = db.Column(db.Numeric(11, 8))
    target_altitude = db.Column(db.Numeric(7, 2))
    target_speed = db.Column(db.Numeric(7, 2))
    status = db.Column(db.String(50), default='pending') # pending, sent, acknowledged, executing, completed, failed
    issued_by = db.Column(db.Integer, db.ForeignKey('users.id'))
    issued_at = db.Column(db.DateTime, default=datetime.datetime.now)
    executed_at = db.Column(db.DateTime)
    completion_message = db.Column(db.Text)

    def to_dict(self, include_issuer=False):
        data = {
            'id': self.id,
            'drone_id': self.drone_id,
            'command_type': self.command_type,
            'target_latitude': str(self.target_latitude) if self.target_latitude else None,
            'target_longitude': str(self.target_longitude) if self.target_longitude else None,
            'target_altitude': str(self.target_altitude) if self.target_altitude else None,
            'target_speed': str(self.target_speed) if self.target_speed else None,
            'status': self.status,
            'issued_by': self.issued_by,
            'issued_at': self.issued_at.isoformat() if self.issued_at else None,
            'executed_at': self.executed_at.isoformat() if self.executed_at else None,
            'completion_message': self.completion_message
        }
        if include_issuer and self.issuer: # issuer 是通过 backref 关系得到的 User 对象
            data['issuer_username'] = self.issuer.username
        return data

    def __repr__(self):
        return f'<Command {self.command_type} for Drone {self.drone_id}>'

# --------------------------------------------------------------------------------
# JWT 认证辅助函数
# --------------------------------------------------------------------------------

def token_required(f):
    """
    一个装饰器，用于保护需要认证的 API 路由。
    它检查请求头中的 'x-access-token' 或 'Authorization: Bearer <token>'。
    如果 token 有效，它会将当前用户对象作为第一个参数传递给被装饰的视图函数。
    """
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if 'x-access-token' in request.headers:
            token = request.headers['x-access-token']
        elif 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            if auth_header and auth_header.startswith('Bearer '):
                token = auth_header.split(' ')[1]

        if not token:
            app.logger.warning("Token is missing in request headers.")
            return jsonify({'message': 'Token is missing!'}), 401
        
        try:
            # 解码 JWT token
            data = jwt.decode(token, app.config['JWT_SECRET_KEY'], algorithms=["HS256"])
            current_user = User.query.filter_by(id=data['user_id']).first()
            if not current_user:
                app.logger.warning(f"User with ID {data['user_id']} not found.")
                return jsonify({'message': 'User not found!'}), 401
        except jwt.ExpiredSignatureError:
            app.logger.warning("Token has expired.")
            return jsonify({'message': 'Token has expired!'}), 401
        except jwt.InvalidTokenError:
            app.logger.warning("Token is invalid.")
            return jsonify({'message': 'Token is invalid!'}), 401
        except Exception as e:
            app.logger.error(f"Error decoding token: {e}")
            return jsonify({'message': f'An error occurred: {e}'}), 500

        return f(current_user, *args, **kwargs)
    return decorated


in_memory_simulated_positions = {}

def get_initial_or_saved_telemetry_data(drone_id):
    """
    尝试从数据库获取无人机最新的遥测数据作为初始内存状态。
    如果数据库中不存在，则生成一个初始状态。
    此函数仅在初始化时（before_first_request 钩子中）由主线程调用，
    或者在模拟函数中（后台线程）调用，所以内部需要 app.app_context。
    """
    telemetry = DroneTelemetry.query.filter_by(drone_id=drone_id).first()
    if telemetry:
        return {
            'current_longitude': float(telemetry.current_longitude),
            'current_latitude': float(telemetry.current_latitude),
            'current_altitude': float(telemetry.current_altitude),
            'speed': float(telemetry.speed),
            'battery_level': telemetry.battery_level,
            'flight_mode': telemetry.flight_mode,
            'is_flying': telemetry.is_flying,
            'error_message': telemetry.error_message,
        }
    else:
        return {
            'current_longitude': round(random.uniform(120.5, 121.5), 8),
            'current_latitude': round(random.uniform(30.8, 31.8), 8),
            'current_altitude': round(random.uniform(20.0, 100.0), 2),
            'speed': round(random.uniform(1.0, 5.0), 2),
            'battery_level': 100,
            'flight_mode': 'auto',
            'is_flying': True,
            'error_message': None,
        }

def simulate_drone_movement():
    """
    模拟所有无人机的运动，并更新它们的遥测数据。
    在一个后台线程中运行，所以需要手动推入应用上下文。
    """
    with app.app_context(): # 必须在应用上下文中使用 SQLAlchemy
        drones = Drone.query.all()
        for drone in drones:
            drone_id = drone.id

            # 如果内存中没有该无人机的模拟状态，则从DB加载或生成
            # 注意：在 simulate_drone_movement 中再次调用 get_initial_or_saved_telemetry_data 
            # 意味着它会再次创建应用上下文，但通常 это是可以接受的。
            # 更严格的做法是确保 in_memory_simulated_positions 在调度器启动时就完全初始化。
            if drone_id not in in_memory_simulated_positions:
                app.logger.warning(f"Drone {drone_id} not found in in_memory_simulated_positions. Initializing from DB/default...")
                in_memory_simulated_positions[drone_id] = get_initial_or_saved_telemetry_data(drone_id)

            current_simulated_state = in_memory_simulated_positions[drone_id]

            # --- 模拟运动和状态变化 ---
            current_simulated_state['current_longitude'] += round(random.uniform(-0.00005, 0.00005), 8)
            current_simulated_state['current_latitude'] += round(random.uniform(-0.00005, 0.00005), 8)
            
            # 飞行中的高度和速度变化
            if current_simulated_state['is_flying']:
                current_simulated_state['current_altitude'] += round(random.uniform(-0.5, 0.5), 2)
                current_simulated_state['speed'] = round(random.uniform(0.5, 7.0), 2)
            else: # 降落状态下
                current_simulated_state['current_altitude'] = 0.0
                current_simulated_state['speed'] = 0.0

            # 限制高度在 0-200m 之间
            current_simulated_state['current_altitude'] = max(0.0, min(200.0, current_simulated_state['current_altitude']))
            
            # 模拟电池消耗
            current_simulated_state['battery_level'] -= random.randint(1, 2) # 每次模拟消耗 1-2%
            current_simulated_state['battery_level'] = max(0, current_simulated_state['battery_level'])

            # 根据电池电量和随机事件改变飞行状态
            if current_simulated_state['battery_level'] == 0 and current_simulated_state['is_flying']:
                current_simulated_state['is_flying'] = False
                current_simulated_state['flight_mode'] = 'landed'
                current_simulated_state['error_message'] = "Battery drained, forced landing."
            elif not current_simulated_state['is_flying'] and random.random() < 0.1 and current_simulated_state['battery_level'] > 10: # 10% 机会重新起飞
                current_simulated_state['is_flying'] = True
                current_simulated_state['flight_mode'] = random.choice(['auto', 'manual', 'mission'])
                current_simulated_state['error_message'] = None
            elif current_simulated_state['is_flying'] and random.random() < 0.02: # 小概率随机降落
                current_simulated_state['is_flying'] = False
                current_simulated_state['flight_mode'] = 'landed'
                current_simulated_state['error_message'] = "Random landing initiated."
            elif current_simulated_state['is_flying'] and random.random() < 0.01: # 小概率发生错误
                current_simulated_state['error_message'] = random.choice(["GPS Signal Lost", "Motor Malfunction", "Communication Error"])
            
            # --- 更新或创建 DroneTelemetry 记录 ---
            telemetry_record = DroneTelemetry.query.filter_by(drone_id=drone_id).first()
            if not telemetry_record:
                telemetry_record = DroneTelemetry(drone_id=drone_id)
                db.session.add(telemetry_record)
            
            telemetry_record.current_latitude = current_simulated_state['current_latitude']
            telemetry_record.current_longitude = current_simulated_state['current_longitude']
            telemetry_record.current_altitude = current_simulated_state['current_altitude']
            telemetry_record.speed = current_simulated_state['speed']
            telemetry_record.battery_level = current_simulated_state['battery_level']
            telemetry_record.flight_mode = current_simulated_state['flight_mode']
            telemetry_record.is_flying = current_simulated_state['is_flying']
            telemetry_record.error_message = current_simulated_state['error_message']

        try:
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            app.logger.error(f"Error saving simulated telemetry data: {e}")

# 初始化调度器
scheduler = BackgroundScheduler()

# 启动调度器和初始化数据的函数
def _start_scheduler_and_init_data():
    """
    在 Flask 应用的第一个请求处理前调用此函数。
    负责初始化数据库，加载无人机模拟状态，并启动调度器。
    """
    with app.app_context(): # 必须在应用上下文中使用 SQLAlchemy
        # db.create_all() # 在 Gunicorn 环境下通常不在这里调用，而是通过 migrate 或单独脚本执行
                            # 如果你需要确保表存在，可以在这里执行，但注意可能在生产环境中造成竞争条件。

        # 确保日志记录器可用
        if not app.logger.handlers:
            import logging
            logging.basicConfig(level=logging.INFO)
            app.logger.addHandler(logging.StreamHandler())

        app.logger.info("Initializing drone telemetry data and starting scheduler...")

        # 确保为所有 Drone 对象在 DroneTelemetry 表中创建或更新记录，并初始化内存中的模拟状态
        drones = Drone.query.all()
        if not drones:
            app.logger.warning("No drones found in the database. Simulation will not start until drones are added.")

        for drone in drones:
            # 从 DB 获取或生成初始模拟状态
            initial_state = get_initial_or_saved_telemetry_data(drone.id)
            in_memory_simulated_positions[drone.id] = initial_state # 存储到内存

            # 检查数据库中是否存在对应的遥测记录，如果不存在则创建
            telemetry_record = DroneTelemetry.query.filter_by(drone_id=drone.id).first()
            if not telemetry_record:
                telemetry_record = DroneTelemetry(
                    drone_id=drone.id,
                    current_latitude=initial_state['current_latitude'],
                    current_longitude=initial_state['current_longitude'],
                    current_altitude=initial_state['current_altitude'],
                    speed=initial_state['speed'],
                    battery_level=initial_state['battery_level'],
                    flight_mode=initial_state['flight_mode'],
                    is_flying=initial_state['is_flying'],
                    error_message=initial_state['error_message']
                )
                db.session.add(telemetry_record)
            else:
                # 如果记录已存在，也可以根据需要更新其值，但模拟器会持续更新
                # 主要是确保记录存在，避免 simulate_drone_movement 第一次运行时因找不到而报错
                pass

        try:
            db.session.commit()
            app.logger.info("Initialized or ensured DroneTelemetry records for existing drones in DB and memory.")
        except Exception as e:
            db.session.rollback()
            app.logger.error(f"Error during initial DroneTelemetry DB setup: {e}")

    # 仅在调度器未运行时才启动，防止 Flask-reloader 模式下重复启动
    # 在 Gunicorn 这样多进程的环境中，每个 worker 进程都会执行 before_first_request，
    # 但 BackgroundScheduler 应该只在一个进程中运行。
    # 这里我们依赖 Gunicorn 的 worker 进程管理来处理这种情况。
    # 对于多 worker 进程，一个更高级的方案是使用一个中心化的调度器或锁机制。
    # 但对于演示/小规模应用，当前的 BackgroundScheduler 在每个 worker 中独立运行也能工作，
    # 只是可能会有多余的模拟器实例。
    if not scheduler.running:
        scheduler.add_job(func=simulate_drone_movement, trigger="interval", seconds=2)
        scheduler.start()
        app.logger.info("APScheduler started successfully for drone simulation.")


with app.app_context():
    _start_scheduler_and_init_data()



# --------------------------------------------------------------------------------
# API 路由
# --------------------------------------------------------------------------------

# 1. 根路由 (保留)
@app.route('/')
def hello_world():
    return jsonify({"message": "Welcome to Drone Cluster Platform API!"})

# 2. Ping 路由 (保留)
@app.route('/api/ping')
def ping():
    return jsonify({"message": "pong", "status": "ok"})

# 3. 数据库测试路由 (更新为 SQLAlchemy)
@app.route('/api/db_test')
def db_test():
    try:
        # 使用 SQLAlchemy 的查询来测试数据库连接
        # 执行一个简单的查询，例如获取用户数量
        user_count = db.session.query(User).count()
        # 尝试执行一个原始的 SELECT 1 来确保底层连接也可用
        db.session.execute(text('SELECT 1')) 
        return jsonify({"message": f"Database connection successful! Users count: {user_count}", "status": "ok"})
    except Exception as e:
        app.logger.error(f"Database connection failed: {e}")
        # 在调试模式下，可以返回更详细的错误信息
        error_message = str(e) if app.config['DEBUG'] else "An error occurred during database connection test."
        return jsonify({"message": f"Database connection failed: {error_message}", "status": "error"}), 500

# 4. 用户注册 API
@app.route('/api/register', methods=['POST'])
def register_user():
    data = request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    if not username or not password:
        return jsonify({'message': 'Missing username or password'}), 400

    # 检查用户名是否已存在
    if User.query.filter_by(username=username).first():
        return jsonify({'message': 'Username already exists'}), 409
    
    # 检查邮箱是否已存在 (如果邮箱是可选，则根据需要处理)
    if email and User.query.filter_by(email=email).first():
        return jsonify({'message': 'Email already exists'}), 409

    # 对密码进行哈希处理
    hashed_password = generate_password_hash(password, method='scrypt') # 'scrypt' 是更现代的哈希方法，比 'pbkdf2:sha256' 更安全

    new_user = User(username=username, email=email, password_hash=hashed_password)
    db.session.add(new_user)
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error registering user {username}: {e}")
        return jsonify({'message': 'Error registering user', 'details': str(e)}), 500

    return jsonify({'message': 'User registered successfully!'}), 201

# 5. 用户登录 API
@app.route('/api/login', methods=['POST'])
def login_user():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'message': 'Missing username or password'}), 400

    user = User.query.filter_by(username=username).first()

    if not user or not check_password_hash(user.password_hash, password):
        return jsonify({'message': 'Invalid credentials'}), 401
    
    # 生成 JWT Token
    token_payload = {
        'user_id': user.id,
        'username': user.username,
        'role': user.role,
        'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=app.config['JWT_ACCESS_TOKEN_EXPIRES'])
    }
    # app.config['JWT_SECRET_KEY'] 会从 config.py 中读取，config.py 又从 .env 中读取 SECRET_KEY
    token = jwt.encode(token_payload, app.config['JWT_SECRET_KEY'], algorithm="HS256")

    # 更新用户的最后登录时间
    user.last_login_at = datetime.datetime.now()
    db.session.commit()

    return jsonify({
        'message': 'Login successful!',
        'token': token,
        'user_id': user.id,
        'username': user.username,
        'role': user.role
    }), 200

# 6. 受保护的测试路由 (需要有效的 JWT Token)
@app.route('/api/protected', methods=['GET'])
@token_required
def protected_route(current_user): # 装饰器会将 current_user 传递进来
    return jsonify({
        'message': 'You are authorized and accessed a protected route!',
        'user_id': current_user.id,
        'username': current_user.username,
        'role': current_user.role
    }), 200

# --------------------------------------------------------------------
# 新增：无人机 (Drones) 管理 API
# --------------------------------------------------------------------

# 7. 创建无人机
@app.route('/api/drones', methods=['POST'])
@token_required
def create_drone(current_user):
    data = request.get_json()
    name = data.get('name')
    serial_number = data.get('serial_number')
    model = data.get('model')
    home_latitude = data.get('home_latitude')
    home_longitude = data.get('home_longitude')
    video_feed_url = data.get('video_feed_url')

    if not name or not serial_number:
        return jsonify({'message': 'Missing name or serial_number'}), 400

    # 检查名称或序列号是否已存在
    existing_drone = Drone.query.filter((Drone.name == name) | (Drone.serial_number == serial_number)).first()
    if existing_drone:
        return jsonify({'message': 'Drone with this name or serial number already exists'}), 409

    new_drone = Drone(
        name=name,
        serial_number=serial_number,
        model=model,
        home_latitude=home_latitude,
        home_longitude=home_longitude,
        video_feed_url=video_feed_url,
        status='offline', # 默认状态
        created_at=datetime.datetime.now(),
        last_config_update=datetime.datetime.now()
    )
    db.session.add(new_drone)
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error creating drone {name}: {e}")
        return jsonify({'message': 'Error creating drone', 'details': str(e)}), 500

    return jsonify({'message': 'Drone created successfully!', 'drone': new_drone.to_dict()}), 201

# 8. 获取所有无人机
@app.route('/api/drones', methods=['GET'])
@token_required
def get_drones(current_user):
    drones = Drone.query.all()
    # 也可以根据查询参数决定是否包含遥测数据
    include_telemetry = request.args.get('include_telemetry', 'false').lower() == 'true'
    return jsonify([drone.to_dict(include_telemetry=include_telemetry) for drone in drones]), 200

# 9. 获取单个无人机详情
@app.route('/api/drones/<int:drone_id>', methods=['GET'])
@token_required
def get_drone(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404
    
    include_telemetry = request.args.get('include_telemetry', 'false').lower() == 'true'
    return jsonify(drone.to_dict(include_telemetry=include_telemetry)), 200

# 10. 更新无人机信息
@app.route('/api/drones/<int:drone_id>', methods=['PUT'])
@token_required
def update_drone(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404

    data = request.get_json()
    try:
        if 'name' in data:
            drone.name = data['name']
        if 'serial_number' in data:
            drone.serial_number = data['serial_number']
        if 'model' in data:
            drone.model = data['model']
        if 'status' in data:
            drone.status = data['status']
        if 'home_latitude' in data:
            drone.home_latitude = data['home_latitude']
        if 'home_longitude' in data:
            drone.home_longitude = data['home_longitude']
        if 'video_feed_url' in data:
            drone.video_feed_url = data['video_feed_url']
        
        drone.last_config_update = datetime.datetime.now() # 更新配置更新时间
        db.session.commit()
    except IntegrityError: # 捕获唯一性约束错误
        db.session.rollback()
        return jsonify({'message': 'A drone with the updated name or serial number already exists.'}), 409
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error updating drone {drone_id}: {e}")
        return jsonify({'message': 'Error updating drone', 'details': str(e)}), 500

    return jsonify({'message': 'Drone updated successfully!', 'drone': drone.to_dict()}), 200

# 11. 删除无人机
@app.route('/api/drones/<int:drone_id>', methods=['DELETE'])
@token_required
def delete_drone(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404

    try:
        # 在删除无人机前，需要删除所有关联的遥测数据和指令
        # SQLAchemay 的 cascade delete 可以在模型定义中设置，但这里手动处理更清晰
        DroneTelemetry.query.filter_by(drone_id=drone_id).delete()
        Command.query.filter_by(drone_id=drone_id).delete()
        db.session.delete(drone)
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error deleting drone {drone_id}: {e}")
        return jsonify({'message': 'Error deleting drone', 'details': str(e)}), 500

    return jsonify({'message': 'Drone deleted successfully!'}), 200

# --------------------------------------------------------------------
# 新增：无人机遥测 (Telemetry) API
# --------------------------------------------------------------------

# 12. 上传最新遥测数据
@app.route('/api/drones/<int:drone_id>/telemetry', methods=['POST'])
@token_required
def upload_telemetry(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404

    data = request.get_json()
    required_fields = ['current_latitude', 'current_longitude', 'current_altitude', 'battery_level']
    if not all(field in data for field in required_fields):
        return jsonify({'message': f'Missing required telemetry fields: {", ".join(required_fields)}'}), 400

    # 检查是否存在该无人机的遥测记录，如果有则更新，没有则创建
    telemetry = DroneTelemetry.query.filter_by(drone_id=drone_id).first()
    
    if not telemetry:
        telemetry = DroneTelemetry(drone_id=drone_id)
        db.session.add(telemetry)

    # 更新字段
    telemetry.current_latitude = data['current_latitude']
    telemetry.current_longitude = data['current_longitude']
    telemetry.current_altitude = data['current_altitude']
    telemetry.speed = data.get('speed', telemetry.speed)
    telemetry.battery_level = data['battery_level']
    telemetry.flight_mode = data.get('flight_mode', telemetry.flight_mode)
    telemetry.is_flying = data.get('is_flying', telemetry.is_flying)
    telemetry.error_message = data.get('error_message', telemetry.error_message)
    telemetry.updated_at = datetime.datetime.now() # 明确更新时间

    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error uploading telemetry for drone {drone_id}: {e}")
        return jsonify({'message': 'Error uploading telemetry', 'details': str(e)}), 500
    
    # 收到遥测更新后，可以更新无人机状态为 'online' 或其他
    if drone.status == 'offline':
        drone.status = 'online'
        db.session.commit() # 再次提交以保存无人机状态变化

    return jsonify({'message': 'Telemetry updated successfully!', 'telemetry': telemetry.to_dict()}), 200

# 13. 获取指定无人机的最新遥测数据
@app.route('/api/drones/<int:drone_id>/telemetry/latest', methods=['GET'])
@token_required
def get_latest_telemetry(current_user, drone_id):
    telemetry = DroneTelemetry.query.filter_by(drone_id=drone_id).first()
    if not telemetry:
        return jsonify({'message': 'Telemetry data not found for this drone!'}), 404
    
    return jsonify(telemetry.to_dict()), 200

# --------------------------------------------------------------------
# 新增：无人机指令 (Commands) API
# --------------------------------------------------------------------

# 14. 发送控制指令
@app.route('/api/drones/<int:drone_id>/commands', methods=['POST'])
@token_required
def issue_command(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404
    
    data = request.get_json()
    command_type = data.get('command_type')
    if not command_type:
        return jsonify({'message': 'Missing command_type'}), 400

    new_command = Command(
        drone_id=drone_id,
        command_type=command_type,
        target_latitude=data.get('target_latitude'),
        target_longitude=data.get('target_longitude'),
        target_altitude=data.get('target_altitude'),
        target_speed=data.get('target_speed'),
        status='pending', # 初始状态为 pending
        issued_by=current_user.id, # 记录是谁发出的命令
        issued_at=datetime.datetime.now()
    )
    db.session.add(new_command)
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error issuing command for drone {drone_id}: {e}")
        return jsonify({'message': 'Error issuing command', 'details': str(e)}), 500

    return jsonify({'message': 'Command issued successfully!', 'command': new_command.to_dict()}), 201

# 15. 获取指定无人机的所有指令 (历史指令)
@app.route('/api/drones/<int:drone_id>/commands', methods=['GET'])
@token_required
def get_drone_commands(current_user, drone_id):
    drone = Drone.query.get(drone_id)
    if not drone:
        return jsonify({'message': 'Drone not found!'}), 404

    commands = Command.query.filter_by(drone_id=drone_id).order_by(Command.issued_at.desc()).all()
    # 可以在此处添加 include_issuer 参数来决定是否返回发行者信息
    return jsonify([cmd.to_dict(include_issuer=True) for cmd in commands]), 200

# 16. 更新指令状态 (由无人机/网关或管理员调用)
@app.route('/api/commands/<int:command_id>/status', methods=['PUT'])
@token_required
def update_command_status(current_user, command_id):
    command = Command.query.get(command_id)
    if not command:
        return jsonify({'message': 'Command not found!'}), 404
    
    data = request.get_json()
    new_status = data.get('status')
    completion_message = data.get('completion_message')

    if not new_status:
        return jsonify({'message': 'Missing new status'}), 400
    
    # 简单验证状态转换 (可以根据需要增加更复杂的业务逻辑)
    valid_statuses = ['pending', 'sent', 'acknowledged', 'executing', 'completed', 'failed']
    if new_status not in valid_statuses:
        return jsonify({'message': f'Invalid status. Must be one of: {", ".join(valid_statuses)}'}), 400

    command.status = new_status
    if completion_message:
        command.completion_message = completion_message
    if new_status in ['completed', 'failed']:
        command.executed_at = datetime.datetime.now() # 如果命令完成或失败，则记录执行时间
    
    try:
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        app.logger.error(f"Error updating command {command_id} status: {e}")
        return jsonify({'message': 'Error updating command status', 'details': str(e)}), 500

    return jsonify({'message': 'Command status updated successfully!', 'command': command.to_dict()}), 200

# --------------------------------------------------------------------
# 应用启动 (Gunicorn 将取代 if __name__ == '__main__':)
# --------------------------------------------------------------------