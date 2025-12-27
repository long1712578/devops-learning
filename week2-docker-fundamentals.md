# DevOps Learning Path - Week 2: Docker Fundamentals

## Mục Tiêu
Trong tuần này, bạn sẽ:
- ✅ Hiểu sâu về Docker architecture
- ✅ Tạo Dockerfile hiệu quả với multi-stage builds
- ✅ Quản lý Docker images và containers
- ✅ Sử dụng Docker Compose cho multi-container apps
- ✅ Docker networking và volumes
- ✅ Best practices cho containerization

---

## Phần 1: Docker Architecture Deep Dive

### Docker Components

```
┌─────────────────────────────────────┐
│         Docker Client (CLI)          │
└──────────────┬──────────────────────┘
               │ docker commands
               ↓
┌─────────────────────────────────────┐
│         Docker Daemon (dockerd)      │
│  ┌──────────────────────────────┐  │
│  │     Container Runtime         │  │
│  │  ┌────────┐ ┌────────┐       │  │
│  │  │Container│ │Container│       │  │
│  │  └────────┘ └────────┘       │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│         Docker Registry               │
│     (Docker Hub, Private Registry)    │
└─────────────────────────────────────┘
```

### 🎯 Bài Tập 1: Khám Phá Docker Internals

```bash
# 1. Xem thông tin Docker
docker info
docker version

# 2. Xem images
docker images
docker image ls --all

# 3. Xem containers
docker ps -a
docker container ls --all

# 4. Inspect Docker objects
docker inspect <container-id>
docker image inspect nginx:alpine

# 5. Xem Docker disk usage
docker system df

# 6. Xem processes trong container
docker run -d --name test-nginx nginx:alpine
docker top test-nginx
docker stats test-nginx

# Cleanup
docker stop test-nginx
docker rm test-nginx
```

---

## Phần 2: Dockerfile Best Practices

### Basic Dockerfile

```dockerfile
# Bad Example - Single stage, large image
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    curl

COPY . /app
WORKDIR /app

RUN pip3 install -r requirements.txt

CMD ["python3", "app.py"]
```

### Optimized Dockerfile

```dockerfile
# Good Example - Multi-stage, smaller image
FROM python:3.11-slim as builder

WORKDIR /app

# Install dependencies in a separate layer
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Final stage
FROM python:3.11-slim

WORKDIR /app

# Copy only necessary files
COPY --from=builder /root/.local /root/.local
COPY . .

# Make sure scripts are in PATH
ENV PATH=/root/.local/bin:$PATH

# Non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["python", "app.py"]
```

### 🎯 Bài Tập 2: Build Optimized Python App

```bash
cd /workspaces/devops-learning
mkdir docker-python-app
cd docker-python-app

# 1. Tạo Python application
cat > app.py << 'EOF'
from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello from Docker!',
        'hostname': socket.gethostname(),
        'environment': os.environ.get('ENV', 'development')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=False)
EOF

# 2. Tạo requirements.txt
cat > requirements.txt << 'EOF'
flask==3.0.0
gunicorn==21.2.0
EOF

# 3. Tạo .dockerignore
cat > .dockerignore << 'EOF'
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
*.log
.git
.gitignore
.env
.venv
venv/
*.md
Dockerfile
.dockerignore
EOF

# 4. Tạo Dockerfile với multi-stage build
cat > Dockerfile << 'EOF'
# Build stage
FROM python:3.11-slim as builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# Final stage
FROM python:3.11-slim

WORKDIR /app

# Copy dependencies from builder
COPY --from=builder /root/.local /root/.local

# Copy application
COPY app.py .

# Create non-root user
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

USER appuser

# Add local bin to PATH
ENV PATH=/root/.local/bin:$PATH

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "2", "app:app"]
EOF

# 5. Build image
docker build -t python-app:v1 .

# 6. So sánh image size
docker images | grep python-app

# 7. Run container
docker run -d --name python-app -p 8000:8000 \
    -e ENV=production \
    python-app:v1

# 8. Test
curl http://localhost:8000
curl http://localhost:8000/health

# 9. Xem logs
docker logs python-app

# 10. Cleanup
docker stop python-app
docker rm python-app
```

