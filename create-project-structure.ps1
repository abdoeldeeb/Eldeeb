# =================================================================
# Order Management System - Project Structure Creator (PowerShell)
# إنشاء الهيكل التنظيمي لنظام إدارة الطلبات - PowerShell
# =================================================================

param(
    [string]$ProjectName = "order-management-system",
    [string]$Version = "2.0.0",
    [string]$Author = "AI Assistant"
)

# Set console encoding to UTF-8 for Arabic support
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    Magenta = "Magenta"
    Cyan = "Cyan"
    White = "White"
}

# Functions for colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[✓] $Message" -ForegroundColor $Colors.Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "[ℹ] $Message" -ForegroundColor $Colors.Blue
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[⚠] $Message" -ForegroundColor $Colors.Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[✗] $Message" -ForegroundColor $Colors.Red
}

function Write-Header {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $Colors.Magenta
}

# Main function
function New-ProjectStructure {
    Clear-Host
    
    Write-Header "==============================================="
    Write-Header "    🚀 Order Management System Creator"
    Write-Header "    مُنشئ نظام إدارة الطلبات - PowerShell"
    Write-Header "==============================================="
    Write-Host ""
    
    Write-Info "بدء إنشاء الهيكل التنظيمي للمشروع..."
    Write-Host ""
    
    # Check if project directory exists
    if (Test-Path $ProjectName) {
        Write-Warning "المجلد $ProjectName موجود بالفعل!"
        $response = Read-Host "هل تريد الاستمرار والكتابة فوقه؟ (y/N)"
        if ($response -notmatch '^[Yy]$') {
            Write-Error "تم إلغاء العملية"
            Read-Host "اضغط Enter للخروج"
            return
        }
        Remove-Item -Path $ProjectName -Recurse -Force
    }
    
    # Create main project directory
    Write-Info "🗂️ إنشاء الهيكل التنظيمي للمجلدات..."
    New-Item -ItemType Directory -Path $ProjectName | Out-Null
    Set-Location $ProjectName
    
    # Create directory structure
    $Directories = @(
        "assets/css", "assets/js", "assets/images", "assets/fonts", "assets/icons",
        "components", "pages", "utils",
        "api/routes", "api/controllers", "api/middleware", "api/models",
        "config", "database/migrations", "database/seeds", "database/backups",
        "docs/api", "docs/user-guide", "docs/development",
        "tests/unit", "tests/integration", "tests/e2e",
        "build", "dist", "deploy", "logs", "temp",
        "public", "src", "storage/uploads", "storage/cache", "storage/sessions"
    )
    
    foreach ($dir in $Directories) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    Write-Status "تم إنشاء الهيكل التنظيمي للمجلدات"
    
    # Create main HTML file
    Write-Info "📄 إنشاء الملف الرئيسي index.html..."
    
    $IndexHTML = @"
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="نظام إدارة الطلبات - نظام شامل لإدارة طلبات العملاء والخدمات">
    <meta name="keywords" content="إدارة الطلبات, نظام إدارة, CRM, طلبات العملاء">
    <meta name="author" content="$Author">
    <title>نظام إدارة الطلبات</title>
    
    <!-- External Libraries -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <!-- Custom Styles -->
    <link rel="stylesheet" href="assets/css/styles.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="assets/icons/favicon.ico">
</head>
<body class="bg-gray-50 font-arabic">
    <!-- Loading Screen -->
    <div id="loadingScreen" class="fixed inset-0 bg-white z-50 flex items-center justify-center">
        <div class="text-center">
            <div class="loading-spinner mb-4"></div>
            <p class="text-gray-600">جاري تحميل النظام...</p>
        </div>
    </div>

    <!-- Main Application -->
    <div id="app" class="hidden">
        <!-- Header -->
        <header id="mainHeader"></header>
        
        <!-- Navigation -->
        <nav id="mainNavigation"></nav>
        
        <!-- Main Content -->
        <main id="mainContent" class="container mx-auto px-4 py-8">
            <!-- Content will be loaded here -->
        </main>
        
        <!-- Footer -->
        <footer id="mainFooter"></footer>
    </div>

    <!-- Modals Container -->
    <div id="modalsContainer"></div>
    
    <!-- Notifications Container -->
    <div id="notificationsContainer"></div>

    <!-- Scripts -->
    <script src="assets/js/config.js"></script>
    <script src="assets/js/utils.js"></script>
    <script src="assets/js/data.js"></script>
    <script src="assets/js/notifications.js"></script>
    <script src="assets/js/components.js"></script>
    <script src="assets/js/app.js"></script>
</body>
</html>
"@
    
    $IndexHTML | Out-File -FilePath "index.html" -Encoding UTF8
    Write-Status "تم إنشاء ملف index.html"
    
    # Create CSS files
    Write-Info "🎨 إنشاء ملفات CSS..."
    
    $MainCSS = @"
/* =================================================================
   Order Management System - Main Styles
   نظام إدارة الطلبات - الأنماط الرئيسية
================================================================= */

/* Custom Properties */
:root {
    --primary-color: #3b82f6;
    --secondary-color: #10b981;
    --accent-color: #f59e0b;
    --danger-color: #ef4444;
    --dark-color: #1f2937;
    --light-color: #f8fafc;
    --border-radius: 8px;
    --box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    --transition: all 0.3s ease;
}

/* Base Styles */
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Tajawal', Arial, sans-serif;
    line-height: 1.6;
    color: var(--dark-color);
    direction: rtl;
    text-align: right;
}

