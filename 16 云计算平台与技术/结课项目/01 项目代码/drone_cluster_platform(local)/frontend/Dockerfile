# 阶段 1: 构建 Vue 应用 (build-stage)
# ------------------------------------
# 这是一个临时的构建阶段，目标是执行 npm install 和 npm run build 命令，
# 生成 Vue 应用的生产环境静态文件。它不会成为最终运行的镜像。
FROM node:20-alpine AS build-stage

# 接收构建参数，用于在需要代理的网络环境中下载依赖
# ARG 指令定义了 Docker build 时可以传入的参数。
# 这些参数允许你在构建时动态配置代理设置，而不是硬编码在 Dockerfile 中。
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

# 如果这些 ARG 参数在构建时被传入（例如：docker build --build-arg HTTP_PROXY=...），
# 则将它们设置为容器内的环境变量。这确保了 npm install 等命令能通过代理访问外部网络。
ENV HTTP_PROXY=$HTTP_PROXY
ENV HTTPS_PROXY=$HTTPS_PROXY
ENV NO_PROXY=$NO_PROXY

# 设置容器内的工作目录为 /app。所有后续命令都会在这个目录下执行。
WORKDIR /app

# 复制 package.json 和任何 lock 文件 (package-lock.json, yarn.lock, pnpm-lock.yaml) 到工作目录。
# 这一步是 Docker 构建缓存优化的关键：如果 package*.json 没有变化，
# npm install 这一层可以重用缓存，大大加快构建速度。
COPY package*.json ./

# 安装项目的所有依赖。由于之前设置了代理环境变量，如果需要，npm 会通过代理下载依赖。
# --registry=https://registry.npmmirror.com 可以用于指定一个自定义的 npm 镜像源，如果默认源访问慢或被墙。
RUN npm install
# RUN npm install --registry=https://registry.npmmirror.com 

# 复制项目的其余所有文件到工作目录。
# 这一步在安装完依赖之后进行，避免了在文件变动频繁时破坏 npm install 的缓存。
COPY . .

# 运行 Vue 应用的构建命令。这会根据 package.json 中的 "build" 脚本，
# 生成生产环境的静态文件，通常会输出到 /app/dist 目录下。
RUN npm run build 

# 阶段 2: 仅用于输出构建产物 (dist_output)
# --------------------------------------
# 这是一个非常轻量级的阶段，它的唯一目的是从上一个 'build-stage' 提取出
# 构建好的静态文件 (通常是 /app/dist 目录下的内容)。
# 这样做的好处是最终的生产环境镜像会非常小，因为它不包含 Node.js、npm、
# 开发依赖（node_modules）等在运行时不需要的东西，只包含 Web 服务器（如 Nginx）和你的前端静态文件。
FROM alpine AS dist_output

# 设置容器内的工作目录为 /app。
WORKDIR /app

# 将 'build-stage' 阶段中生成的 /app/dist 目录下的所有文件，
# 复制到当前 (dist_output) 阶段的 /app/dist 目录下。
# 这一步是多阶段构建的核心：它只复制最终需要的文件，避免了包含 node_modules 等构建时依赖，
# 从而使得最终的 Nginx 部署镜像更小、更安全。
COPY --from=build-stage /app/dist ./dist

# 定义这个阶段的默认命令。这是一个非常特殊的 CMD。
# 它仅仅打印一条消息，列出 /app/dist 目录的内容，然后休眠1秒后退出。
# 这表明该 Dockerfile 生成的 'dist_output' 镜像本身并不是一个可运行的服务容器。
# 它的主要用途是作为一个来源 (source)，让其他 Dockerfile (例如 Nginx 的 Dockerfile)
# 可以使用 'COPY --from=dist_output /app/dist /usr/share/nginx/html' 这样的指令来获取构建好的前端文件。
CMD ["sh", "-c", "echo 'Frontend build artifacts are available in /app/dist on the volume.' && ls -la /app/dist && sleep 1 && exit 0"]