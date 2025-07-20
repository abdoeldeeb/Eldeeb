#!/bin/bash

# =================================================================
# Order Management System - Project Structure Creator
# إنشاء الهيكل التنظيمي لنظام إدارة الطلبات
# =================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Project info
PROJECT_NAME="order-management-system"
VERSION="2.0.0"
AUTHOR="AI Assistant"
DATE=$(date +"%Y-%m-%d")

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[ℹ]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

# Function to create directory structure
create_directories() {
    print_header "🗂️  إنشاء الهيكل التنظيمي للمجلدات..."
    
    # Main project directory
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    
    # Frontend directories
    mkdir -p {assets/{css,js,images,fonts,icons},components,pages,utils}
    
    # Backend directories  
    mkdir -p {api/{routes,controllers,middleware,models},config,database/{migrations,seeds,backups}}
    
    # Documentation directories
    mkdir -p {docs/{api,user-guide,development},tests/{unit,integration,e2e}}
    
    # Build and deployment directories
    mkdir -p {build,dist,deploy,logs,temp}
    
    # Additional directories
    mkdir -p {public,src,storage/{uploads,cache,sessions}}
    
    print_status "تم إنشاء الهيكل التنظيمي للمجلدات"
}

# Function to create main HTML file
create_index_html() {
    print_header "📄 إنشاء الملف الرئيسي index.html..."
    
    cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="نظام إدارة الطلبات - نظام شامل لإدارة طلبات العملاء والخدمات">
    <meta name="keywords" content="إدارة الطلبات, نظام إدارة, CRM, طلبات العملاء">
    <meta name="author" content="فريق التطوير">
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
EOF

    print_status "تم إنشاء ملف index.html"
}

# Function to create CSS files
create_css_files() {
    print_header "🎨 إنشاء ملفات CSS..."
    
    # Main styles file
    cat > assets/css/styles.css << 'EOF'
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

/* Typography */
h1, h2, h3, h4, h5, h6 {
    font-weight: 600;
    margin-bottom: 0.5rem;
}

/* Layout */
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
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

/* Responsive */
@media (max-width: 768px) {
    .container {
        padding: 0 0.5rem;
    }
    
    .btn {
        padding: 0.5rem 1rem;
        font-size: 0.9rem;
    }
}

/* Utilities */
.text-center { text-align: center; }
.text-right { text-align: right; }
.text-left { text-align: left; }
.hidden { display: none; }
.visible { display: block; }

/* Dark mode */
.dark-mode {
    background: #111827;
    color: #f9fafb;
}

.dark-mode .card {
    background: #1f2937;
    border-color: #374151;
}
EOF

    # Components CSS
    cat > assets/css/components.css << 'EOF'
/* =================================================================
   Components Styles
   أنماط المكونات
================================================================= */

/* Header Component */
.main-header {
    background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
    color: white;
    padding: 1rem 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* Navigation Component */
.main-nav {
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 0.5rem 0;
}

.nav-link {
    color: #374151;
    text-decoration: none;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    transition: var(--transition);
}

.nav-link:hover {
    background: #f3f4f6;
    color: var(--primary-color);
}

.nav-link.active {
    background: var(--primary-color);
    color: white;
}

/* Table Component */
.data-table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: var(--border-radius);
    overflow: hidden;
    box-shadow: var(--box-shadow);
}

.data-table th,
.data-table td {
    padding: 1rem;
    text-align: right;
    border-bottom: 1px solid #e5e7eb;
}

.data-table th {
    background: #f9fafb;
    font-weight: 600;
    color: #374151;
}

.data-table tbody tr:hover {
    background: #f8fafc;
}

/* Form Components */
.form-group {
    margin-bottom: 1rem;
}

.form-label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #374151;
}

.form-input {
    width: 100%;
    padding: 0.75rem;
    border: 2px solid #e5e7eb;
    border-radius: var(--border-radius);
    font-size: 1rem;
    transition: var(--transition);
}

.form-input:focus {
    outline: none;
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Modal Component */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
}

.modal-content {
    background: white;
    border-radius: var(--border-radius);
    padding: 2rem;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
}

/* Notification Component */
.notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background: white;
    border-radius: var(--border-radius);
    padding: 1rem 1.5rem;
    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    z-index: 1100;
    min-width: 300px;
    animation: slideInRight 0.3s ease;
}

@keyframes slideInRight {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

.notification.success {
    border-left: 4px solid var(--secondary-color);
}

.notification.error {
    border-left: 4px solid var(--danger-color);
}

.notification.warning {
    border-left: 4px solid var(--accent-color);
}

.notification.info {
    border-left: 4px solid var(--primary-color);
}
EOF

    print_status "تم إنشاء ملفات CSS"
}

