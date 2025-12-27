# Week 0: Thiết lập Môi trường DevOps với GitHub Codespaces

> **Thời gian**: 2-3 giờ  
> **Mục tiêu**: Setup môi trường học tập hoàn toàn miễn phí với GitHub Codespaces

## 🎯 Mục tiêu Week 0

Sau khi hoàn thành Week 0, bạn sẽ:

- ✅ Hiểu cách sử dụng GitHub Codespaces (120 giờ miễn phí/tháng)
- ✅ Có môi trường Linux Ubuntu đầy đủ để học và thực hành
- ✅ Cài đặt các công cụ cần thiết: Git, Docker, Python, Node.js
- ✅ Làm quen với VS Code trong browser
- ✅ Commit code đầu tiên lên GitHub

## 🚀 Tại sao dùng GitHub Codespaces?

### Ưu điểm

1. **Miễn phí 100%**: 120 giờ/tháng cho personal accounts (~ 4 giờ/ngày)
2. **Không cần VPS**: Không tốn tiền thuê server
3. **Setup tự động**: Cài sẵn Docker, Python, Node.js, Git
4. **VS Code tích hợp**: Code trực tiếp trong browser hoặc VS Code desktop
5. **Truy cập mọi lúc**: Từ bất kỳ máy tính nào có internet
6. **Tự động tắt**: Sau 30 phút idle → tiết kiệm giờ sử dụng

### So sánh với VPS

| Tiêu chí | GitHub Codespaces | VPS (AWS/GCP) |
|----------|-------------------|---------------|
| **Chi phí** | ✅ Miễn phí (120h/tháng) | ⚠️ $5-10/tháng (sau free trial) |
| **Setup** | ✅ Tự động (1 phút) | ⚠️ Thủ công (30-60 phút) |
| **Cấu hình** | ✅ 2-4 cores, 8GB RAM | ⚠️ 1 core, 1-2GB RAM (free tier) |
| **Bảo mật** | ✅ GitHub quản lý | ⚠️ Tự hardening |
| **IP Public** | ❌ Không có (chỉ port forwarding) | ✅ Có |
| **Phù hợp** | Học Linux, Docker, CI/CD, scripting | Deploy app production, Kubernetes multi-node |

**Kết luận**: Dùng Codespaces cho **Tháng 1-3**, sau đó chuyển sang VPS (AWS/GCP free tier) cho **Tháng 4-6** khi cần IP public và Kubernetes.

## 📋 Bước 1: Tạo GitHub Account (nếu chưa có)

