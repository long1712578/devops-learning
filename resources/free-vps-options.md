# 🆓 Các tùy chọn VPS miễn phí cho học DevOps

> **Cập nhật**: December 2025

## 🏆 TOP 3 Khuyến nghị (Miễn phí 100%)

### 1. GitHub Codespaces ⭐⭐⭐⭐⭐

**KHUYẾN NGHỊ CAO NHẤT** cho người mới bắt đầu.

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí** | 120 core-hours/tháng (≈ 4 giờ/ngày với 2-core) |
| **Cấu hình** | 2-4 cores, 8-16GB RAM, 32GB storage |
| **Hệ điều hành** | Ubuntu 20.04/22.04 |
| **Tools có sẵn** | Docker, Git, Python, Node.js, VS Code |
| **IP Public** | ❌ Không (có port forwarding) |
| **Phù hợp** | ✅ Tháng 1-3: Linux, Docker, CI/CD, scripting |

**Ưu điểm**:
- ✅ Không cần thẻ tín dụng
- ✅ Setup 1 phút, xài ngay
- ✅ Tự động backup code lên GitHub
- ✅ Access từ mọi thiết bị

**Nhược điểm**:
- ❌ Không có IP public cố định
- ❌ Giới hạn 120 giờ/tháng

**Cách sử dụng**: Xem [Week 0 Setup Guide](../week0-setup.md)

---

### 2. Oracle Cloud Free Tier ⭐⭐⭐⭐⭐

**MIỄN PHÍ VĨNH VIỄN** - Tốt nhất cho VPS thực sự.

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí** | Vĩnh viễn (Always Free) |
| **Cấu hình** | 2x VM (1 vCPU, 1GB RAM) HOẶC 1x ARM VM (4 vCPU, 24GB RAM) |
| **Storage** | 200GB Block Volume |
| **Bandwidth** | 10TB/tháng |
| **IP Public** | ✅ Có (cố định) |
| **Phù hợp** | ✅ Tháng 4-6: Kubernetes, monitoring, production apps |

**Ưu điểm**:
- ✅ Miễn phí vĩnh viễn
- ✅ Cấu hình mạnh (ARM 24GB RAM!)
- ✅ IP public để deploy app thật

**Nhược điểm**:
- ⚠️ Cần thẻ tín dụng verify (trừ $1 rồi hoàn)
- ⚠️ Khó đăng ký từ VN (cần VPN)
- ⚠️ Có thể bị từ chối nếu IP VN

**Hướng dẫn đăng ký**:

```bash
# Bước 1: Chuẩn bị
- Thẻ Visa/Mastercard (hoặc thẻ ảo Momo)
- VPN (Cloudflare WARP) đổi IP sang Singapore/Japan

# Bước 2: Đăng ký
1. Vào: https://www.oracle.com/cloud/free/
2. Click "Start for free"
3. Home Region: Japan Central (Osaka) - gần VN
4. Nhập thông tin (địa chỉ có thể fake)
5. Verify thẻ (trừ $1, hoàn sau vài ngày)

# Bước 3: Tạo VM
1. Console → Compute → Instances → Create Instance
2. Image: Canonical Ubuntu 22.04
3. Shape: VM.Standard.E2.1.Micro (Always Free)
4. VCN: Để mặc định, check "Assign public IP"
5. SSH keys: Paste public key (tạo bằng ssh-keygen)
6. Create → Đợi 2-3 phút

# Bước 4: Mở firewall
# Oracle mặc định chặn hết, phải mở security list
1. VCN → Security Lists → Default Security List
2. Add Ingress Rules:
   - 0.0.0.0/0 → TCP → 80 (HTTP)
   - 0.0.0.0/0 → TCP → 443 (HTTPS)
   - 0.0.0.0/0 → TCP → 8080 (Apps)
```

**Tips**:
- Nếu bị từ chối, thử lại sau 1-2 tuần
- Dùng email mới + VPN khác IP
- Hoặc nhờ bạn bè nước ngoài đăng ký giúp

