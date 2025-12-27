# DevOps Learning Path - Week 1: Git Advanced & Version Control

## Mục Tiêu
Trong tuần này, bạn sẽ:
- ✅ Nắm vững Git workflow và branching strategies
- ✅ Thực hành Git collaboration (Pull Requests, Code Review)
- ✅ Giải quyết merge conflicts
- ✅ Sử dụng Git hooks và automation
- ✅ Best practices cho commit messages và branch naming

---

## Phần 1: Git Branching Strategies

### Git Flow - Mô Hình Phổ Biến

```
main (production)
  ↓
develop (integration)
  ↓
feature/* (new features)
hotfix/* (urgent fixes)
release/* (release preparation)
```

### 🎯 Bài Tập 1: Thiết Lập Git Flow

```bash
# 1. Tạo repository mới
cd /workspaces/devops-learning
mkdir git-flow-practice
cd git-flow-practice
git init

# 2. Tạo file README
cat > README.md << 'EOF'
# Git Flow Practice Project

This project demonstrates Git Flow workflow.

## Branches
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `hotfix/*`: Production fixes
- `release/*`: Release preparation
EOF

# 3. Initial commit
git add README.md
git commit -m "chore: initial commit"

# 4. Tạo develop branch
git checkout -b develop
echo "Development branch created" >> README.md
git add README.md
git commit -m "chore: create develop branch"

# 5. Tạo feature branch
git checkout -b feature/user-authentication
mkdir -p src
cat > src/auth.js << 'EOF'
// User Authentication Module
class AuthService {
    constructor() {
        this.users = new Map();
    }

    register(username, password) {
        if (this.users.has(username)) {
            throw new Error('User already exists');
        }
        this.users.set(username, {
            password: this.hashPassword(password),
            createdAt: new Date()
        });
        return { success: true, username };
    }

    login(username, password) {
        const user = this.users.get(username);
        if (!user || user.password !== this.hashPassword(password)) {
            throw new Error('Invalid credentials');
        }
        return { success: true, token: this.generateToken(username) };
    }

    hashPassword(password) {
        // Simple hash for demo (use bcrypt in production!)
        return Buffer.from(password).toString('base64');
    }

    generateToken(username) {
        return Buffer.from(`${username}:${Date.now()}`).toString('base64');
    }
}

module.exports = AuthService;
EOF

git add src/auth.js
git commit -m "feat: add user authentication module"

# 6. Merge feature vào develop
git checkout develop
git merge --no-ff feature/user-authentication -m "feat: merge user authentication feature"

# 7. Tạo release branch
git checkout -b release/1.0.0
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.0.0] - 2024-12-27

### Added
- User authentication module
- Registration and login functionality

### Changed
- Initial release setup
EOF

git add CHANGELOG.md
git commit -m "chore: prepare release 1.0.0"

# 8. Merge release vào main
git checkout main
git merge --no-ff release/1.0.0 -m "chore: release version 1.0.0"
git tag -a v1.0.0 -m "Version 1.0.0"

# 9. Merge release trở lại develop
git checkout develop
git merge --no-ff release/1.0.0 -m "chore: merge release 1.0.0 into develop"

# 10. Xem history
git log --oneline --graph --all
```

---

## Phần 2: Advanced Git Commands

### Interactive Rebase

```bash
# Rebase interactive để clean up commits
git checkout -b feature/user-profile

# Tạo nhiều commits
echo "Profile page" > src/profile.js
git add src/profile.js
git commit -m "add profile"

echo "// Add avatar" >> src/profile.js
git add src/profile.js
git commit -m "add avatar"

echo "// Add bio" >> src/profile.js
git add src/profile.js
git commit -m "add bio"

# Rebase để squash commits
git rebase -i develop

# Trong editor, đổi 'pick' thành 'squash' cho commits muốn gộp
# Kết quả: 3 commits → 1 commit clean
```

### Cherry-pick

```bash
# Cherry-pick một commit cụ thể
git log --oneline feature/user-authentication

# Copy commit hash và apply vào branch khác
git checkout develop
git cherry-pick <commit-hash>
```

### Stash - Lưu Tạm Changes

```bash
# Làm việc trên feature
git checkout -b feature/settings
echo "Settings page" > src/settings.js
git add src/settings.js

# Cần chuyển branch gấp
git stash save "WIP: settings page"

# Chuyển branch khác
git checkout develop
# Làm việc khác...

# Quay lại và restore
git checkout feature/settings
git stash list
git stash pop
```

### 🎯 Bài Tập 2: Git Advanced Operations

```bash
cd /workspaces/devops-learning
mkdir git-advanced-practice
cd git-advanced-practice
git init

# 1. Tạo một số commits
for i in {1..5}; do
    echo "Content $i" > file$i.txt
    git add file$i.txt
    git commit -m "Add file $i"
done

# 2. Xem log đẹp
git log --oneline --graph --decorate --all

# 3. Undo last commit (giữ changes)
git reset --soft HEAD~1

# 4. Undo last commit (xóa changes)
# git reset --hard HEAD~1  # Cẩn thận!

# 5. Revert một commit (tạo commit mới)
git revert HEAD

# 6. Find bugs với git bisect
git bisect start
git bisect bad HEAD
git bisect good HEAD~5
# Git sẽ checkout các commits để bạn test

# 7. Search trong history
git log --all --grep="Add file"
git log -S "Content 3" --source --all

# 8. Blame - Xem ai sửa dòng nào
git blame file1.txt
```

---

## Phần 3: Merge Conflicts Resolution

### 🎯 Bài Tập 3: Practice Merge Conflicts

```bash
cd /workspaces/devops-learning
mkdir merge-conflict-practice
cd merge-conflict-practice
git init

# 1. Tạo base file
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF

git add app.js
git commit -m "Initial app setup"

# 2. Branch 1: Thêm authentication
git checkout -b feature/add-auth
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

// Authentication middleware
app.use((req, res, next) => {
    console.log('Auth check');
    next();
});

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF

git add app.js
git commit -m "feat: add authentication middleware"

# 3. Branch 2: Thêm logging
git checkout main
git checkout -b feature/add-logging
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

// Logging middleware
app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next();
});

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF

git add app.js
git commit -m "feat: add logging middleware"

# 4. Merge và gặp conflict
git checkout main
git merge feature/add-auth  # OK
git merge feature/add-logging  # CONFLICT!

# 5. Giải quyết conflict
# Mở app.js và sửa thủ công, hoặc:
cat > app.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

// Logging middleware
app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next();
});

// Authentication middleware
app.use((req, res, next) => {
    console.log('Auth check');
    next();
});

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
EOF

git add app.js
git commit -m "chore: resolve merge conflict between auth and logging"

# 6. Xem kết quả
git log --graph --oneline --all
```

---

## Phần 4: Git Hooks - Automation

### 🎯 Bài Tập 4: Setup Git Hooks

```bash
cd /workspaces/devops-learning
mkdir git-hooks-practice
cd git-hooks-practice
git init

# 1. Pre-commit hook - Check code format
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running pre-commit checks..."

# Check for console.log
if git diff --cached --name-only | xargs grep -n "console.log" 2>/dev/null; then
    echo "❌ ERROR: console.log() found! Please remove before committing."
    echo "Files with console.log:"
    git diff --cached --name-only | xargs grep -l "console.log" 2>/dev/null
    exit 1
fi

# Check for TODO comments
if git diff --cached | grep -n "TODO" 2>/dev/null; then
    echo "⚠️  WARNING: TODO comments found"
fi

echo "✅ Pre-commit checks passed!"
exit 0
EOF

chmod +x .git/hooks/pre-commit

# 2. Commit-msg hook - Enforce conventional commits
cat > .git/hooks/commit-msg << 'EOF'
#!/bin/bash

commit_msg=$(cat "$1")

# Pattern: type(scope): message
pattern="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{10,}"

if ! echo "$commit_msg" | grep -qE "$pattern"; then
    echo "❌ Invalid commit message format!"
    echo ""
    echo "Format: type(scope): message"
    echo ""
    echo "Types: feat, fix, docs, style, refactor, test, chore"
    echo "Example: feat(auth): add user login functionality"
    echo ""
    echo "Your message: $commit_msg"
    exit 1
fi

echo "✅ Commit message is valid"
exit 0
EOF

chmod +x .git/hooks/commit-msg

# 3. Test hooks
echo "console.log('test');" > bad-code.js
git add bad-code.js
git commit -m "add code"  # Sẽ fail!

# Fix và commit đúng
echo "// Clean code" > good-code.js
git add good-code.js
git commit -m "feat(core): add clean code implementation"
```

---

## Phần 5: Collaboration Workflow

### 🎯 Bài Tập 5: Pull Request Workflow

```bash
# Workflow khi làm việc nhóm:

# 1. Fork/Clone repository
git clone <repo-url>
cd <repo-name>

# 2. Tạo branch từ develop
git checkout develop
git pull origin develop
git checkout -b feature/new-feature

# 3. Làm việc và commit
# ... make changes ...
git add .
git commit -m "feat(module): implement new feature"

# 4. Keep branch updated với develop
git fetch origin
git rebase origin/develop

# Nếu có conflicts:
# - Resolve conflicts
# - git add <resolved-files>
# - git rebase --continue

# 5. Push branch
git push origin feature/new-feature

# 6. Tạo Pull Request trên GitHub
# - Go to GitHub
# - Click "New Pull Request"
# - Select: develop ← feature/new-feature
# - Add description
# - Request reviewers

# 7. Sau khi approved, merge PR

# 8. Cleanup
git checkout develop
git pull origin develop
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

---

## Phần 6: Git Best Practices

### Conventional Commits

```
Format: <type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```bash
git commit -m "feat(auth): add OAuth2 login"
git commit -m "fix(api): handle null response in user endpoint"
git commit -m "docs(readme): update installation instructions"
git commit -m "refactor(utils): simplify date formatting function"
```

### Branch Naming Convention

```
feature/short-description
fix/bug-description
hotfix/urgent-fix
release/version-number
chore/maintenance-task

Examples:
feature/user-profile
fix/login-validation
hotfix/security-patch
release/v2.0.0
chore/update-dependencies
```

### .gitignore Best Practices

```bash
# Tạo .gitignore toàn diện
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
vendor/
*.lock

# Environment variables
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
*.min.js
*.min.css

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
*.tmp

# Sensitive data
*.pem
*.key
secrets/
EOF
```

---

## Phần 7: Git Aliases & Productivity

### 🎯 Bài Tập 6: Setup Git Aliases

```bash
# Thêm aliases vào Git config
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# Advanced aliases
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --graph --oneline --all'
git config --global alias.amend 'commit --amend --no-edit'

# Aliases cho Git Flow
git config --global alias.new-feature '!f() { git checkout develop && git pull && git checkout -b feature/$1; }; f'
git config --global alias.new-hotfix '!f() { git checkout main && git pull && git checkout -b hotfix/$1; }; f'

# Sử dụng:
git new-feature user-settings
git new-hotfix security-patch
```

### Bash Aliases cho Git

```bash
# Thêm vào ~/.bashrc hoặc ~/.zshrc
cat >> ~/.bashrc << 'EOF'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --all --decorate'
alias gd='git diff'
alias gds='git diff --staged'

# Git cleanup
alias git-clean='git branch --merged | grep -v "\*\|main\|develop" | xargs -n 1 git branch -d'

EOF

source ~/.bashrc
```

---

## Phần 8: Dự Án Thực Hành

### 🎯 Bài Tập Tổng Hợp: Team Collaboration Project

Tạo một project mô phỏng làm việc nhóm:

```bash
cd /workspaces/devops-learning
mkdir team-project
cd team-project

# 1. Initialize với Git Flow
git init
git checkout -b develop

# 2. Tạo project structure
mkdir -p src/{api,frontend,database} tests docs
cat > README.md << 'EOF'
# Team Collaboration Project

## Structure
- `src/api/` - Backend API
- `src/frontend/` - Frontend code
- `src/database/` - Database schemas
- `tests/` - Test files
- `docs/` - Documentation

## Git Workflow
We use Git Flow for this project.
EOF

git add .
git commit -m "chore: initialize project structure"

# 3. Tạo multiple features (simulate team members)
# Feature 1: API endpoints
git checkout -b feature/api-endpoints
cat > src/api/users.js << 'EOF'
// User API endpoints
exports.getUsers = async (req, res) => {
    // Implementation
    res.json({ users: [] });
};

exports.createUser = async (req, res) => {
    // Implementation
    res.status(201).json({ success: true });
};
EOF

git add src/api/users.js
git commit -m "feat(api): add user CRUD endpoints"

# Feature 2: Frontend components
git checkout develop
git checkout -b feature/frontend-components
cat > src/frontend/UserList.jsx << 'EOF'
import React from 'react';

const UserList = () => {
    return (
        <div className="user-list">
            <h2>Users</h2>
            {/* User list implementation */}
        </div>
    );
};