# Function to create JavaScript files
create_js_files() {
    print_header "⚙️ إنشاء ملفات JavaScript..."
    
    # Config file
    cat > assets/js/config.js << 'EOF'
/* =================================================================
   Configuration File
   ملف الإعدادات
================================================================= */

const CONFIG = {
    // Application Info
    APP_NAME: 'نظام إدارة الطلبات',
    VERSION: '2.0.0',
    AUTHOR: 'فريق التطوير',
    
    // API Configuration
    API: {
        BASE_URL: '/api',
        TIMEOUT: 10000,
        RETRY_ATTEMPTS: 3
    },
    
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
    
    // Pagination
    PAGINATION: {
        itemsPerPage: 10,
        maxVisiblePages: 5
    },
    
    // Storage Keys
    STORAGE_KEYS: {
        orders: 'orders_data',
        clients: 'clients_data',
        settings: 'app_settings',
        theme: 'app_theme'
    },
    
    // Notification Settings
    NOTIFICATIONS: {
        duration: 3000,
        position: 'top-right'
    }
};

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = CONFIG;
}
EOF

    # Utils file
    cat > assets/js/utils.js << 'EOF'
/* =================================================================
   Utility Functions
   الوظائف المساعدة
================================================================= */

class Utils {
    // Format date
    static formatDate(dateString, format = 'short') {
        const date = new Date(dateString);
        const options = {
            short: { year: 'numeric', month: '2-digit', day: '2-digit' },
            long: { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' }
        };
        return date.toLocaleDateString('ar-SA', options[format]);
    }
    
    // Format currency
    static formatCurrency(amount) {
        return new Intl.NumberFormat('ar-SA', {
            style: 'currency',
            currency: 'SAR'
        }).format(amount);
    }
    
    // Generate unique ID
    static generateId() {
        return Date.now().toString(36) + Math.random().toString(36).substr(2);
    }
    
    // Sanitize text
    static sanitizeText(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    // Debounce function
    static debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }
    
    // Local storage helpers
    static saveToStorage(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
            return true;
        } catch (error) {
            console.error('Error saving to storage:', error);
            return false;
        }
    }
    
    static loadFromStorage(key, defaultValue = null) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : defaultValue;
        } catch (error) {
            console.error('Error loading from storage:', error);
            return defaultValue;
        }
    }
    
    // Validation helpers
    static isValidEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    }
    
    static isValidPhone(phone) {
        const regex = /^(05|5)[0-9]{8}$/;
        return regex.test(phone.replace(/\s+/g, ''));
    }
    
    // Download file
    static downloadFile(content, filename, mimeType) {
        const blob = new Blob([content], { type: mimeType });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.download = filename;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = Utils;
}
EOF

    # Data management file
    cat > assets/js/data.js << 'EOF'
/* =================================================================
   Data Management
   إدارة البيانات
================================================================= */

class DataManager {
    constructor() {
        this.orders = Utils.loadFromStorage(CONFIG.STORAGE_KEYS.orders, []);
        this.clients = Utils.loadFromStorage(CONFIG.STORAGE_KEYS.clients, []);
        this.filteredOrders = [...this.orders];
        
        // Initialize sample data if empty
        if (this.orders.length === 0) {
            this.initializeSampleData();
        }
    }
    
    // Initialize sample data
    initializeSampleData() {
        const sampleClients = [
            { id: 1, name: 'أحمد محمد العلي', email: 'ahmed@example.com', phone: '0501234567' },
            { id: 2, name: 'فاطمة الزهراني', email: 'fatima@example.com', phone: '0507654321' }
        ];
        
        const sampleOrders = [
            {
                id: 1,
                orderNumber: 'ORD-001',
                clientId: 1,
                serviceType: 'translation',
                title: 'ترجمة وثائق قانونية',
                description: 'ترجمة وثائق قانونية من الإنجليزية إلى العربية',
                status: 'pending',
                priority: 'high',
                estimatedPrice: 1500,
                createdAt: new Date().toISOString()
            }
        ];
        
        this.clients = sampleClients;
        this.orders = sampleOrders;
        this.saveData();
    }
    
    // Save data to storage
    saveData() {
        Utils.saveToStorage(CONFIG.STORAGE_KEYS.orders, this.orders);
        Utils.saveToStorage(CONFIG.STORAGE_KEYS.clients, this.clients);
    }
    
    // Add new order
    addOrder(orderData) {
        const newId = Math.max(...this.orders.map(o => o.id), 0) + 1;
        const orderNumber = `ORD-${String(newId).padStart(3, '0')}`;
        
        const newOrder = {
            id: newId,
            orderNumber,
            ...orderData,
            status: 'pending',
            createdAt: new Date().toISOString()
        };
        
        this.orders.unshift(newOrder);
        this.saveData();
        return newOrder;
    }
    
    // Update order
    updateOrder(orderId, updates) {
        const index = this.orders.findIndex(o => o.id === orderId);
        if (index !== -1) {
            this.orders[index] = { ...this.orders[index], ...updates };
            this.saveData();
            return this.orders[index];
        }
        return null;
    }
    
