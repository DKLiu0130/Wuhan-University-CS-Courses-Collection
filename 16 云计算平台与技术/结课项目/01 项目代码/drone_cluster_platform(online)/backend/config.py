import os
from decouple import config # 使用 python-decouple 来加载环境变量

class Config:
    # SECRET_KEY 用于 Flask session 和其他安全机制
    # 从环境变量获取，如果不存在则提供一个安全的默认值 (仅用于开发，生产环境务必设置)
    SECRET_KEY = config('SECRET_KEY', default='a_super_secret_key_for_flask_development_only')

    # 数据库配置
    # 构建 SQLAlchemy 风格的数据库连接 URI
    DB_HOST = config('DB_HOST', default='localhost')
    DB_PORT = config('DB_PORT', default='5432')
    DB_USER = config('DB_USER', default='drone_user')
    DB_PASSWORD = config('DB_PASSWORD', default='drone_password')
    DB_NAME = config('DB_NAME', default='drone_db')

    # Flask-SQLAlchemy 配置
    SQLALCHEMY_DATABASE_URI = (
        f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False # 禁用 Flask-SQLAlchemy 事件系统，减少内存消耗

    # JWT 配置
    JWT_SECRET_KEY = config('JWT_SECRET_KEY', default='another_very_secret_jwt_signing_key_for_dev')
    JWT_ACCESS_TOKEN_EXPIRES = config('JWT_ACCESS_TOKEN_EXPIRES', default=3600, cast=int) # access token 过期时间 (秒), 默认1小时

    # Flask 环境配置
    FLASK_ENV = config('FLASK_ENV', default='development')
    DEBUG = config('FLASK_DEBUG', default='True', cast=bool) # 转换为布尔值