export default UserList;
EOF

git add src/frontend/UserList.jsx
git commit -m "feat(frontend): add UserList component"

# Feature 3: Database schema
git checkout develop
git checkout -b feature/database-schema
cat > src/database/schema.sql << 'EOF'
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
EOF

git add src/database/schema.sql
git commit -m "feat(database): add users table schema"

# 4. Merge tất cả features
git checkout develop
git merge --no-ff feature/api-endpoints -m "Merge API endpoints"
git merge --no-ff feature/frontend-components -m "Merge frontend components"
git merge --no-ff feature/database-schema -m "Merge database schema"

# 5. Tạo release
git checkout -b release/1.0.0
cat > CHANGELOG.md << 'EOF'
# Changelog

## [1.0.0] - 2024-12-27

### Added
- User CRUD API endpoints
- UserList frontend component
- Database schema for users table

### Changed
- Initial project release
EOF

git add CHANGELOG.md
git commit -m "chore(release): prepare v1.0.0"

# 6. Merge to main
git checkout main 2>/dev/null || git checkout -b main
git merge --no-ff release/1.0.0 -m "chore: release v1.0.0"
git tag -a v1.0.0 -m "Release version 1.0.0"

# 7. Visualize
git log --graph --oneline --all --decorate
```

---

## Kiểm Tra Hoàn Thành Week 1

### ✅ Checklist

- [ ] Hiểu và áp dụng được Git Flow
- [ ] Sử dụng thành thạo branching và merging
- [ ] Giải quyết được merge conflicts
- [ ] Setup và sử dụng Git hooks
- [ ] Viết commit messages theo conventional commits
- [ ] Làm việc với Pull Requests
- [ ] Setup Git aliases để tăng productivity

---

## Tài Liệu Tham Khảo

- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)

---

## Tiếp Theo: Week 2

Trong Week 2, bạn sẽ học:
- Docker Multi-stage builds
- Docker Compose advanced
- Container orchestration basics
- Docker networking và volumes

**Tiếp tục cố gắng! 🚀**