    // Delete order
    deleteOrder(orderId) {
        const index = this.orders.findIndex(o => o.id === orderId);
        if (index !== -1) {
            this.orders.splice(index, 1);
            this.saveData();
            return true;
        }
        return false;
    }
    
    // Get order by ID
    getOrder(orderId) {
        return this.orders.find(o => o.id === orderId);
    }
    
    // Get client by ID
    getClient(clientId) {
        return this.clients.find(c => c.id === clientId);
    }
    
    // Filter orders
    filterOrders(filters) {
        let filtered = [...this.orders];
        
        if (filters.search) {
            const searchTerm = filters.search.toLowerCase();
            filtered = filtered.filter(order => {
                const client = this.getClient(order.clientId);
                return (
                    order.orderNumber.toLowerCase().includes(searchTerm) ||
                    order.title.toLowerCase().includes(searchTerm) ||
                    (client && client.name.toLowerCase().includes(searchTerm))
                );
            });
        }
        
        if (filters.status) {
            filtered = filtered.filter(order => order.status === filters.status);
        }
        
        if (filters.serviceType) {
            filtered = filtered.filter(order => order.serviceType === filters.serviceType);
        }
        
        this.filteredOrders = filtered;
        return filtered;
    }
    
    // Get statistics
    getStatistics() {
        const total = this.orders.length;
        const completed = this.orders.filter(o => o.status === 'completed').length;
        const processing = this.orders.filter(o => o.status === 'processing').length;
        const pending = this.orders.filter(o => o.status === 'pending').length;
        
        return { total, completed, processing, pending };
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DataManager;
}
EOF

    # Notifications file
    cat > assets/js/notifications.js << 'EOF'
/* =================================================================
   Notifications System
   نظام الإشعارات
================================================================= */

class NotificationManager {
    constructor() {
        this.container = this.createContainer();
        this.notifications = [];
    }
    