---

### 3. Google Cloud Platform (GCP) Free Tier ⭐⭐⭐⭐

**MIỄN PHÍ VĨNH VIỄN** e2-micro + $300 credit 90 ngày.

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí vĩnh viễn** | 1x e2-micro (0.25-1 vCPU, 1GB RAM) |
| **Free trial** | $300 credit trong 90 ngày đầu |
| **Storage** | 30GB HDD |
| **Bandwidth** | 1GB/tháng (Egress NA) |
| **Regions** | us-west1, us-central1, us-east1 |
| **IP Public** | ✅ Có |

**Ưu điểm**:
- ✅ e2-micro miễn phí vĩnh viễn
- ✅ $300 credit để test các services khác
- ✅ Docs và support tốt

**Nhược điểm**:
- ⚠️ Cần thẻ tín dụng
- ⚠️ Ping từ VN ~180ms (US regions)

**Hướng dẫn đăng ký**:

```bash
# Bước 1: Đăng ký
1. Vào: https://cloud.google.com/free
2. Đăng nhập Gmail → "Get started for free"
3. Account type: Individual
4. Country: Vietnam
5. Nhập thẻ Visa/Mastercard (trừ $1 verify)

# Bước 2: Tạo VM
1. Console → Compute Engine → VM Instances
2. Create Instance:
   - Name: devops-vm
   - Region: us-west1 (Oregon)
   - Machine type: e2-micro (Free tier eligible)
   - Boot disk: Ubuntu 22.04 LTS, 30GB Standard
   - Firewall: Allow HTTP + HTTPS traffic
3. Create → Lưu External IP

# Bước 3: SSH
# Dùng browser SSH hoặc gcloud CLI
gcloud compute ssh devops-vm --zone=us-west1-a
```

---

## 🥈 CÁC LỰA CHỌN KHÁC (Free Trial)

### 4. AWS Free Tier ⭐⭐⭐⭐

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí** | 12 tháng đầu |
| **Cấu hình** | t2.micro (1 vCPU, 1GB RAM) |
| **Giới hạn** | 750 giờ/tháng |
| **Storage** | 30GB EBS |