/* Loading Spinner */
.loading-spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f4f6;
    border-top: 4px solid var(--primary-color);
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Components */
.btn {
    display: inline-block;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: var(--border-radius);
    font-weight: 500;
    text-decoration: none;
    cursor: pointer;
    transition: var(--transition);
}

.btn-primary {
    background: var(--primary-color);
    color: white;
}

.btn-primary:hover {
    background: #2563eb;
    transform: translateY(-2px);
}

/* Cards */
.card {
    background: white;
    border-radius: var(--border-radius);
    box-shadow: var(--box-shadow);
    padding: 1.5rem;
    margin-bottom: 1rem;
}

/* Responsive */
@media (max-width: 768px) {
    .btn {
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
    }
}

/* Dark mode */
.dark-mode {
    background: #111827;
    color: #f9fafb;
}

.dark-mode .card {
    background: #1f2937;
    border-color: #374151;
}
"@
    
    $MainCSS | Out-File -FilePath "assets/css/styles.css" -Encoding UTF8
    Write-Status "تم إنشاء ملفات CSS"
    
    # Create JavaScript files
    Write-Info "⚙️ إنشاء ملفات JavaScript..."
    
    $ConfigJS = @"
/* =================================================================
   Configuration File
   ملف الإعدادات
================================================================= */

const CONFIG = {
    // Application Info
    APP_NAME: 'نظام إدارة الطلبات',
    VERSION: '$Version',
    AUTHOR: '$Author',
    
    // Service Types
    SERVICE_TYPES: {
        translation: { ar: 'ترجمة', en: 'Translation', icon: '🌐', color: '#3b82f6' },
        editing: { ar: 'تحرير وتدقيق', en: 'Editing', icon: '✏️', color: '#10b981' },
        design: { ar: 'تصميم', en: 'Design', icon: '🎨', color: '#8b5cf6' },
        writing: { ar: 'كتابة محتوى', en: 'Writing', icon: '📝', color: '#f59e0b' }
    },
    
    // Order Statuses
    ORDER_STATUSES: {
        pending: { ar: 'قيد المراجعة', en: 'Pending', color: '#f59e0b' },
        processing: { ar: 'قيد المعالجة', en: 'Processing', color: '#3b82f6' },
        completed: { ar: 'مكتملة', en: 'Completed', color: '#10b981' },
        rejected: { ar: 'مرفوضة', en: 'Rejected', color: '#ef4444' }
    },
    
    // Storage Keys
    STORAGE_KEYS: {
        orders: 'orders_data',
        clients: 'clients_data',
        settings: 'app_settings',
        theme: 'app_theme'
    }
};
"@
    
    $AppJS = @"
/* =================================================================
   Main Application
   التطبيق الرئيسي
================================================================= */