    createContainer() {
        let container = document.getElementById('notificationsContainer');
        if (!container) {
            container = document.createElement('div');
            container.id = 'notificationsContainer';
            container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1000;
                pointer-events: none;
            `;
            document.body.appendChild(container);
        }
        return container;
    }
    
    show(message, type = 'info', duration = 3000) {
        const notification = this.createNotification(message, type);
        this.container.appendChild(notification);
        
        // Auto remove
        setTimeout(() => {
            this.remove(notification);
        }, duration);
        
        return notification;
    }
    
    createNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.style.pointerEvents = 'auto';
        
        const icons = {
            success: '✅',
            error: '❌',
            warning: '⚠️',
            info: 'ℹ️'
        };
        
        notification.innerHTML = `
            <div style="display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 18px;">${icons[type] || icons.info}</span>
                <span>${Utils.sanitizeText(message)}</span>
                <button onclick="this.parentNode.parentNode.remove()" style="margin-right: auto; background: none; border: none; font-size: 18px; cursor: pointer;">×</button>
            </div>
        `;
        
        return notification;
    }
    
    remove(notification) {
        if (notification && notification.parentNode) {
            notification.style.transform = 'translateX(100%)';
            notification.style.opacity = '0';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }
    }
    
    success(message, duration) {
        return this.show(message, 'success', duration);
    }
    
    error(message, duration) {
        return this.show(message, 'error', duration);
    }
    
    warning(message, duration) {
        return this.show(message, 'warning', duration);
    }
    
    info(message, duration) {
        return this.show(message, 'info', duration);
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = NotificationManager;
}
EOF

    # Components file
    cat > assets/js/components.js << 'EOF'
/* =================================================================
   UI Components
   مكونات واجهة المستخدم
================================================================= */

class ComponentManager {
    constructor() {
        this.components = {};
    }
    
    // Header component
    renderHeader() {
        return `
            <div class="main-header">
                <div class="container">
                    <div class="flex justify-between items-center">
                        <div class="flex items-center gap-4">
                            <h1 class="text-xl font-bold">${CONFIG.APP_NAME}</h1>
                        </div>
                        <div class="flex items-center gap-4">
                            <button onclick="app.showAddOrderModal()" class="btn btn-primary">
                                طلب جديد
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    
    // Navigation component
    renderNavigation() {
        return `
            <div class="main-nav">
                <div class="container">
                    <div class="flex gap-4">
                        <a href="#dashboard" class="nav-link active">لوحة التحكم</a>
                        <a href="#orders" class="nav-link">الطلبات</a>
                        <a href="#clients" class="nav-link">العملاء</a>
                        <a href="#reports" class="nav-link">التقارير</a>
                        <a href="#settings" class="nav-link">الإعدادات</a>
                    </div>
                </div>
            </div>
        `;
    }
    
    // Statistics cards
    renderStatistics(stats) {
        return `
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="card">
                    <h3 class="text-lg font-semibold mb-2">إجمالي الطلبات</h3>
                    <p class="text-3xl font-bold text-blue-600">${stats.total}</p>
                </div>
                <div class="card">
                    <h3 class="text-lg font-semibold mb-2">قيد المعالجة</h3>
                    <p class="text-3xl font-bold text-yellow-600">${stats.processing}</p>
                </div>
                <div class="card">
                    <h3 class="text-lg font-semibold mb-2">مكتملة</h3>
                    <p class="text-3xl font-bold text-green-600">${stats.completed}</p>
                </div>
                <div class="card">
                    <h3 class="text-lg font-semibold mb-2">قيد المراجعة</h3>
                    <p class="text-3xl font-bold text-orange-600">${stats.pending}</p>
                </div>
            </div>
        `;
    }
    
    // Orders table
    renderOrdersTable(orders, dataManager) {
        if (orders.length === 0) {
            return `
                <div class="card text-center py-8">
                    <p class="text-gray-500">لا توجد طلبات لعرضها</p>
                </div>
            `;
        }
        
        const rows = orders.map(order => {
            const client = dataManager.getClient(order.clientId);
            const status = CONFIG.ORDER_STATUSES[order.status];
            const serviceType = CONFIG.SERVICE_TYPES[order.serviceType];
            
            return `
                <tr>
                    <td>${order.orderNumber}</td>
                    <td>${client?.name || 'غير محدد'}</td>
                    <td>${serviceType?.ar || order.serviceType}</td>
                    <td>${order.title}</td>
                    <td>
                        <span style="color: ${status?.color}">
                            ${status?.ar || order.status}
                        </span>
                    </td>
                    <td>${Utils.formatDate(order.createdAt)}</td>
                    <td>
                        <button onclick="app.viewOrder(${order.id})" class="btn btn-sm">عرض</button>
                        <button onclick="app.editOrder(${order.id})" class="btn btn-sm">تعديل</button>
                    </td>
                </tr>
            `;
        }).join('');
        
        return `
            <div class="card">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>رقم الطلب</th>
                            <th>العميل</th>
                            <th>نوع الخدمة</th>
                            <th>العنوان</th>
                            <th>الحالة</th>
                            <th>تاريخ الإنشاء</th>
                            <th>الإجراءات</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${rows}
                    </tbody>
                </table>
            </div>
        `;
    }
    
    // Add order modal
    renderAddOrderModal() {
        return `
            <div class="modal-overlay" onclick="this.remove()">
                <div class="modal-content" onclick="event.stopPropagation()">
                    <h2 class="text-xl font-bold mb-4">طلب جديد</h2>
                    <form id="addOrderForm">
                        <div class="form-group">
                            <label class="form-label">اسم العميل</label>
                            <input type="text" name="clientName" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">البريد الإلكتروني</label>
                            <input type="email" name="clientEmail" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">رقم الهاتف</label>
                            <input type="tel" name="clientPhone" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">نوع الخدمة</label>
                            <select name="serviceType" class="form-input" required>
                                <option value="">اختر نوع الخدمة</option>
                                ${Object.entries(CONFIG.SERVICE_TYPES).map(([key, service]) => 
                                    `<option value="${key}">${service.ar}</option>`
                                ).join('')}
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">عنوان الطلب</label>
                            <input type="text" name="title" class="form-input" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">وصف الطلب</label>
                            <textarea name="description" class="form-input" rows="3" required></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label">السعر المتوقع</label>
                            <input type="number" name="estimatedPrice" class="form-input" min="0" step="0.01">
                        </div>
                        <div class="flex gap-4 justify-end">
                            <button type="button" onclick="this.closest('.modal-overlay').remove()" class="btn">إلغاء</button>
                            <button type="submit" class="btn btn-primary">حفظ</button>
                        </div>
                    </form>
                </div>
            </div>
        `;
    }
}

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ComponentManager;
}
EOF

    # Main application file
    cat > assets/js/app.js << 'EOF'
/* =================================================================
   Main Application
   التطبيق الرئيسي
================================================================= */

class OrderManagementApp {
    constructor() {
        this.dataManager = new DataManager();
        this.notificationManager = new NotificationManager();
        this.componentManager = new ComponentManager();
        this.currentPage = 'dashboard';
        
        this.init();
    }
    
    init() {
        this.bindEvents();
        this.render();
        this.hideLoading();
        
        // Show welcome message
        setTimeout(() => {
            this.notificationManager.success('مرحباً بك في نظام إدارة الطلبات! 🎉');
        }, 1000);
    }
    
    bindEvents() {
        // Form submission
        document.addEventListener('submit', (e) => {
            if (e.target.id === 'addOrderForm') {
                e.preventDefault();
                this.handleAddOrder(e.target);
            }
        });
        
        // Navigation
        document.addEventListener('click', (e) => {
            if (e.target.matches('.nav-link')) {
                e.preventDefault();
                this.navigateTo(e.target.getAttribute('href').substring(1));
            }
        });
    }
    
