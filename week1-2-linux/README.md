# Week 1-2: Linux Fundamentals

> **Thời gian**: 2 tuần (10-15 giờ)  
> **Mục tiêu**: Thành thạo Linux command line, hiểu file system, processes, networking cơ bản

## 📚 Nội dung học

### Day 1-2: File System & Navigation
### Day 3-4: Permissions & Users
### Day 5-6: Process Management
### Day 7-8: Networking Basics
### Day 9-10: Package Management & Services

## 🎯 Học xong bạn sẽ

- ✅ Tự tin sử dụng terminal Linux
- ✅ Hiểu cách Linux quản lý files, processes, networks
- ✅ Biết cách cài đặt và quản lý services
- ✅ Có thể troubleshoot các vấn đề cơ bản
- ✅ Sẵn sàng viết shell scripts (Week 3)

---

## 📖 Day 1-2: File System & Navigation

### Lý thuyết

Linux file system hierarchy:

```
/           Root directory
├── bin/    Essential binaries (ls, cat, cp)
├── etc/    Configuration files
├── home/   User home directories
├── opt/    Optional software
├── tmp/    Temporary files
├── usr/    User programs
│   ├── bin/
│   └── local/
├── var/    Variable data (logs, databases)
│   └── log/
└── root/   Root user's home
```

### Thực hành

```bash
# 1. Navigation
pwd                     # Print working directory
ls                      # List files
ls -l                   # Long format
ls -lah                 # All files + human readable
cd /etc                 # Change directory
cd ~                    # Go home
cd -                    # Go back
cd ../..                # Up 2 levels

# 2. File operations
touch file.txt          # Create empty file
mkdir mydir             # Create directory
mkdir -p a/b/c          # Create nested directories
cp file.txt file2.txt   # Copy file
cp -r dir1 dir2         # Copy directory recursively
mv file.txt newname.txt # Rename/move
rm file.txt             # Delete file
rm -rf mydir            # Delete directory (careful!)

# 3. Viewing files
cat file.txt            # Print entire file
less file.txt           # View file (q to quit)
head file.txt           # First 10 lines
tail file.txt           # Last 10 lines
tail -f /var/log/syslog # Follow log in real-time

# 4. Text manipulation
echo "Hello" > file.txt         # Write (overwrite)
echo "World" >> file.txt        # Append
cat file1.txt file2.txt > merged.txt

# 5. Search
find . -name "*.txt"            # Find files by name
find /var/log -mtime -1         # Files modified in last 24h
grep "error" file.txt           # Search text in file
grep -r "error" /var/log        # Recursive search
grep -i "ERROR" file.txt        # Case insensitive
```

### 🎮 Challenge 1: File Explorer

Tạo script `explore-fs.sh`:

```bash
#!/bin/bash
# Explore Linux file system

echo "=== File System Explorer ==="
echo ""
echo "Root directory size:"
du -sh /*

echo ""
echo "Largest directories in /var:"
du -sh /var/* | sort -hr | head -5

echo ""
echo "Recently modified files in /etc (last 24h):"
find /etc -type f -mtime -1 2>/dev/null

echo ""
echo "Files larger than 100MB in home:"
find ~ -type f -size +100M 2>/dev/null
```

Chạy:
```bash
chmod +x explore-fs.sh
./explore-fs.sh
```

---

## 📖 Day 3-4: Permissions & Users

### Lý thuyết

Linux permissions format: `-rwxrw-r--`

```
-       rwx     rw-     r--
|        |       |       |
type   owner   group  others

Types: - (file), d (directory), l (link)
Permissions: r (read=4), w (write=2), x (execute=1)
```

### Thực hành

```bash
# 1. View permissions
ls -l file.txt
# Output: -rw-r--r-- 1 user group 1234 Dec 27 10:00 file.txt

# 2. Change permissions
chmod 755 script.sh     # rwxr-xr-x
chmod +x script.sh      # Add execute
chmod u+w,g-r file.txt  # User add write, group remove read
chmod -R 755 mydir/     # Recursive

# 3. Change ownership
chown user:group file.txt
chown -R user:group mydir/
sudo chown root:root /etc/important.conf

# 4. Special permissions
chmod +s script.sh      # SUID (run as owner)
chmod +t /tmp           # Sticky bit (only owner can delete)

# 5. umask (default permissions)
umask                   # Show current umask (e.g., 0022)
umask 0027              # Set new umask
# Files created: 666 - 027 = 640 (rw-r-----)
# Dirs created:  777 - 027 = 750 (rwxr-x---)

# 6. User management
whoami                  # Current user
id                      # User ID and groups
sudo adduser newuser    # Create user
sudo usermod -aG sudo newuser  # Add to sudo group
sudo passwd newuser     # Change password
su - newuser            # Switch user
groups                  # Show user's groups
```

### 🎮 Challenge 2: Permission Manager

Tạo file `setup-permissions.sh`:

