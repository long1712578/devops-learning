#!/bin/bash
# Post-create script for DevOps Learning Codespace

echo "🚀 Setting up DevOps Learning Environment..."

# Update system
sudo apt-get update

# Install essential tools
sudo apt-get install -y \
    htop \
    tree \
    ncdu \
    net-tools \
    dnsutils \
    iputils-ping \
    telnet \
    curl \
    wget \
    vim \
    tmux \
    jq \
    unzip

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install k3d (lightweight k8s for learning)
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install Ansible
pip3 install --user ansible ansible-lint

# Setup Git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Create workspace directories
mkdir -p ~/projects ~/scripts ~/notes

# Create welcome message
cat > ~/.bash_profile << 'EOF'
echo "╔═══════════════════════════════════════════════╗"
echo "║   🚀 DevOps Learning Environment Ready!       ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "Quick commands:"
echo "  - docker --version"
echo "  - kubectl version --client"
echo "  - terraform --version"
echo "  - ansible --version"
echo ""
echo "Happy learning! 📚"
EOF

chmod +x ~/.bash_profile

# Install oh-my-bash (optional, for better terminal experience)
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended

echo "✅ Setup complete! Environment is ready."
echo "📖 Start with: cd /workspaces/devops-learning && cat week0-setup.md"