---

## Phần 3: Docker Multi-Stage Builds

### 🎯 Bài Tập 3: Node.js App với Multi-Stage Build

```bash
cd /workspaces/devops-learning
mkdir docker-nodejs-app
cd docker-nodejs-app

# 1. Tạo Node.js application
cat > package.json << 'EOF'
{
  "name": "docker-nodejs-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "nodemon": "^3.0.2"
  }
}
EOF

cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.json({
        message: 'Node.js Docker App',
        timestamp: new Date().toISOString(),
        environment: process.env.NODE_ENV || 'development'
    });
});

app.get('/api/status', (req, res) => {
    res.json({
        status: 'running',
        uptime: process.uptime(),
        memory: process.memoryUsage()
    });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF

# 2. Tạo multi-stage Dockerfile
cat > Dockerfile << 'EOF'
# Stage 1: Dependencies
FROM node:18-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Development dependencies
FROM node:18-alpine AS dev-dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Stage 3: Build (if using TypeScript/build step)
FROM node:18-alpine AS builder
WORKDIR /app
COPY --from=dev-dependencies /app/node_modules ./node_modules
COPY . .
# RUN npm run build  # Uncomment if you have build step

# Stage 4: Production
FROM node:18-alpine AS production
WORKDIR /app

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Copy only production dependencies
COPY --from=dependencies /app/node_modules ./node_modules
COPY package*.json ./
COPY server.js ./

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    chown -R nodejs:nodejs /app

USER nodejs

EXPOSE 3000

ENV NODE_ENV=production

# Use dumb-init to handle signals properly
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
EOF

# 3. Build và run
docker build -t nodejs-app:multi-stage .
docker run -d --name nodejs-app -p 3000:3000 nodejs-app:multi-stage

# 4. Test
curl http://localhost:3000
curl http://localhost:3000/api/status

# 5. Check image size
docker images | grep nodejs-app

# Cleanup
docker stop nodejs-app
docker rm nodejs-app
```

---

## Phần 4: Docker Compose

### 🎯 Bài Tập 4: Full-Stack Application với Docker Compose

```bash
cd /workspaces/devops-learning
mkdir fullstack-docker-app
cd fullstack-docker-app

# 1. Tạo cấu trúc project
mkdir -p backend frontend nginx

# 2. Backend (Node.js API)
cat > backend/package.json << 'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2",
    "pg": "^8.11.3",
    "cors": "^2.8.5"
  }
}
EOF

cat > backend/index.js << 'EOF'
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
    host: process.env.DB_HOST || 'postgres',
    port: 5432,
    database: process.env.DB_NAME || 'appdb',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres'
});

app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', service: 'backend' });
});

app.get('/api/users', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM users');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/users', async (req, res) => {
    const { name, email } = req.body;
    try {
        const result = await pool.query(
            'INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *',
            [name, email]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Backend running on port ${PORT}`);
});
EOF

cat > backend/Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["node", "index.js"]
EOF

# 3. Frontend (Simple HTML)
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Full-Stack Docker App</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 { color: #667eea; margin-bottom: 20px; }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        button {
            background: #667eea;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        button:hover { background: #5568d3; }
        .users-list {
            margin-top: 30px;
        }
        .user-item {
            padding: 15px;
            background: #f5f5f5;
            margin-bottom: 10px;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }
        .status {
            padding: 10px;
            background: #e8f5e9;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
            color: #2e7d32;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐳 Full-Stack Docker Application</h1>
        <div class="status" id="status">Checking connection...</div>
        
        <h2>Add User</h2>
        <form id="userForm">
            <div class="form-group">
                <label>Name:</label>
                <input type="text" id="name" required>
            </div>
            <div class="form-group">
                <label>Email:</label>
                <input type="email" id="email" required>
            </div>
            <button type="submit">Add User</button>
        </form>

        <div class="users-list">
            <h2>Users</h2>
            <div id="usersList"></div>
        </div>
    </div>

    <script>
        const API_URL = '/api';

        async function checkHealth() {
            try {
                const response = await fetch(`${API_URL}/health`);
                const data = await response.json();
                document.getElementById('status').textContent = 
                    `✅ Backend Status: ${data.status}`;
            } catch (error) {
                document.getElementById('status').textContent = 
                    `❌ Backend offline`;
                document.getElementById('status').style.background = '#ffebee';
                document.getElementById('status').style.color = '#c62828';
            }
        }

        async function loadUsers() {
            try {
                const response = await fetch(`${API_URL}/users`);
                const users = await response.json();
                const usersList = document.getElementById('usersList');
                usersList.innerHTML = users.map(user => `
                    <div class="user-item">
                        <strong>${user.name}</strong> - ${user.email}
                    </div>
                `).join('');
            } catch (error) {
                console.error('Error loading users:', error);
            }
        }

        document.getElementById('userForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;

            try {
                await fetch(`${API_URL}/users`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ name, email })
                });
                document.getElementById('name').value = '';
                document.getElementById('email').value = '';
                loadUsers();
            } catch (error) {
                alert('Error adding user: ' + error.message);
            }
        });

        checkHealth();
        loadUsers();
        setInterval(checkHealth, 30000);
    </script>