```bash
#!/bin/bash
# Setup secure directory structure

# Create project directory
mkdir -p ~/project/{scripts,data,logs,temp}

# Set permissions
chmod 755 ~/project/scripts    # Everyone can execute
chmod 750 ~/project/data       # Group can read
chmod 700 ~/project/logs       # Only owner
chmod 1777 ~/project/temp      # Sticky bit

# Create sample files
echo "#!/bin/bash" > ~/project/scripts/deploy.sh
chmod +x ~/project/scripts/deploy.sh

echo "sensitive data" > ~/project/data/secrets.txt
chmod 600 ~/project/data/secrets.txt

echo "Permissions setup complete!"
ls -lR ~/project
```

---

## 📖 Day 5-6: Process Management

### Thực hành

```bash
# 1. View processes
ps                      # Current shell processes
ps aux                  # All processes
ps aux | grep nginx     # Find specific process
top                     # Real-time process monitor (q to quit)
htop                    # Better top (if installed)

# 2. Process info
pgrep nginx             # Get PID by name
pidof nginx             # Same as pgrep
ps -p 1234              # Info about PID 1234
pstree                  # Process tree

# 3. Manage processes
kill 1234               # Send SIGTERM (graceful)
kill -9 1234            # Send SIGKILL (force)
killall nginx           # Kill all nginx processes
pkill -f "python app.py"

# 4. Background jobs
sleep 100 &             # Run in background
jobs                    # List background jobs
fg %1                   # Bring job 1 to foreground
bg %1                   # Resume job 1 in background
Ctrl+Z                  # Suspend current process
disown %1               # Detach job from shell

# 5. Process priority
nice -n 10 command      # Start with low priority
renice -n 5 -p 1234     # Change priority of running process

# 6. Systemd services
systemctl status nginx          # Check service status
sudo systemctl start nginx      # Start service
sudo systemctl stop nginx       # Stop service
sudo systemctl restart nginx    # Restart
sudo systemctl enable nginx     # Auto-start on boot
sudo systemctl disable nginx    # Disable auto-start
journalctl -u nginx -f          # Follow service logs
```

### 🎮 Challenge 3: Process Monitor

Tạo `process-monitor.sh`:

```bash
#!/bin/bash
# Monitor system processes

echo "=== System Process Monitor ==="
echo ""

echo "Top 5 CPU consumers:"
ps aux --sort=-%cpu | head -6

echo ""
echo "Top 5 Memory consumers:"
ps aux --sort=-%mem | head -6

echo ""
echo "Total processes: $(ps aux | wc -l)"
echo "Running: $(ps aux | grep -c ' R ')"
echo "Sleeping: $(ps aux | grep -c ' S ')"

echo ""
echo "Services status:"
for service in docker ssh nginx; do
    if systemctl is-active --quiet $service; then
        echo "✅ $service is running"
    else
        echo "❌ $service is stopped"
    fi
done
```

---

## 📖 Day 7-8: Networking Basics

### Thực hành

```bash
# 1. Network interfaces
ip addr show            # Show all interfaces
ip link show            # Link status
ifconfig                # Old way (if installed)

# 2. Connectivity
ping -c 4 google.com    # Test connectivity
ping 8.8.8.8            # Test without DNS
traceroute google.com   # Show route to host
mtr google.com          # Better traceroute

# 3. DNS
nslookup google.com     # DNS lookup
dig google.com          # Detailed DNS info
host google.com         # Simple DNS lookup
cat /etc/resolv.conf    # DNS servers

# 4. Ports & connections
ss -tuln                # Show listening ports
netstat -tuln           # Old way
lsof -i :80             # Process using port 80
sudo lsof -i -P -n      # All network connections

# 5. HTTP requests
curl https://api.github.com/users/long1712578
curl -I https://google.com              # Headers only
curl -X POST -d '{"key":"value"}' \
     -H "Content-Type: application/json" \
     https://api.example.com
wget https://example.com/file.zip       # Download file

# 6. Network tools
nc -zv google.com 80    # Test TCP connection
tcpdump -i eth0         # Packet capture
iptables -L             # Firewall rules

# 7. Hosts file
cat /etc/hosts          # Local DNS overrides
# Add entry:
echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts
```

### 🎮 Challenge 4: Network Diagnostics

Tạo `network-check.sh`:

```bash
#!/bin/bash
# Network diagnostics script

TARGET=${1:-google.com}

echo "=== Network Diagnostics for $TARGET ==="
echo ""

echo "1. DNS Resolution:"
dig +short $TARGET

echo ""
echo "2. Ping Test:"
ping -c 3 $TARGET

echo ""
echo "3. HTTP Response:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\nTime: %{time_total}s\n" https://$TARGET

echo ""
echo "4. Listening Ports:"
ss -tuln | grep LISTEN

echo ""
echo "5. Active Connections:"
ss -tunp | grep ESTAB | wc -l
```

Chạy: `./network-check.sh github.com`

---

## 📖 Day 9-10: Package Management & Services

### Thực hành (Ubuntu/Debian)