1. Truy cập [github.com](https://github.com)
2. Click **Sign up**
3. Nhập:
   - Email
   - Password (tối thiểu 8 ký tự)
   - Username (ví dụ: `long1712578`)
4. Xác thực email → Hoàn tất

## 📋 Bước 2: Fork/Clone Repo này

### Cách 1: Fork (Khuyến nghị)

1. Vào repo: [github.com/long1712578/devops-learning](https://github.com/long1712578/devops-learning)
2. Click nút **Fork** (góc trên phải)
3. Chọn tài khoản của bạn → **Create fork**

### Cách 2: Clone

```bash
# Trên máy local (nếu đã cài Git)
git clone https://github.com/long1712578/devops-learning.git
cd devops-learning
```

## 🚀 Bước 3: Mở GitHub Codespace

### 3.1. Tạo Codespace đầu tiên

1. Vào repo vừa fork/clone trên GitHub
2. Click nút **Code** (màu xanh)
3. Chọn tab **Codespaces**
4. Click **Create codespace on main**
5. Đợi 1-2 phút → VS Code mở trong browser

### 3.2. Làm quen với giao diện

```
┌─────────────────────────────────────────────┐
│  Explorer │  Search │  Git │  Extensions    │ ← Sidebar
├─────────────────────────────────────────────┤
│                                             │
│           Code Editor                       │ ← Editor
│                                             │
├─────────────────────────────────────────────┤
│  Terminal (bash)                            │ ← Terminal
│  $ pwd                                      │
│  /workspaces/devops-learning                │
└─────────────────────────────────────────────┘
```

### 3.3. Kiểm tra thông tin hệ thống

Mở terminal trong Codespace (Ctrl+` hoặc Terminal → New Terminal):

```bash
# Kiểm tra hệ điều hành
cat /etc/os-release
# Output: Ubuntu 20.04/22.04

# Kiểm tra CPU và RAM
lscpu | grep "Model name"
free -h

# Kiểm tra disk
df -h

# Kiểm tra user
whoami
# Output: codespace

# Kiểm tra network
ip addr show
hostname -I
```

## 🛠️ Bước 4: Cài đặt và kiểm tra công cụ

Codespaces có sẵn nhiều tools, nhưng hãy verify lại:

### 4.1. Git

```bash
git --version
# Output: git version 2.x.x

# Cấu hình Git (thay thông tin của bạn)
git config --global user.name "Long Nguyen"
git config --global user.email "long1712578@gmail.com"

# Kiểm tra config
git config --list
```

### 4.2. Docker

```bash
docker --version
# Output: Docker version 24.x.x

# Test Docker
docker run hello-world

# Kiểm tra images
docker images

# Kiểm tra containers
docker ps -a
```

### 4.3. Python

```bash
python3 --version
# Output: Python 3.10.x

pip3 --version

# Cài package thử
pip3 install requests --user
python3 -c "import requests; print(requests.__version__)"
```

### 4.4. Node.js & npm

```bash
node --version
# Output: v18.x.x

npm --version

# Cài package thử
npm install -g tldr
tldr ls
```

### 4.5. Các tools khác

```bash
# Kiểm tra các tools có sẵn
which curl wget git vim nano htop tree jq

# Cài thêm tools hữu ích
sudo apt update
sudo apt install -y \
    net-tools \
    dnsutils \
    iputils-ping \
    telnet \
    htop \
    tree \
    ncdu \
    tmux

# Test
htop  # Ctrl+C để thoát
tree -L 2
```

## 📝 Bước 5: Thực hành Linux cơ bản

Chạy các lệnh sau để làm quen với Linux:

```bash
# 1. Navigation
pwd                    # Print working directory
ls -la                 # List all files
cd ~                   # Go to home
cd -                   # Go back

# 2. Tạo và xóa files/folders
mkdir -p test/subfolder
cd test
touch file1.txt file2.txt
echo "Hello DevOps" > file1.txt
cat file1.txt
cp file1.txt file1_backup.txt
mv file2.txt renamed.txt
rm renamed.txt
cd ..
rm -rf test

# 3. Permissions
touch myfile.sh
chmod +x myfile.sh
ls -l myfile.sh
# Output: -rwxr-xr-x

# 4. Search
find . -name "*.md"
grep -r "DevOps" .

# 5. Process
ps aux | grep bash
top  # Press 'q' to quit

# 6. Network
curl -I https://github.com
ping -c 3 google.com
```

## 🐳 Bước 6: Thực hành Docker đầu tiên

### 6.1. Chạy container đơn giản

```bash
# Pull và run Nginx
docker run -d -p 8080:80 --name my-nginx nginx:alpine

# Kiểm tra container đang chạy
docker ps

# Test web server
curl localhost:8080
# Output: HTML của Nginx welcome page

# Xem logs
docker logs my-nginx

# Vào trong container
docker exec -it my-nginx sh
# Bên trong container:
ls -la /usr/share/nginx/html/
exit

# Dừng và xóa container
docker stop my-nginx
docker rm my-nginx
```

### 6.2. Tạo Dockerfile đầu tiên

```bash
# Tạo folder cho project
mkdir -p projects/hello-docker
cd projects/hello-docker

# Tạo file HTML
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>DevOps Learning</title></head>
<body>
  <h1>Hello from Docker! 🐳</h1>
  <p>This is my first containerized app.</p>
</body>
</html>
EOF

# Tạo Dockerfile
cat > Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF

# Build image
docker build -t hello-devops:v1 .

# Run container
docker run -d -p 8081:80 --name hello-app hello-devops:v1

# Test
curl localhost:8081
```

### 6.3. Port Forwarding trong Codespaces

Codespaces tự động detect ports và forward chúng. Kiểm tra:

1. Vào tab **PORTS** ở panel dưới VS Code
2. Thấy port 8081 → Click **Open in Browser**
3. Trình duyệt mới mở → Thấy trang HTML của bạn!

## 📦 Bước 7: Commit code đầu tiên

```bash
# Về root của repo
cd /workspaces/devops-learning

# Kiểm tra status
git status

# Add files mới
git add .

# Commit
git commit -m "feat: add hello-docker project and update week0 setup"

# Push lên GitHub
git push origin main

# Nếu gặp lỗi authentication, dùng GitHub CLI
gh auth login
# Chọn: GitHub.com → HTTPS → Yes (git protocol) → Login with browser
```

## 🎯 Bước 8: Bài tập thực hành

### Challenge 1: Linux Explorer

Tạo script `system-info.sh` để hiển thị thông tin hệ thống:

```bash
#!/bin/bash
# File: system-info.sh

echo "=== System Information ==="
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"
echo "Current User: $(whoami)"
echo "Current Directory: $(pwd)"
```

Chạy script:

```bash
chmod +x system-info.sh
./system-info.sh
```

### Challenge 2: Docker Compose

Tạo file `docker-compose.yml`:

```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: devops123
      POSTGRES_DB: learning
    ports:
      - "5432:5432"
```

Chạy:

```bash
mkdir html
echo "<h1>Docker Compose Works!</h1>" > html/index.html

docker-compose up -d
docker-compose ps
curl localhost:8080

# Stop
docker-compose down
```

### Challenge 3: Git Branching

```bash
# Tạo branch mới
git checkout -b feature/my-first-feature

# Tạo file mới
echo "# My Notes" > notes.md
git add notes.md
git commit -m "docs: add personal notes"

# Push branch
git push origin feature/my-first-feature

# Về main
git checkout main

# Merge (sau khi tạo PR trên GitHub)
git pull origin main
```

## ✅ Checklist hoàn thành Week 0

Copy checklist này vào file `week0-checklist.md`:

- [ ] Tạo GitHub account
- [ ] Fork/clone repo `devops-learning`
- [ ] Mở GitHub Codespace thành công
- [ ] Verify Git, Docker, Python, Node.js
- [ ] Cài thêm tools: htop, tree, tmux
- [ ] Thực hành 20+ lệnh Linux cơ bản
- [ ] Chạy container Nginx đầu tiên
- [ ] Build Dockerfile và tạo custom image
- [ ] Test port forwarding trong Codespaces
- [ ] Commit và push code lên GitHub
- [ ] Hoàn thành 3 challenges
- [ ] Tạo branch và merge vào main

## 📊 Theo dõi usage Codespaces

Kiểm tra số giờ đã dùng:

1. Vào [github.com/settings/billing](https://github.com/settings/billing)
2. Mục **Codespaces** → Xem usage
3. Free tier: **120 core-hours/month**

**Tips tiết kiệm giờ**:

- ✅ Codespace tự tắt sau 30 phút idle
- ✅ Dừng manually: Codespaces menu → Stop codespace
- ✅ Xóa codespace không dùng: Delete codespace
- ✅ Commit code thường xuyên để không mất khi tạo codespace mới

## 🔥 Tips nâng cao

### 1. Dùng Codespaces từ VS Code Desktop

```bash
# Cài extension "GitHub Codespaces" trong VS Code desktop
# Ctrl+Shift+P → "Codespaces: Connect to Codespace"
# Chọn codespace đang chạy → VS Code local connect vào
```

### 2. Dotfiles tự động

Tạo repo `dotfiles` trên GitHub với:

```bash
# ~/.bashrc hoặc ~/.zshrc
alias ll='ls -alh'
alias gs='git status'
alias gp='git pull'

export PS1='\u@\h:\w\$ '
```

Settings → Codespaces → Dotfiles repo → Chọn repo `dotfiles`

### 3. Prebuilds (Nâng cao)

Nếu bạn là owner của repo, tạo `.devcontainer/devcontainer.json` để prebuild:

```json
{
  "name": "DevOps Learning",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "docker-in-docker": "latest",
    "python": "3.11",
    "node": "18"
  },
  "postCreateCommand": "bash .devcontainer/post-create.sh"
}
```

## 🆘 Troubleshooting

### Codespace không start

- **Lỗi**: "Failed to create codespace"
- **Giải pháp**: Đợi vài phút hoặc chọn region khác (US East/West)

### Docker không chạy

```bash
# Kiểm tra Docker daemon
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker
```

### Hết quota 120 giờ

- **Giải pháp 1**: Đợi đầu tháng sau
- **Giải pháp 2**: Đăng ký AWS/GCP free tier
- **Giải pháp 3**: Upgrade GitHub Pro ($4/month → 180 giờ)

## 🎯 Bước tiếp theo

Sau khi hoàn thành Week 0, chuyển sang:

👉 **[Week 1-2: Linux Fundamentals](./week1-2-linux/README.md)**

## 📚 Tài liệu tham khảo

- [GitHub Codespaces Docs](https://docs.github.com/en/codespaces)
- [Docker Get Started](https://docs.docker.com/get-started/)
- [Linux Journey](https://linuxjourney.com/)

---

**Chúc mừng! Bạn đã hoàn thành Week 0! 🎉**

Bây giờ bạn có một môi trường DevOps đầy đủ để học và thực hành. Hãy commit progress và chuyển sang Week 1!