</body>
</html>
EOF

cat > frontend/Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EOF

# 4. Nginx reverse proxy config
cat > nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:5000;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
            try_files $uri $uri/ /index.html;
        }

        location /api/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
EOF

cat > nginx/Dockerfile << 'EOF'
FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY ../frontend/index.html /usr/share/nginx/html/
EOF

# 5. Database init script
mkdir -p postgres
cat > postgres/init.sql << 'EOF'
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (name, email) VALUES
    ('John Doe', 'john@example.com'),
    ('Jane Smith', 'jane@example.com')
ON CONFLICT (email) DO NOTHING;
EOF

# 6. Docker Compose file
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: app-postgres
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./postgres/init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

  backend:
    build: ./backend
    container_name: app-backend
    environment:
      DB_HOST: postgres
      DB_NAME: appdb
      DB_USER: postgres
      DB_PASSWORD: postgres
      PORT: 5000
    ports:
      - "5000:5000"
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped
    networks:
      - app-network

  frontend:
    build: ./frontend
    container_name: app-frontend
    ports:
      - "8080:80"
    depends_on:
      - backend
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    container_name: app-nginx
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./frontend/index.html:/usr/share/nginx/html/index.html:ro
    ports:
      - "80:80"
    depends_on:
      - backend
      - frontend
    networks:
      - app-network

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
EOF

# 7. Environment file
cat > .env << 'EOF'
# Database
POSTGRES_DB=appdb
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# Backend
DB_HOST=postgres
PORT=5000
EOF

# 8. Start everything
docker compose up -d

# 9. Watch logs
docker compose logs -f

# 10. Test
echo "App running at http://localhost"
echo "Direct backend: http://localhost:5000/api/health"
echo "Frontend: http://localhost:8080"

# 11. Useful commands
echo "
# Stop all services
docker compose stop

# Start all services
docker compose start

# Restart a service
docker compose restart backend

# View logs
docker compose logs -f backend

# Scale a service
docker compose up -d --scale backend=3

# Cleanup
docker compose down -v
"
```

---

## Phần 5: Docker Networking

### 🎯 Bài Tập 5: Docker Networks

```bash
# 1. Xem networks hiện có
docker network ls

# 2. Tạo custom network
docker network create --driver bridge app-net

# 3. Inspect network
docker network inspect app-net

# 4. Run containers trên cùng network
docker run -d --name redis --network app-net redis:alpine
docker run -d --name app --network app-net alpine sleep 3600

# 5. Test connectivity
docker exec app ping redis
docker exec app wget -qO- http://redis:6379

# 6. Connect thêm network cho container
docker network create another-net
docker network connect another-net app

# 7. Disconnect network
docker network disconnect another-net app

# Cleanup
docker stop redis app
docker rm redis app
docker network rm app-net another-net
```

---

## Phần 6: Docker Volumes

### 🎯 Bài Tập 6: Persistent Data với Volumes

```bash
# 1. Tạo volume
docker volume create app-data

# 2. Xem volumes
docker volume ls
docker volume inspect app-data

# 3. Run container với volume
docker run -d --name postgres-db \
    -e POSTGRES_PASSWORD=secret \
    -v app-data:/var/lib/postgresql/data \
    postgres:15-alpine

