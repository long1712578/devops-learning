
# DevOps Learning Path - Week 0: Setup Môi Trường

## Mục Tiêu
Trong tuần này, bạn sẽ:
- ✅ Cài đặt và cấu hình môi trường DevOps cơ bản
- ✅ Làm quen với Linux command line
- ✅ Thiết lập Git và GitHub
- ✅ Cài đặt Docker
- ✅ Tạo dự án đầu tiên

## Kiến Thức Cần Có
- Hiểu biết cơ bản về command line
- Tài khoản GitHub (free)

---

## Bước 1: Làm Quen Với Linux Commands

### Các lệnh cơ bản cần biết:

```bash
# Xem thư mục hiện tại
pwd

# Liệt kê files
ls -la

# Di chuyển thư mục
cd /path/to/directory

# Tạo thư mục
mkdir my-folder

# Tạo file
touch my-file.txt

# Xem nội dung file
cat my-file.txt

# Sửa file (dùng nano hoặc vim)
nano my-file.txt

# Copy file
cp source.txt destination.txt

# Di chuyển/đổi tên file
mv old-name.txt new-name.txt

# Xóa file
rm file.txt

# Xóa thư mục
rm -rf folder-name

# Xem thông tin hệ thống
uname -a

# Xem processes đang chạy
ps aux

# Tìm kiếm file
find . -name "*.txt"

# Grep trong file
grep "search-term" file.txt
```

### 🎯 Bài Tập 1: Linux Commands Practice

Thực hiện các lệnh sau:

```bash
# 1. Tạo cấu trúc thư mục cho project
mkdir -p ~/devops-practice/{app,config,scripts,logs}

# 2. Tạo file README
echo "# My DevOps Practice Project" > ~/devops-practice/README.md

# 3. Tạo script đơn giản
cat > ~/devops-practice/scripts/hello.sh << 'EOF'
#!/bin/bash
echo "Hello from DevOps!"
date
EOF

# 4. Cấp quyền thực thi
chmod +x ~/devops-practice/scripts/hello.sh

# 5. Chạy script
~/devops-practice/scripts/hello.sh

# 6. Xem history commands
history | tail -10
```

---

## Bước 2: Git & GitHub Setup

### Cài đặt Git (nếu chưa có)

```bash
# Kiểm tra Git đã cài chưa
git --version

# Nếu chưa có, cài đặt (Ubuntu/Debian)
sudo apt update && sudo apt install git -y

# Cấu hình Git
git config --global user.name "Tên Của Bạn"
git config --global user.email "email@example.com"

# Xem cấu hình
git config --list
```

### Tạo SSH Key cho GitHub

```bash
# Tạo SSH key
ssh-keygen -t ed25519 -C "email@example.com"

# Xem public key
cat ~/.ssh/id_ed25519.pub

# Copy key này và thêm vào GitHub Settings > SSH Keys
```

### 🎯 Bài Tập 2: Git Workflow Cơ Bản

```bash
# 1. Clone repository này
cd /workspaces
git clone <your-repo-url>

# 2. Tạo branch mới
git checkout -b feature/my-first-feature

# 3. Tạo file mới
echo "This is my first commit" > test-file.txt

# 4. Staging changes
git add test-file.txt

# 5. Commit
git commit -m "feat: add test file"

# 6. Push to GitHub
git push origin feature/my-first-feature

# 7. Xem log
git log --oneline --graph

# 8. Quay về main branch
git checkout main

# 9. Pull latest changes
git pull origin main
```

---

## Bước 3: Docker Setup

### Kiểm tra Docker

```bash
# Kiểm tra Docker version
docker --version
docker compose version

# Chạy container đầu tiên
docker run hello-world

# Xem images
docker images

# Xem containers
docker ps -a
```

### 🎯 Bài Tập 3: Docker Basics

```bash
# 1. Chạy Nginx container
docker run -d --name my-nginx -p 8080:80 nginx:latest

# 2. Kiểm tra container đang chạy
docker ps

# 3. Xem logs
docker logs my-nginx

# 4. Truy cập container
docker exec -it my-nginx bash

# Trong container:
ls /usr/share/nginx/html/
cat /usr/share/nginx/html/index.html
exit

# 5. Stop và remove container
docker stop my-nginx
docker rm my-nginx

# 6. Cleanup
docker system prune -a
```

---

## Bước 4: Tạo Project Đầu Tiên

### 🎯 Bài Tập 4: Simple Web App với Docker

Tạo một ứng dụng web đơn giản và chạy trong Docker.

#### 1. Tạo cấu trúc project

```bash
cd /workspaces/devops-learning
mkdir -p simple-webapp/{app,docker}
cd simple-webapp
```

#### 2. Tạo file HTML đơn giản

```bash
cat > app/index.html << 'EOF'
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Learning</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
        }
        h1 { font-size: 3em; margin-bottom: 20px; }
        .info { background: rgba(255,255,255,0.1); padding: 20px; border-radius: 10px; }
    </style>
</head>
<body>
    <h1>🚀 DevOps Learning Journey</h1>
    <div class="info">
        <h2>Week 0 Completed!</h2>
        <p>Bạn đã hoàn thành setup môi trường DevOps cơ bản</p>
        <p>Hostname: <span id="hostname"></span></p>
        <p>Time: <span id="time"></span></p>
    </div>
    <script>
        document.getElementById('time').textContent = new Date().toLocaleString();
        fetch('/hostname.txt').then(r => r.text()).then(h => {
            document.getElementById('hostname').textContent = h;
        }).catch(() => {
            document.getElementById('hostname').textContent = 'Docker Container';
        });
    </script>
</body>
</html>
EOF
```

