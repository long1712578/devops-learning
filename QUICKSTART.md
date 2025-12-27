# 🎯 Quick Start Guide - Bắt đầu ngay!

> Hướng dẫn bắt đầu học DevOps trong 5 phút

## ⚡ Cách nhanh nhất (Không cần cài đặt gì)

> ⚠️ **LƯU Ý**: Các lệnh trong hướng dẫn này chạy trên **Linux** (GitHub Codespace), KHÔNG phải PowerShell Windows!

### Bước 1: Push code lên GitHub (30 giây)

```powershell
# Trong PowerShell Windows (D:\Projects\devops-learning)
git add .
git commit -m "feat: add DevOps learning materials"
git push origin main
```

### Bước 2: Mở GitHub Codespace (1 phút)

1. **Mở trình duyệt, vào repo GitHub**:
   - URL: `https://github.com/<username>/devops-learning`
   - Thay `<username>` bằng username GitHub của bạn
2. Click nút **Code** (màu xanh)
3. Chọn tab **Codespaces**
4. Click **Create codespace on main**
5. Đợi 2-3 phút → VS Code mở trong browser (môi trường Linux)

### Bước 3: Kiểm tra môi trường (30 giây)

> 💡 **Chạy trong Codespace terminal** (Linux), KHÔNG phải PowerShell Windows!

Trong terminal của Codespace, chạy:

```bash
# Kiểm tra hệ thống (Codespace = Linux Ubuntu)
cat /etc/os-release | grep PRETTY_NAME

# Kiểm tra tools
docker --version
git --version
python3 --version

# Chạy Docker đầu tiên
docker run hello-world
```

### Bước 4: Bắt đầu học Week 0 (3 phút)

> 💡 **Trong Codespace** (VS Code trong browser)

```bash
# Đọc hướng dẫn
cat week0-setup.md

# Hoặc mở trong VS Code
code week0-setup.md
```

---

## ⚠️ Lỗi thường gặp

### ❌ "grep is not recognized" hoặc "cat: command not found"

**Nguyên nhân**: Bạn đang chạy lệnh Linux trên PowerShell Windows

**Giải pháp**: 
1. Push code lên GitHub: `git add . && git commit -m "update" && git push`
2. Mở Codespace trên GitHub (xem Bước 2 ở trên)
3. Chạy lại trong Codespace terminal

### ❌ "No such file or directory"

**Nguyên nhân**: Sai đường dẫn

**Giải pháp**:
```bash
# Kiểm tra vị trí hiện tại
pwd
# Output phải là: /workspaces/devops-learning

# Nếu sai, cd về đúng folder
cd /workspaces/devops-learning
```

### ❌ Codespace không start

**Giải pháp**:
- Đợi vài phút và thử lại
- Hoặc chọn region khác (Settings → Region)

---

## 🖥️ Windows vs Codespace

| Thao tác | Windows PowerShell | GitHub Codespace (Linux) |
|----------|-------------------|--------------------------|
| **Push code** | ✅ `git push` | ✅ `git push` |
| **Chạy lệnh Linux** | ❌ Không có `grep`, `cat`, etc. | ✅ Đầy đủ Linux commands |
| **Docker** | ✅ Nếu cài Docker Desktop | ✅ Có sẵn |
| **Python** | ✅ Nếu đã cài | ✅ Có sẵn |
| **Học DevOps** | ❌ Không đủ | ✅ Hoàn hảo |

**Kết luận**: Dùng PowerShell để **push code**, dùng **Codespace** để **học và thực hành**!

---

## 🚀 Lộ trình học đề xuất

### Tuần 0 (2-3 giờ)
- [ ] Setup GitHub Codespace
- [ ] Làm quen với Linux terminal
- [ ] Chạy container Docker đầu tiên
- [ ] Commit code đầu tiên

→ **[Xem chi tiết Week 0](week0-setup.md)**

### Tuần 1-2 (10-15 giờ)
- [ ] Linux file system & navigation
- [ ] Permissions & users
- [ ] Process management
- [ ] Networking basics
- [ ] Package management

→ **[Xem chi tiết Week 1-2](week1-2-linux/README.md)**

### Tuần 3-4 (10-15 giờ)
- [ ] Bash scripting advanced
- [ ] Git workflows
- [ ] GitHub Pull Requests
- [ ] CI automation basics

### Tuần 5-6 (10-15 giờ)
- [ ] Docker fundamentals
- [ ] Multi-stage builds
- [ ] Docker Compose
- [ ] Container security

### Tiếp tục...
- **Tháng 3-4**: CI/CD, Infrastructure as Code
- **Tháng 5-6**: Kubernetes, Monitoring, Security

---

## 📚 Tài nguyên quan trọng

### Miễn phí 100%
- ✅ **GitHub Codespaces**: 120 giờ/tháng (đủ cho 4 giờ/ngày)
- ✅ **Oracle Cloud**: VPS miễn phí vĩnh viễn
- ✅ **GCP Free Tier**: e2-micro vĩnh viễn + $300 credit

→ **[Xem tất cả VPS miễn phí](resources/free-vps-options.md)**

### Học tập
- 📖 Sách miễn phí
- 🎥 Video courses
- 🎮 Interactive labs
- 📝 Cheatsheets

→ **[Xem tài nguyên học tập](resources/learning-resources.md)**

---

## ❓ FAQ Nhanh

**Q: Tôi cần cài đặt gì trên máy không?**  
A: Không! GitHub Codespaces chạy trong browser, có sẵn mọi thứ.

**Q: Có tốn tiền không?**  
A: Không! 120 giờ Codespaces miễn phí/tháng (≈ 4 giờ/ngày).

**Q: Tôi không biết gì về Linux?**  
A: Không sao! Lộ trình bắt đầu từ zero, có hướng dẫn chi tiết từng bước.

**Q: Học hết mất bao lâu?**  
A: 4-6 tháng nếu học 1-2 giờ/ngày.

**Q: Sau khi học xong tôi có thể làm gì?**  
A: Apply vị trí Junior DevOps Engineer, có portfolio 3-5 dự án thực tế.

---

## 🆘 Cần trợ giúp?

- 📝 **Mở Issue**: Gặp lỗi? Tạo issue trên GitHub
- 💬 **Thảo luận**: Tab Discussions
- 📧 **Email**: (thêm email nếu có)

---

## ✅ Checklist bắt đầu

Copy checklist này và track tiến độ:

```markdown
## Week 0
- [ ] Mở được GitHub Codespace
- [ ] Chạy được Docker hello-world
- [ ] Commit code đầu tiên lên GitHub

## Week 1
- [ ] Hiểu Linux file system
- [ ] Thực hành 20+ commands
- [ ] Hoàn thành 3 challenges

## Week 2
- [ ] Quản lý được processes
- [ ] Hiểu networking basics
- [ ] Tạo custom systemd service
```

---

## 🎁 Bonus: Môi trường tự động

Codespace đã cấu hình sẵn:
- ✅ Docker
- ✅ Python 3.11
- ✅ Node.js 18
- ✅ Terraform
- ✅ kubectl & Helm
- ✅ VS Code extensions

Không cần setup gì thêm!

---

**Sẵn sàng chưa? Hãy bắt đầu ngay! 🚀**

[🚀 Mở Codespace ngay](../../codespaces/new?ref=main) | [📖 Đọc Week 0](week0-setup.md)