# 4. Add data
docker exec -it postgres-db psql -U postgres -c "CREATE TABLE test (id int, name text);"
docker exec -it postgres-db psql -U postgres -c "INSERT INTO test VALUES (1, 'Hello Docker');"

# 5. Stop và remove container
docker stop postgres-db
docker rm postgres-db

# 6. Start new container với cùng volume - data vẫn còn!
docker run -d --name postgres-db-new \
    -e POSTGRES_PASSWORD=secret \
    -v app-data:/var/lib/postgresql/data \
    postgres:15-alpine

# 7. Verify data
sleep 5
docker exec -it postgres-db-new psql -U postgres -c "SELECT * FROM test;"

# 8. Bind mount example
mkdir -p /tmp/my-app
echo "Hello from host" > /tmp/my-app/data.txt

docker run --rm -v /tmp/my-app:/app alpine cat /app/data.txt

# Cleanup
docker stop postgres-db-new
docker rm postgres-db-new
docker volume rm app-data
```

---

## Phần 7: Docker Best Practices

### Security Best Practices

```dockerfile
# 1. Use specific tags, not :latest
FROM python:3.11-slim

# 2. Run as non-root user
RUN useradd -m -u 1000 appuser
USER appuser

# 3. Use COPY instead of ADD
COPY requirements.txt .

# 4. Scan for vulnerabilities
# docker scan <image-name>

# 5. Use multi-stage builds to reduce size

# 6. Don't include secrets in images
# Use environment variables or secrets management

# 7. Minimize layers
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*

# 8. Use .dockerignore
```

### Performance Optimization

```bash
# 1. Layer caching - order matters!
# Copy dependencies first, then code
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

# 2. Use BuildKit
export DOCKER_BUILDKIT=1
docker build -t app .

# 3. Use specific base images
# alpine vs slim vs full

# 4. Clean up in same layer
RUN apt-get update && \
    apt-get install -y package && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

---

## Phần 8: Docker Debugging

### 🎯 Bài Tập 7: Debugging Containers

```bash
# 1. Xem logs
docker logs <container-name>
docker logs -f --tail 100 <container-name>

# 2. Execute commands in container
docker exec -it <container> bash
docker exec <container> ls -la /app

# 3. Copy files from/to container
docker cp <container>:/app/log.txt ./log.txt
docker cp ./config.json <container>:/app/

# 4. Inspect container
docker inspect <container>
docker inspect --format='{{.State.Status}}' <container>

# 5. Check resource usage
docker stats
docker stats <container>

# 6. View processes
docker top <container>

# 7. Port mapping
docker port <container>

# 8. Diff - xem thay đổi filesystem
docker diff <container>

# 9. Export/Import containers
docker export <container> > container.tar
docker import container.tar myimage:latest

# 10. Save/Load images
docker save myimage:latest > myimage.tar
docker load < myimage.tar
```

---

## Kiểm Tra Hoàn Thành Week 2

### ✅ Checklist

- [ ] Hiểu Docker architecture
- [ ] Viết Dockerfile tối ưu với multi-stage builds
- [ ] Sử dụng Docker Compose cho multi-container apps
- [ ] Quản lý Docker networks
- [ ] Sử dụng volumes cho persistent data
- [ ] Apply security best practices
- [ ] Debug containers hiệu quả

### 📝 Bài Tập Cuối Tuần

Tạo một microservices application với:
1. Frontend (React hoặc HTML/JS)
2. Backend API (Node.js hoặc Python)
3. Database (PostgreSQL hoặc MongoDB)
4. Cache (Redis)
5. Nginx reverse proxy

Yêu cầu:
- Multi-stage Dockerfiles
- Docker Compose orchestration
- Custom networks
- Persistent volumes
- Health checks
- Environment variables
- Non-root users

---

## Tài Liệu Tham Khảo

- [Docker Documentation](https://docs.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

---

## Tiếp Theo: Week 3

Trong Week 3, bạn sẽ học:
- CI/CD với GitHub Actions
- Automated testing và deployment
- Docker registry và image management
- Container security scanning

**Tiếp tục phát huy! 🚀**