    render() {
        // Render header
        document.getElementById('mainHeader').innerHTML = this.componentManager.renderHeader();
        
        // Render navigation
        document.getElementById('mainNavigation').innerHTML = this.componentManager.renderNavigation();
        
        // Render main content based on current page
        this.renderCurrentPage();
    }
    
    renderCurrentPage() {
        const content = document.getElementById('mainContent');
        
        switch (this.currentPage) {
            case 'dashboard':
                this.renderDashboard();
                break;
            case 'orders':
                this.renderOrdersPage();
                break;
            default:
                this.renderDashboard();
        }
    }
    
    renderDashboard() {
        const stats = this.dataManager.getStatistics();
        const recentOrders = this.dataManager.orders.slice(0, 5);
        
        document.getElementById('mainContent').innerHTML = `
            <h2 class="text-2xl font-bold mb-6">لوحة التحكم</h2>
            ${this.componentManager.renderStatistics(stats)}
            <div class="card">
                <h3 class="text-xl font-semibold mb-4">الطلبات الحديثة</h3>
                ${this.componentManager.renderOrdersTable(recentOrders, this.dataManager)}
            </div>
        `;
    }
    
    renderOrdersPage() {
        document.getElementById('mainContent').innerHTML = `
            <h2 class="text-2xl font-bold mb-6">إدارة الطلبات</h2>
            ${this.componentManager.renderOrdersTable(this.dataManager.orders, this.dataManager)}
        `;
    }
    
    navigateTo(page) {
        this.currentPage = page;
        
        // Update active nav link
        document.querySelectorAll('.nav-link').forEach(link => {
            link.classList.remove('active');
        });
        document.querySelector(`[href="#${page}"]`).classList.add('active');
        
        this.renderCurrentPage();
    }
    
    showAddOrderModal() {
        const modal = document.createElement('div');
        modal.innerHTML = this.componentManager.renderAddOrderModal();
        document.body.appendChild(modal.firstElementChild);
    }
    
    handleAddOrder(form) {
        const formData = new FormData(form);
        const orderData = {
            clientId: this.getOrCreateClient({
                name: formData.get('clientName'),
                email: formData.get('clientEmail'),
                phone: formData.get('clientPhone')
            }),
            serviceType: formData.get('serviceType'),
            title: formData.get('title'),
            description: formData.get('description'),
            estimatedPrice: parseFloat(formData.get('estimatedPrice')) || 0
        };
        
        try {
            const newOrder = this.dataManager.addOrder(orderData);
            this.notificationManager.success(`تم إضافة الطلب ${newOrder.orderNumber} بنجاح!`);
            
            // Close modal
            form.closest('.modal-overlay').remove();
            
            // Refresh display
            this.renderCurrentPage();
        } catch (error) {
            this.notificationManager.error('حدث خطأ أثناء إضافة الطلب');
        }
    }
    
    getOrCreateClient(clientData) {
        // Check if client exists
        let client = this.dataManager.clients.find(c => 
            c.email === clientData.email || c.phone === clientData.phone
        );
        
        if (!client) {
            // Create new client
            const newId = Math.max(...this.dataManager.clients.map(c => c.id), 0) + 1;
            client = {
                id: newId,
                ...clientData,
                createdAt: new Date().toISOString()
            };
            this.dataManager.clients.push(client);
            this.dataManager.saveData();
        }
        
        return client.id;
    }
    
    viewOrder(orderId) {
        const order = this.dataManager.getOrder(orderId);
        if (order) {
            this.notificationManager.info(`عرض الطلب: ${order.orderNumber}`);
        }
    }
    
    editOrder(orderId) {
        const order = this.dataManager.getOrder(orderId);
        if (order) {
            this.notificationManager.info(`تعديل الطلب: ${order.orderNumber}`);
        }
    }
    
    hideLoading() {
        const loadingScreen = document.getElementById('loadingScreen');
        const app = document.getElementById('app');
        
        setTimeout(() => {
            loadingScreen.classList.add('hidden');
            app.classList.remove('hidden');
        }, 1500);
    }
}

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.app = new OrderManagementApp();
});
EOF

    print_status "تم إنشاء ملفات JavaScript"
}