```bash
# 1. APT Package Manager
sudo apt update                 # Update package list
sudo apt upgrade                # Upgrade packages
sudo apt install nginx          # Install package
sudo apt remove nginx           # Remove package
sudo apt autoremove             # Remove unused dependencies
apt search nginx                # Search packages
apt show nginx                  # Package info

# 2. DPKG (low-level)
dpkg -l                         # List installed packages
dpkg -L nginx                   # List files in package
dpkg -S /usr/bin/nginx          # Find package owning file

# 3. Install from source
wget https://example.com/app.tar.gz
tar -xzf app.tar.gz
cd app
./configure
make
sudo make install

# 4. Snap packages (modern)
sudo snap install docker
snap list

# 5. Systemd service management
sudo systemctl start nginx
sudo systemctl status nginx
sudo systemctl enable nginx
sudo systemctl daemon-reload    # Reload service files

# 6. Create custom service
sudo nano /etc/systemd/system/myapp.service
```

Example service file:

```ini
[Unit]
Description=My Python App
After=network.target

[Service]
Type=simple
User=myuser
WorkingDirectory=/home/myuser/app
ExecStart=/usr/bin/python3 /home/myuser/app/main.py
Restart=always

[Install]
WantedBy=multi-user.target
```

### 🎮 Challenge 5: Service Creator

Tạo `create-service.sh`:

```bash
#!/bin/bash
# Create a simple systemd service

SERVICE_NAME="hello-devops"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# Create the app script
cat > /tmp/hello-app.sh << 'EOF'
#!/bin/bash
while true; do
    echo "[$(date)] Hello from DevOps service!"
    sleep 10
done
EOF

chmod +x /tmp/hello-app.sh

# Create systemd service
sudo tee $SERVICE_FILE > /dev/null << EOF
[Unit]
Description=Hello DevOps Service
After=network.target

[Service]
Type=simple
ExecStart=/tmp/hello-app.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl start $SERVICE_NAME
sudo systemctl enable $SERVICE_NAME

echo "Service created and started!"
echo "Check status: sudo systemctl status $SERVICE_NAME"
echo "View logs: sudo journalctl -u $SERVICE_NAME -f"
```

---

## 📋 Week 1-2 Final Project

### Project: System Information Dashboard

Tạo script `sysinfo-dashboard.sh` tổng hợp tất cả kiến thức:

```bash
#!/bin/bash
# System Information Dashboard

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo "╔════════════════════════════════════════╗"
echo "║   System Information Dashboard        ║"
echo "╚════════════════════════════════════════╝"

# System info
echo ""
echo "${GREEN}[System]${NC}"
echo "  Hostname: $(hostname)"
echo "  OS: $(lsb_release -d | cut -f2)"
echo "  Kernel: $(uname -r)"
echo "  Uptime: $(uptime -p)"

# CPU & Memory
echo ""
echo "${GREEN}[Resources]${NC}"
echo "  CPU Cores: $(nproc)"
echo "  CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
echo "  Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "  Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')"

# Network
echo ""
echo "${GREEN}[Network]${NC}"
echo "  IP Address: $(hostname -I | awk '{print $1}')"
echo "  Gateway: $(ip route | grep default | awk '{print $3}')"
echo "  DNS: $(grep nameserver /etc/resolv.conf | head -1 | awk '{print $2}')"

# Services
echo ""
echo "${GREEN}[Services]${NC}"
for service in docker ssh nginx; do
    if systemctl is-active --quiet $service 2>/dev/null; then
        echo -e "  ${GREEN}●${NC} $service"
    else
        echo -e "  ${RED}●${NC} $service"
    fi
done

# Top processes
echo ""
echo "${GREEN}[Top 3 Processes by CPU]${NC}"
ps aux --sort=-%cpu | awk 'NR<=4 {printf "  %s: %.1f%%\n", $11, $3}'

echo ""
echo "${GREEN}[Top 3 Processes by Memory]${NC}"
ps aux --sort=-%mem | awk 'NR<=4 {printf "  %s: %.1f%%\n", $11, $4}'

echo ""
```

Chạy: `./sysinfo-dashboard.sh`

---

## ✅ Week 1-2 Checklist

- [ ] Hiểu Linux file system hierarchy
- [ ] Thành thạo navigation commands (cd, ls, pwd)
- [ ] Biết cách tạo, copy, move, delete files/directories
- [ ] Hiểu Linux permissions (rwx, chmod, chown)
- [ ] Quản lý users và groups
- [ ] View và quản lý processes (ps, top, kill)
- [ ] Hiểu systemd services
- [ ] Biết cách kiểm tra network connectivity
- [ ] Sử dụng curl/wget để test APIs
- [ ] Cài đặt packages với apt
- [ ] Tạo custom systemd service
- [ ] Hoàn thành 5 challenges
- [ ] Hoàn thành Final Project

---

## 📚 Tài liệu tham khảo

- [Linux Journey](https://linuxjourney.com/)
- [The Linux Command Line book](https://linuxcommand.org/tlcl.php)
- [OverTheWire Bandit](https://overthewire.org/wargames/bandit/) - Linux game

---

**Chúc mừng! Bạn đã hoàn thành Week 1-2!** 🎉

Bây giờ chuyển sang → **[Week 3-4: Shell Scripting & Git](../week3-4-scripting-git/README.md)**