#### 3. Tạo Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM nginx:alpine

# Copy HTML files
COPY app/ /usr/share/nginx/html/

# Add hostname info
RUN echo "$(hostname)" > /usr/share/nginx/html/hostname.txt

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF
```

#### 4. Tạo docker-compose.yml

```bash
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    build: .
    container_name: devops-webapp
    ports:
      - "8080:80"
    restart: unless-stopped
    labels:
      - "devops.learning=week0"
EOF
```

#### 5. Build và chạy

```bash
# Build image
docker compose build

# Chạy container
docker compose up -d

# Xem logs
docker compose logs -f

# Kiểm tra: Mở browser và truy cập http://localhost:8080
```

#### 6. Cleanup

```bash
# Stop containers
docker compose down

# Remove images
docker compose down --rmi all
```

---

## Bước 5: Tạo Script Automation

### 🎯 Bài Tập 5: DevOps Automation Script

Tạo script để tự động hóa các tác vụ thường dùng.

```bash
cat > devops-helper.sh << 'EOF'
#!/bin/bash

# DevOps Helper Script
# Mục đích: Tự động hóa các tác vụ DevOps thường dùng

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Check Docker
check_docker() {
    print_info "Checking Docker..."
    if command -v docker &> /dev/null; then
        print_success "Docker is installed: $(docker --version)"
    else
        print_error "Docker is not installed"
        exit 1
    fi
}

# Check Git
check_git() {
    print_info "Checking Git..."
    if command -v git &> /dev/null; then
        print_success "Git is installed: $(git --version)"
        print_info "Git user: $(git config user.name) <$(git config user.email)>"
    else
        print_error "Git is not installed"
        exit 1
    fi
}

# System info
show_system_info() {
    print_info "System Information:"
    echo "OS: $(uname -s)"
    echo "Kernel: $(uname -r)"
    echo "Hostname: $(hostname)"
    echo "Current User: $(whoami)"
    echo "Current Directory: $(pwd)"
    echo "Disk Usage:"
    df -h | grep -E '^/dev/'
}

# Docker cleanup
docker_cleanup() {
    print_info "Cleaning up Docker..."
    docker system prune -af --volumes
    print_success "Docker cleanup completed"
}

# Main menu
show_menu() {
    echo ""
    echo "======================================"
    echo "   DevOps Helper Script"
    echo "======================================"
    echo "1. Check Docker"
    echo "2. Check Git"
    echo "3. Show System Info"
    echo "4. Docker Cleanup"
    echo "5. Run All Checks"
    echo "0. Exit"
    echo "======================================"
}

# Main logic
main() {
    while true; do
        show_menu
        read -p "Select option: " choice
        case $choice in
            1) check_docker ;;
            2) check_git ;;
            3) show_system_info ;;
            4) docker_cleanup ;;
            5) 
                check_docker
                check_git
                show_system_info
                ;;
            0) 
                print_info "Goodbye!"
                exit 0
                ;;
            *) 
                print_error "Invalid option"
                ;;
        esac
        echo ""
        read -p "Press Enter to continue..."
    done
}

main
EOF

chmod +x devops-helper.sh
```

---

## Kiểm Tra Hoàn Thành Week 0

### ✅ Checklist

Đánh dấu các mục bạn đã hoàn thành:

- [ ] Thực hiện được các lệnh Linux cơ bản
- [ ] Cấu hình Git và tạo SSH key cho GitHub
- [ ] Chạy được Docker container đầu tiên
- [ ] Tạo và build được Dockerfile
- [ ] Sử dụng Docker Compose
- [ ] Tạo được automation script
- [ ] Hiểu workflow cơ bản: Code → Build → Run

### 📝 Bài Tập Tổng Hợp

Thử thách cuối tuần:

1. **Tạo một Git repository mới**
2. **Tạo ứng dụng web với 3 pages** (Home, About, Contact)
3. **Viết Dockerfile** để containerize ứng dụng
4. **Tạo docker-compose.yml** để chạy nhiều services
5. **Viết script** để automate build và deploy
6. **Push code lên GitHub**

---

## Tài Liệu Tham Khảo

### Linux
- [Linux Command Line Basics](https://ubuntu.com/tutorials/command-line-for-beginners)
- [Linux Journey](https://linuxjourney.com/)

### Git
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)

### Docker
- [Docker Documentation](https://docs.docker.com/)
- [Docker Getting Started](https://docs.docker.com/get-started/)

---

## Tiếp Theo

Sau khi hoàn thành Week 0, bạn sẽ chuyển sang:
- **Week 1**: Git Advanced & Branching Strategies
- **Week 2**: Docker Deep Dive & Multi-stage Builds
- **Week 3**: CI/CD với GitHub Actions
- **Week 4**: Infrastructure as Code (Terraform)

---

## Ghi Chú

- Thực hành mỗi ngày ít nhất 30 phút
- Ghi chép lại các lỗi gặp phải và cách giải quyết
- Tham gia communities: DevOps Vietnam, Docker Vietnam
- Đặt câu hỏi khi gặp khó khăn

**Chúc bạn học tốt! 🚀**