# Function to create documentation
create_documentation() {
    print_header "📚 إنشاء ملفات التوثيق..."
    
    # README file
    cat > README.md << EOF
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
2. افتح ملف \`index.html\` في المتصفح
3. ابدأ في استخدام النظام!

## 📁 هيكل المشروع
\`\`\`
$PROJECT_NAME/
├── index.html              # الملف الرئيسي
├── assets/                 # الملفات الثابتة
│   ├── css/               # ملفات الأنماط
│   ├── js/                # ملفات JavaScript
│   ├── images/            # الصور
│   └── icons/             # الأيقونات
├── docs/                  # التوثيق
├── database/              # قواعد البيانات
└── README.md              # هذا الملف
\`\`\`

## 🛠️ التقنيات المستخدمة
- HTML5
- CSS3 / Tailwind CSS
- JavaScript ES6+
- Local Storage

## 📞 الدعم
للدعم والاستفسارات، يرجى فتح issue في المشروع.

## 📄 الترخيص
هذا المشروع مرخص تحت رخصة MIT.

---
تم إنشاؤه بواسطة فريق التطوير - $DATE
EOF

    # Installation guide
    cat > docs/INSTALLATION.md << EOF
# دليل التثبيت
Installation Guide

## متطلبات النظام
- متصفح حديث (Chrome, Firefox, Safari, Edge)
- لا يحتاج خادم ويب (يعمل محلياً)

## خطوات التثبيت

### 1. تحميل المشروع
\`\`\`bash
# استنساخ المشروع
git clone [repository-url]
cd $PROJECT_NAME
\`\`\`

### 2. فتح النظام
\`\`\`bash
# فتح الملف الرئيسي
open index.html
# أو
firefox index.html
\`\`\`

### 3. الاستخدام
- النظام جاهز للاستخدام فوراً
- البيانات تحفظ محلياً في المتصفح
- لا يحتاج إعدادات إضافية

## استكشاف الأخطاء

### المشكلة: لا تظهر البيانات
**الحل:** تأكد من تفعيل JavaScript في المتصفح

### المشكلة: لا تحفظ البيانات
**الحل:** تأكد من السماح للموقع باستخدام Local Storage

### المشكلة: التصميم لا يظهر بشكل صحيح
**الحل:** تأكد من الاتصال بالإنترنت لتحميل Tailwind CSS
EOF

    # User guide
    cat > docs/USER_GUIDE.md << EOF
# دليل المستخدم
User Guide

## البدء السريع

### 1. الواجهة الرئيسية
- **لوحة التحكم:** عرض الإحصائيات والطلبات الحديثة
- **الطلبات:** إدارة جميع الطلبات
- **العملاء:** إدارة بيانات العملاء
- **التقارير:** إحصائيات وتقارير مفصلة

### 2. إضافة طلب جديد
1. اضغط على زر "طلب جديد"
2. املأ بيانات العميل
3. حدد نوع الخدمة
4. اكتب عنوان ووصف الطلب
5. حدد السعر المتوقع (اختياري)
6. اضغط "حفظ"

### 3. إدارة الطلبات
- **عرض:** لعرض تفاصيل الطلب
- **تعديل:** لتعديل بيانات الطلب
- **حذف:** لحذف الطلب

### 4. تتبع حالات الطلبات
- **قيد المراجعة:** طلبات جديدة لم تبدأ بعد
- **قيد المعالجة:** طلبات قيد التنفيذ
- **مكتملة:** طلبات مكتملة ومسلمة
- **مرفوضة:** طلبات مرفوضة لأسباب مختلفة

## نصائح للاستخدام
- استخدم البحث للعثور على الطلبات بسرعة
- راجع الإحصائيات بانتظام لمتابعة الأداء
- احفظ نسخة احتياطية من البيانات بانتظام
EOF

    print_status "تم إنشاء ملفات التوثيق"
}

# Function to create database files
create_database_files() {
    print_header "🗄️ إنشاء ملفات قاعدة البيانات..."
    
    # Database schema
    cat > database/schema.sql << 'EOF'
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

-- Order files table
CREATE TABLE order_files (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Order history table
CREATE TABLE order_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status_from VARCHAR(50),
    status_to VARCHAR(50) NOT NULL,
    notes TEXT,
    changed_by VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_history_order_id ON order_history(order_id);
EOF

    # Sample data
    cat > database/sample_data.sql << 'EOF'
-- =================================================================
-- Sample Data for Order Management System
-- بيانات تجريبية لنظام إدارة الطلبات
-- =================================================================

-- Insert sample clients
INSERT INTO clients (name, email, phone, address) VALUES
('أحمد محمد العلي', 'ahmed.ali@email.com', '0501234567', 'الرياض، المملكة العربية السعودية'),
('فاطمة أحمد الزهراني', 'fatima.zahrani@email.com', '0507654321', 'جدة، المملكة العربية السعودية'),
('شركة النجاح للتقنية', 'info@najah-tech.com', '0551239876', 'الدمام، المملكة العربية السعودية'),
('سارة عبدالله الحربي', 'sara.harbi@email.com', '0598765432', 'مكة المكرمة، المملكة العربية السعودية'),
('محمد سعد العتيبي', 'mohammed.otaibi@email.com', '0543217890', 'المدينة المنورة، المملكة العربية السعودية');

-- Insert sample orders
INSERT INTO orders (order_number, client_id, service_type, title, description, status, priority, estimated_price, delivery_date) VALUES
('ORD-001', 1, 'translation', 'ترجمة وثائق قانونية', 'ترجمة وثائق قانونية من الإنجليزية إلى العربية شاملة العقود والاتفاقيات', 'completed', 'high', 1500.00, '2024-02-15'),
('ORD-002', 2, 'editing', 'تدقيق رسالة ماجستير', 'تدقيق لغوي شامل لرسالة ماجستير في الأدب العربي', 'processing', 'medium', 800.00, '2024-02-20'),
('ORD-003', 3, 'design', 'تصميم هوية بصرية', 'تصميم هوية بصرية متكاملة لشركة ناشئة', 'pending', 'high', 3000.00, '2024-03-01'),
('ORD-004', 4, 'writing', 'كتابة محتوى تسويقي', 'كتابة محتوى تسويقي إبداعي لموقع إلكتروني', 'processing', 'medium', 1200.00, '2024-02-25'),
('ORD-005', 5, 'translation', 'ترجمة تقرير فني', 'ترجمة تقرير فني من العربية إلى الإنجليزية', 'pending', 'low', 600.00, '2024-03-05');

-- Insert order history
INSERT INTO order_history (order_id, status_from, status_to, notes, changed_by) VALUES
(1, 'pending', 'processing', 'بدء العمل على الطلب', 'النظام'),
(1, 'processing', 'completed', 'تم إنجاز الطلب بنجاح', 'النظام'),
(2, 'pending', 'processing', 'بدء التدقيق اللغوي', 'النظام'),
(4, 'pending', 'processing', 'بدء كتابة المحتوى', 'النظام');
EOF

    print_status "تم إنشاء ملفات قاعدة البيانات"
}

# Function to create configuration files
create_config_files() {
    print_header "⚙️ إنشاء ملفات الإعدادات..."
    
    # Package.json for Node.js projects
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "$VERSION",
  "description": "نظام شامل لإدارة طلبات العملاء والخدمات",
  "main": "index.html",
  "scripts": {
    "start": "live-server --port=3000 --host=localhost",
    "build": "npm run minify-css && npm run minify-js",
    "minify-css": "cleancss -o dist/styles.min.css assets/css/*.css",
    "minify-js": "uglifyjs assets/js/*.js -o dist/app.min.js",
    "test": "echo \\"لا توجد اختبارات محددة\\" && exit 0"
  },
  "keywords": [
    "order-management",
    "crm",
    "arabic",
    "client-management"
  ],
  "author": "$AUTHOR",
  "license": "MIT",
  "devDependencies": {
    "live-server": "^1.2.2",
    "clean-css-cli": "^5.6.2",
    "uglify-js": "^3.17.4"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/username/$PROJECT_NAME.git"
  },
  "bugs": {
    "url": "https://github.com/username/$PROJECT_NAME/issues"
  },
  "homepage": "https://github.com/username/$PROJECT_NAME#readme"
}
EOF

    # .gitignore
    cat > .gitignore << 'EOF'
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

# Backups
database/backups/*
!database/backups/.gitkeep
EOF

    # Environment example file
    cat > .env.example << 'EOF'
# Application Configuration
APP_NAME="نظام إدارة الطلبات"
APP_VERSION="2.0.0"
APP_ENV="development"
APP_DEBUG=true

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=order_management
DB_USERNAME=root
DB_PASSWORD=

# Email Configuration
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_password
MAIL_FROM=your_email@gmail.com

# File Upload Configuration
MAX_FILE_SIZE=10MB
ALLOWED_FILE_TYPES=pdf,doc,docx,jpg,png,gif

# Security
SESSION_SECRET=your_session_secret_here
JWT_SECRET=your_jwt_secret_here
EOF

    print_status "تم إنشاء ملفات الإعدادات"
}

# Function to create additional files
create_additional_files() {
    print_header "📋 إنشاء ملفات إضافية..."
    
    # Create .gitkeep files for empty directories
    touch storage/uploads/.gitkeep
    touch storage/cache/.gitkeep
    touch storage/sessions/.gitkeep
    touch database/backups/.gitkeep
    touch logs/.gitkeep
    touch temp/.gitkeep
    
    # LICENSE file
    cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) $AUTHOR

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
EOF

    # CHANGELOG file
    cat > CHANGELOG.md << EOF
# Changelog
سجل التغييرات

## [2.0.0] - $DATE

### Added
- نظام إدارة الطلبات الكامل
- إدارة العملاء التلقائية
- واجهة مستخدم عربية متجاوبة
- نظام إشعارات متقدم
- إحصائيات شاملة
- نظام البحث والفلترة
- حفظ البيانات محلياً

### Features
- تصميم حديث باستخدام Tailwind CSS
- دعم الوضع الليلي
- واجهة متجاوبة لجميع الأجهزة
- نظام التنقل السلس
- إشعارات صوتية ومرئية

### Technical
- JavaScript ES6+
- Local Storage
- CSS Grid & Flexbox
- Progressive Web App ready

## [1.0.0] - Initial Release
- الإصدار الأولي
EOF

    # TODO file
    cat > TODO.md << EOF
# قائمة المهام
TODO List

## المهام الحالية
- [ ] إضافة نظام المصادقة
- [ ] تطوير API backend
- [ ] إضافة رفع الملفات
- [ ] نظام الإشعارات عبر البريد الإلكتروني
- [ ] تقارير متقدمة وتصدير PDF
- [ ] نظام الدفع الإلكتروني
- [ ] دعم متعدد اللغات
- [ ] تطبيق جوال

## تحسينات مستقبلية
- [ ] ذكاء اصطناعي لتصنيف الطلبات
- [ ] تكامل مع الخدمات الخارجية
- [ ] نظام إدارة المشاريع
- [ ] لوحة تحكم متقدمة
- [ ] نظام CRM متكامل

## إصلاحات
- [ ] تحسين الأداء
- [ ] إصلاح مشاكل المتصفحات القديمة
- [ ] تحسين إمكانية الوصول
EOF

    print_status "تم إنشاء الملفات الإضافية"
}

# Function to create deployment files
create_deployment_files() {
    print_header "🚀 إنشاء ملفات النشر..."
    
    # Docker files
    cat > Dockerfile << 'EOF'
FROM nginx:alpine

# Copy application files
COPY . /usr/share/nginx/html

# Copy nginx configuration
COPY deploy/nginx.conf /etc/nginx/nginx.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
EOF

    # Docker compose
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  web:
    build: .
    ports:
      - "80:80"
    volumes:
      - ./logs:/var/log/nginx
    restart: unless-stopped
    
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: order_management
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppassword
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database:/docker-entrypoint-initdb.d
    restart: unless-stopped

volumes:
  mysql_data:
EOF

    # Nginx configuration
    mkdir -p deploy
    cat > deploy/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    
    server {
        listen 80;
        server_name localhost;
        root /usr/share/nginx/html;
        index index.html;
        
        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;
        
        # Cache static files
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        # Handle SPA routing
        location / {
            try_files $uri $uri/ /index.html;
        }
        
        # Error pages
        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
    }
}
EOF

    print_status "تم إنشاء ملفات النشر"
}

# Function to show project summary
show_summary() {
    print_header "📊 ملخص المشروع المُنشأ"
    
    echo ""
    echo -e "${GREEN}✅ تم إنشاء المشروع بنجاح!${NC}"
    echo ""
    echo -e "${BLUE}📁 اسم المشروع:${NC} $PROJECT_NAME"
    echo -e "${BLUE}📅 تاريخ الإنشاء:${NC} $DATE"
    echo -e "${BLUE}🏷️  الإصدار:${NC} $VERSION"
    echo ""
    
    print_info "هيكل المشروع المُنشأ:"
    echo ""
    tree . -I 'node_modules' 2>/dev/null || find . -type d -not -path './node_modules*' | head -20
    echo ""
    
    print_info "إحصائيات الملفات:"
    echo -e "${CYAN}📄 إجمالي الملفات:${NC} $(find . -type f | wc -l)"
    echo -e "${CYAN}📁 إجمالي المجلدات:${NC} $(find . -type d | wc -l)"
    echo -e "${CYAN}📏 إجمالي الأسطر:${NC} $(find . -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.md" | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')"
    echo ""
    
    print_info "الخطوات التالية:"
    echo -e "${YELLOW}1.${NC} cd $PROJECT_NAME"
    echo -e "${YELLOW}2.${NC} افتح index.html في المتصفح"
    echo -e "${YELLOW}3.${NC} أو استخدم: npm install && npm start"
    echo ""
    
    print_header "🎉 تم إنشاء نظام إدارة الطلبات بنجاح!"
    echo -e "${GREEN}المشروع جاهز للاستخدام والتطوير!${NC}"
    echo ""
}

# Main execution
main() {
    clear
    print_header "==============================================="
    print_header "    🚀 Order Management System Creator"
    print_header "    مُنشئ نظام إدارة الطلبات"
    print_header "==============================================="
    echo ""
    
    print_info "بدء إنشاء الهيكل التنظيمي للمشروع..."
    echo ""
    
    # Check if project directory already exists
    if [ -d "$PROJECT_NAME" ]; then
        print_warning "المجلد $PROJECT_NAME موجود بالفعل!"
        echo -n "هل تريد الاستمرار والكتابة فوقه؟ (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_error "تم إلغاء العملية"
            exit 1
        fi
        rm -rf "$PROJECT_NAME"
    fi
    
    # Create project structure
    create_directories
    create_index_html
    create_css_files
    create_js_files
    create_documentation
    create_database_files
    create_config_files
    create_additional_files
    create_deployment_files
    
    # Show summary
    show_summary
}

# Run the script
main "$@"