class OrderManagementApp {
    constructor() {
        this.init();
    }
    
    init() {
        // Hide loading screen
        setTimeout(() => {
            document.getElementById('loadingScreen').style.display = 'none';
            document.getElementById('app').classList.remove('hidden');
        }, 1500);
        
        // Set up basic UI
        this.setupUI();
        
        // Show welcome message
        setTimeout(() => {
            this.showNotification('مرحباً بك في نظام إدارة الطلبات! 🎉', 'success');
        }, 2000);
    }
    
    setupUI() {
        // Header
        document.getElementById('mainHeader').innerHTML = `
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 text-white p-4">
                <div class="container mx-auto">
                    <h1 class="text-2xl font-bold">نظام إدارة الطلبات</h1>
                    <p class="text-blue-100">نظام شامل لإدارة طلبات العملاء والخدمات</p>
                </div>
            </div>
        `;
        
        // Main content
        document.getElementById('mainContent').innerHTML = `
            <div class="text-center">
                <h2 class="text-3xl font-bold text-gray-800 mb-4">مرحباً بك في نظام إدارة الطلبات</h2>
                <p class="text-gray-600 mb-8">تم إنشاء الهيكل التنظيمي بنجاح! يمكنك الآن البدء في التطوير.</p>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="card hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-semibold mb-2">📊 لوحة التحكم</h3>
                        <p class="text-gray-600">عرض الإحصائيات والتقارير</p>
                    </div>
                    <div class="card hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-semibold mb-2">📝 إدارة الطلبات</h3>
                        <p class="text-gray-600">إضافة وتعديل وتتبع الطلبات</p>
                    </div>
                    <div class="card hover:shadow-lg transition-shadow">
                        <h3 class="text-xl font-semibold mb-2">👥 إدارة العملاء</h3>
                        <p class="text-gray-600">إدارة بيانات العملاء</p>
                    </div>
                </div>
            </div>
        `;
        
        // Footer
        document.getElementById('mainFooter').innerHTML = `
            <div class="bg-gray-800 text-white p-4 mt-8">
                <div class="container mx-auto text-center">
                    <p>&copy; $(Get-Date -Format "yyyy") $Author. جميع الحقوق محفوظة.</p>
                </div>
            </div>
        `;
    }
    
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50`;
        notification.textContent = message;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
}

// Initialize application
document.addEventListener('DOMContentLoaded', () => {
    new OrderManagementApp();
});
"@
    
    $ConfigJS | Out-File -FilePath "assets/js/config.js" -Encoding UTF8
    $AppJS | Out-File -FilePath "assets/js/app.js" -Encoding UTF8
    Write-Status "تم إنشاء ملفات JavaScript"
    
    # Create documentation
    Write-Info "📚 إنشاء ملفات التوثيق..."
    
    $ReadmeMD = @"
# نظام إدارة الطلبات
Order Management System

## 📋 نظرة عامة
نظام شامل لإدارة طلبات العملاء والخدمات مع واجهة مستخدم حديثة ومتجاوبة.

## ✨ المميزات
- إدارة الطلبات (إضافة، تعديل، حذف، عرض)
- إدارة العملاء التلقائية
- تتبع حالات الطلبات
- إحصائيات شاملة
- تصميم متجاوب
- حفظ البيانات محلياً

## 🚀 التثبيت والتشغيل
1. حمل الملفات أو استنسخ المشروع
2. افتح ملف ``index.html`` في المتصفح
3. ابدأ في استخدام النظام!

## 🛠️ التقنيات المستخدمة
- HTML5
- CSS3 / Tailwind CSS
- JavaScript ES6+
- Local Storage

## 📄 الترخيص
هذا المشروع مرخص تحت رخصة MIT.

---
تم إنشاؤه بواسطة $Author - $(Get-Date -Format "yyyy-MM-dd")
"@
    
    $ReadmeMD | Out-File -FilePath "README.md" -Encoding UTF8
    Write-Status "تم إنشاء ملفات التوثيق"
    
    # Create database files
    Write-Info "🗄️ إنشاء ملفات قاعدة البيانات..."
    
    $DatabaseSchema = @"
-- =================================================================
-- Order Management System Database Schema
-- نظام إدارة الطلبات - مخطط قاعدة البيانات
-- =================================================================

-- Clients table
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    client_id INT NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('pending', 'processing', 'completed', 'rejected') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    estimated_price DECIMAL(10,2),
    final_price DECIMAL(10,2),
    delivery_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
"@
    
    $DatabaseSchema | Out-File -FilePath "database/schema.sql" -Encoding UTF8
    Write-Status "تم إنشاء ملفات قاعدة البيانات"
    
    # Create configuration files
    Write-Info "⚙️ إنشاء ملفات الإعدادات..."
    
    $PackageJSON = @"
{
  "name": "$($ProjectName.ToLower())",
  "version": "$Version",
  "description": "نظام شامل لإدارة طلبات العملاء والخدمات",
  "main": "index.html",
  "scripts": {
    "start": "live-server --port=3000 --host=localhost",
    "build": "echo 'Build process not configured yet'",
    "test": "echo 'No tests specified'"
  },
  "keywords": [
    "order-management",
    "crm",
    "arabic",
    "client-management"
  ],
  "author": "$Author",
  "license": "MIT"
}
"@
    
    $GitIgnore = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
*.min.js
*.min.css

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Temporary files
temp/
tmp/
*.tmp

# Database
*.sqlite
*.db

# Uploads
storage/uploads/*
!storage/uploads/.gitkeep

# Cache
storage/cache/*
!storage/cache/.gitkeep

# Sessions
storage/sessions/*
!storage/sessions/.gitkeep
"@
    
    $PackageJSON | Out-File -FilePath "package.json" -Encoding UTF8
    $GitIgnore | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Status "تم إنشاء ملفات الإعدادات"
    
    # Create additional files
    Write-Info "📋 إنشاء ملفات إضافية..."
    
    # Create .gitkeep files for empty directories
    @("storage/uploads", "storage/cache", "storage/sessions", "database/backups", "logs", "temp") | ForEach-Object {
        "" | Out-File -FilePath "$_/.gitkeep" -Encoding UTF8
    }
    
    # Create LICENSE file
    $License = @"
MIT License

Copyright (c) $(Get-Date -Format "yyyy") $Author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
    
    $License | Out-File -FilePath "LICENSE" -Encoding UTF8
    Write-Status "تم إنشاء الملفات الإضافية"
    
    # Show summary
    Write-Host ""
    Write-Header "📊 ملخص المشروع المُنشأ"
    Write-Host ""
    Write-Status "✅ تم إنشاء المشروع بنجاح!"
    Write-Host ""
    Write-Info "📁 اسم المشروع: $ProjectName"
    Write-Info "📅 تاريخ الإنشاء: $(Get-Date -Format 'yyyy-MM-dd')"
    Write-Info "🏷️ الإصدار: $Version"
    Write-Host ""
    
    # Count files and directories
    $FileCount = (Get-ChildItem -Recurse -File).Count
    $DirCount = (Get-ChildItem -Recurse -Directory).Count
    
    Write-Info "إحصائيات الملفات:"
    Write-Host "📄 إجمالي الملفات: $FileCount" -ForegroundColor $Colors.Cyan
    Write-Host "📁 إجمالي المجلدات: $DirCount" -ForegroundColor $Colors.Cyan
    Write-Host ""
    
    Write-Info "الخطوات التالية:"
    Write-Host "1. cd $ProjectName" -ForegroundColor $Colors.Yellow
    Write-Host "2. افتح index.html في المتصفح" -ForegroundColor $Colors.Yellow
    Write-Host "3. أو استخدم: npm install && npm start" -ForegroundColor $Colors.Yellow
    Write-Host ""
    
    Write-Header "🎉 تم إنشاء نظام إدارة الطلبات بنجاح!"
    Write-Status "المشروع جاهز للاستخدام والتطوير!"
    Write-Host ""
}

# Run the script
try {
    New-ProjectStructure
} catch {
    Write-Error "حدث خطأ أثناء إنشاء المشروع: $($_.Exception.Message)"
    Read-Host "اضغط Enter للخروج"
}

# Wait for user input before closing
Read-Host "اضغط Enter للخروج"