**Đăng ký**: [aws.amazon.com/free](https://aws.amazon.com/free/)

---

### 5. Azure Free Tier ⭐⭐⭐

| Tiêu chí | Chi tiết |
|----------|----------|
| **Free trial** | $200 credit 30 ngày |
| **Miễn phí 12 tháng** | B1S VM (1 vCPU, 1GB RAM) |

**Đăng ký**: [azure.microsoft.com/free](https://azure.microsoft.com/free/)

---

### 6. DigitalOcean $200 Credit ⭐⭐⭐

| Tiêu chí | Chi tiết |
|----------|----------|
| **Credit** | $200 trong 60 ngày |
| **Cấu hình** | Droplet: 1 vCPU, 1GB RAM, 25GB SSD |
| **Chi phí sau** | $6/tháng |

**Đăng ký**: [try.digitalocean.com/freetrialoffer](https://try.digitalocean.com/freetrialoffer/)

---

## 🆓 KHÔNG CẦN THẺ TÍN DỤNG

### 7. Gitpod ⭐⭐⭐

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí** | 50 giờ/tháng |
| **Cấu hình** | 4 cores, 8GB RAM |
| **Tương tự** | GitHub Codespaces |

**Đăng ký**: [gitpod.io](https://www.gitpod.io/)

---

### 8. Railway.app ⭐⭐⭐

| Tiêu chí | Chi tiết |
|----------|----------|
| **Miễn phí** | $5 credit/tháng |
| **Phù hợp** | Deploy apps (Node, Python, Docker) |
| **Services** | PostgreSQL, Redis, MongoDB |

**Đăng ký**: [railway.app](https://railway.app/)

---

## 📊 So sánh tổng hợp

| Dịch vụ | Miễn phí | Thẻ? | Thời hạn | IP Public | Phù hợp |
|---------|----------|------|----------|-----------|---------|
| **GitHub Codespaces** | 120h/tháng | ❌ | Vĩnh viễn | ❌ | ⭐⭐⭐⭐⭐ Tháng 1-3 |
| **Oracle Cloud** | ✅ | ⚠️ | Vĩnh viễn | ✅ | ⭐⭐⭐⭐⭐ Tháng 4-6 |
| **GCP e2-micro** | ✅ | ⚠️ | Vĩnh viễn | ✅ | ⭐⭐⭐⭐⭐ Tháng 4-6 |
| **AWS** | t2.micro | ⚠️ | 12 tháng | ✅ | ⭐⭐⭐⭐ OK |
| **Azure** | $200 | ⚠️ | 30 ngày | ✅ | ⭐⭐⭐ Ngắn hạn |
| **Gitpod** | 50h | ❌ | Vĩnh viễn | ❌ | ⭐⭐⭐ Alternative |

---

## 🎯 LỘ TRÌNH KHUYẾN NGHỊ

### Tháng 1-3: GitHub Codespaces
- **Lý do**: Không cần thẻ, setup nhanh, đủ dùng
- **Học**: Linux, Docker, CI/CD, scripting
- **Giới hạn**: Không có IP public → không deploy app production

### Tháng 4-6: Oracle Cloud hoặc GCP
- **Lý do**: Cần IP public cho Kubernetes, domain, HTTPS
- **Học**: K8s, Terraform, Ansible, monitoring
- **Lưu ý**: Đăng ký sớm từ Tháng 2 để kịp verify

### Backup plan
- Nếu Oracle/GCP từ chối → Dùng **AWS t2.micro** (12 tháng)
- Nếu hết credit → Deploy trên **Railway.app** ($5/tháng)

---

## 💡 TIPS QUAN TRỌNG

### 1. Tiết kiệm giờ Codespaces
```bash
# Codespace tự tắt sau 30 phút idle
# Commit code thường xuyên để không mất khi codespace bị delete

git add .
git commit -m "save progress"
git push
```

### 2. Bảo mật VPS
```bash
# Ngay sau khi tạo VPS, chạy script hardening:

# Tắt password SSH
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# Fail2ban
sudo apt install fail2ban -y
sudo systemctl enable fail2ban
```

### 3. Monitoring chi phí
- AWS/GCP/Azure: Set billing alerts tại $1, $5, $10
- Xem usage hàng tuần
- Xóa resources không dùng ngay

---

## 🆘 Nếu không có thẻ tín dụng

### Giải pháp: Thẻ ảo Momo

1. Mở app **Momo**
2. **Thẻ** → **Thẻ ảo Mastercard**
3. Nạp **50,000 VND**
4. Dùng verify Oracle/GCP/AWS
5. Sau khi verify xong, rút tiền về ví

**Lưu ý**: Oracle/GCP chỉ trừ $1 verify, hoàn lại sau vài ngày.

---

## ❓ FAQ

**Q: Tôi nên bắt đầu với dịch vụ nào?**  
A: GitHub Codespaces. Không cần thẻ, không lo chi phí.

**Q: Khi nào cần chuyển sang VPS thực?**  
A: Sau 2-3 tháng, khi học Kubernetes và cần IP public.

**Q: Oracle Cloud có dễ đăng ký không?**  
A: Khó hơn GCP/AWS, nhưng free vĩnh viễn nên đáng thử.

**Q: Nếu tôi vượt quota 120 giờ Codespaces?**  
A: Đợi đầu tháng sau, hoặc upgrade GitHub Pro ($4/tháng → 180 giờ).

---

**Cập nhật lần cuối**: December 27, 2025  
**Nguồn**: Kinh nghiệm thực tế + Community feedback

[← Quay lại README](../README.md)
