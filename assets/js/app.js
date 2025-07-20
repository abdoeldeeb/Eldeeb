/**
 * ==========================================================================
 * نظام إدارة الطلبات - الملف الرئيسي للتطبيق
 * ==========================================================================
 */

/**
 * كائن التطبيق الرئيسي
 */
const OrderManagementApp = {
    // حالة التطبيق
    state: {
        initialized: false,
        loading: false,
        currentView: 'table',
        selectedOrders: [],
        lastRefresh: null
    },

    /**
     * تهيئة التطبيق
     */
    async init() {
        if (this.state.initialized) {
            console.warn('التطبيق مُهيأ مسبقاً');
            return;
        }

        console.log('🚀 بدء تهيئة نظام إدارة الطلبات...');
        
        try {
            this.state.loading = true;
            
            // تهيئة المكونات الأساسية
            await this.initializeComponents();
            
            // تحميل البيانات
            await this.loadData();
            
            // تهيئة واجهة المستخدم
            await this.initializeUI();
            
            // ربط الأحداث
            this.bindEvents();
            
            // وضع علامة التهيئة
            this.state.initialized = true;
            this.state.loading = false;
            this.state.lastRefresh = new Date();
            
            console.log('✅ تم تهيئة النظام بنجاح');
            
            // عرض رسالة ترحيب
            showSuccessNotification(
                'مرحباً بك!', 
                'تم تحميل نظام إدارة الطلبات بنجاح'
            );
            
        } catch (error) {
            console.error('❌ خطأ في تهيئة التطبيق:', error);
            this.state.loading = false;
            
            showErrorNotification(
                'خطأ في التهيئة',
                'فشل في تحميل النظام. يرجى إعادة تحميل الصفحة.'
            );
        }
    },

    /**
     * تهيئة المكونات الأساسية
     */
    async initializeComponents() {
        console.log('📦 تهيئة المكونات...');
        
        // تهيئة نظام الإشعارات
        if (typeof initNotifications === 'function') {
            initNotifications();
        }
        
        // تهيئة المكونات الأخرى
        await Promise.all([
            this.checkBrowserSupport(),
            this.setupErrorHandling(),
            this.loadUserPreferences()
        ]);
    },

    /**
     * فحص دعم المتصفح
     */
    async checkBrowserSupport() {
        const requiredFeatures = ['localStorage', 'flexbox', 'grid'];
        const unsupportedFeatures = [];
        
        // فحص LocalStorage
        if (!supportsFeature('localStorage')) {
            unsupportedFeatures.push('التخزين المحلي');
        }
        
        // فحص CSS Grid و Flexbox
        const testElement = document.createElement('div');
        testElement.style.display = 'grid';
        if (testElement.style.display !== 'grid') {
            unsupportedFeatures.push('CSS Grid');
        }
        
        testElement.style.display = 'flex';
        if (testElement.style.display !== 'flex') {
            unsupportedFeatures.push('CSS Flexbox');
        }
        
        if (unsupportedFeatures.length > 0) {
            showWarningNotification(
                'تحذير: متصفح قديم',
                `بعض الميزات قد لا تعمل بشكل صحيح: ${unsupportedFeatures.join(', ')}`
            );
        }
    },

    /**
     * إعداد معالجة الأخطاء العامة
     */
    setupErrorHandling() {
        // معالجة الأخطاء غير المتوقعة
        window.addEventListener('error', (event) => {
            console.error('خطأ غير متوقع:', event.error);
            showErrorNotification(
                'خطأ في النظام',
                'حدث خطأ غير متوقع. يرجى إعادة تحميل الصفحة.'
            );
        });

        // معالجة الوعود المرفوضة
        window.addEventListener('unhandledrejection', (event) => {
            console.error('وعد مرفوض:', event.reason);
            event.preventDefault();
        });
    },

    /**
     * تحميل تفضيلات المستخدم
     */
    async loadUserPreferences() {
        try {
            const saved = localStorage.getItem(CONFIG.STORAGE.PREFIX + CONFIG.STORAGE.SETTINGS_KEY);
            if (saved) {
                const preferences = JSON.parse(saved);
                this.applyPreferences(preferences);
            }
        } catch (error) {
            console.warn('فشل في تحميل تفضيلات المستخدم:', error);
        }
    },

    /**
     * تطبيق التفضيلات
     */
    applyPreferences(preferences) {
        // تطبيق عدد السجلات المفضل
        if (preferences.recordsPerPage) {
            recordsPerPage = preferences.recordsPerPage;
            const select = document.getElementById('recordsPerPage');
            if (select) {
                select.value = preferences.recordsPerPage;
            }
        }

        // تطبيق تفضيلات أخرى
        if (preferences.theme) {
            document.body.classList.add(`theme-${preferences.theme}`);
        }
    },

    /**
     * تحميل البيانات
     */
    async loadData() {
        console.log('📊 تحميل البيانات...');
        
        try {
            // تهيئة البيانات
            const stats = initializeData();
            
            // تحديث الإحصائيات
            this.updateStats(stats);
            
            console.log(`📈 تم تحميل ${stats.total} طلب`);
            
        } catch (error) {
            console.error('خطأ في تحميل البيانات:', error);
            throw error;
        }
    },

    /**
     * تهيئة واجهة المستخدم
     */
    async initializeUI() {
        console.log('🎨 تهيئة واجهة المستخدم...');
        
        try {
            // تهيئة الجدول
            if (typeof renderTable === 'function') {
                renderTable();
            }
            
            // تهيئة الفلاتر
            if (typeof initializeFilters === 'function') {
                initializeFilters();
            }
            
            // إنشاء النوافذ المنبثقة
            if (typeof createModals === 'function') {
                createModals();
            }
            
        } catch (error) {
            console.error('خطأ في تهيئة واجهة المستخدم:', error);
            throw error;
        }
    },

    /**
     * ربط الأحداث
     */
    bindEvents() {
        console.log('🔗 ربط الأحداث...');
        
        // أحداث النوافذ
        this.bindWindowEvents();
        
        // أحداث لوحة المفاتيح
        this.bindKeyboardEvents();
        
        // أحداث الأزرار الرئيسية
        this.bindMainButtons();
        
        // أحداث التحديث
        this.bindRefreshEvents();
    },

    /**
     * ربط أحداث النافذة
     */
    bindWindowEvents() {
        // تحديث الجدول عند تغيير حجم النافذة
        window.addEventListener('resize', debounce(() => {
            if (typeof adjustTableLayout === 'function') {
                adjustTableLayout();
            }
        }, 250));

        // حفظ البيانات قبل إغلاق الصفحة
        window.addEventListener('beforeunload', () => {
            this.saveCurrentState();
        });

        // استعادة التركيز عند العودة للصفحة
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden) {
                this.handlePageVisible();
            }
        });
    },

    /**
     * ربط أحداث لوحة المفاتيح
     */
    bindKeyboardEvents() {
        document.addEventListener('keydown', (e) => {
            // Ctrl+N لطلب جديد
            if (e.ctrlKey && e.key === 'n') {
                e.preventDefault();
                this.createNewOrder();
            }
            
            // Ctrl+F للبحث
            if (e.ctrlKey && e.key === 'f') {
                e.preventDefault();
                const searchInput = document.getElementById('searchInput');
                if (searchInput) {
                    searchInput.focus();
                }
            }
            
            // Ctrl+R للتحديث
            if (e.ctrlKey && e.key === 'r') {
                e.preventDefault();
                this.refreshData();
            }
            
            // F5 للتحديث
            if (e.key === 'F5') {
                e.preventDefault();
                this.refreshData();
            }
        });
    },

    /**
     * ربط أحداث الأزرار الرئيسية
     */
    bindMainButtons() {
        // زر طلب جديد
        const newOrderBtn = document.querySelector('[onclick="showNewOrderModal()"]');
        if (newOrderBtn) {
            newOrderBtn.onclick = null; // إزالة الحدث القديم
            newOrderBtn.addEventListener('click', () => this.createNewOrder());
        }

        // زر التصدير
        const exportBtn = document.querySelector('[onclick="exportRecords()"]');
        if (exportBtn) {
            exportBtn.onclick = null;
            exportBtn.addEventListener('click', () => this.exportData());
        }
    },

    /**
     * ربط أحداث التحديث
     */
    bindRefreshEvents() {
        // تحديث تلقائي كل 5 دقائق (اختياري)
        setInterval(() => {
            if (!document.hidden) {
                this.autoRefresh();
            }
        }, 5 * 60 * 1000);
    },

    /**
     * إنشاء طلب جديد
     */
    createNewOrder() {
        if (typeof showNewOrderModal === 'function') {
            showNewOrderModal();
        } else {
            showInfoNotification('قيد التطوير', 'ميزة إضافة طلب جديد قيد التطوير');
        }
    },

    /**
     * تصدير البيانات
     */
    exportData() {
        try {
            const csvContent = exportToCSV();
            const timestamp = new Date().toISOString().split('T')[0];
            downloadFile(csvContent, `orders_${timestamp}.csv`, 'text/csv;charset=utf-8');
            
            showSuccessNotification('تم التصدير', 'تم تصدير البيانات بنجاح');
        } catch (error) {
            console.error('خطأ في التصدير:', error);
            showErrorNotification('خطأ في التصدير', 'فشل في تصدير البيانات');
        }
    },

    /**
     * تحديث البيانات
     */
    async refreshData() {
        if (this.state.loading) return;
        
        try {
            this.state.loading = true;
            
            const hideLoading = showLoading(
                document.querySelector('[onclick="exportRecords()"]'),
                'جارِ التحديث...'
            );
            
            // محاكاة تحميل البيانات
            await delay(1000);
            
            // تحديث الإحصائيات
            const stats = getOrdersStats();
            this.updateStats(stats);
            
            // إعادة رسم الجدول
            if (typeof renderTable === 'function') {
                renderTable();
            }
            
            this.state.lastRefresh = new Date();
            
            hideLoading();
            showSuccessNotification('تم التحديث', 'تم تحديث البيانات بنجاح');
            
        } catch (error) {
            console.error('خطأ في التحديث:', error);
            showErrorNotification('خطأ في التحديث', 'فشل في تحديث البيانات');
        } finally {
            this.state.loading = false;
        }
    },

    /**
     * تحديث تلقائي
     */
    async autoRefresh() {
        // تحديث صامت دون إشعارات
        try {
            const stats = getOrdersStats();
            this.updateStats(stats);
            this.state.lastRefresh = new Date();
        } catch (error) {
            console.warn('فشل في التحديث التلقائي:', error);
        }
    },

    /**
     * تحديث الإحصائيات
     */
    updateStats(stats) {
        const elements = {
            totalOrders: document.getElementById('totalOrders'),
            pendingOrders: document.getElementById('pendingOrders'),
            completedOrders: document.getElementById('completedOrders'),
            rejectedOrders: document.getElementById('rejectedOrders')
        };

        if (elements.totalOrders) elements.totalOrders.textContent = stats.total;
        if (elements.pendingOrders) elements.pendingOrders.textContent = stats.pending;
        if (elements.completedOrders) elements.completedOrders.textContent = stats.completed;
        if (elements.rejectedOrders) elements.rejectedOrders.textContent = stats.rejected;
    },

    /**
     * حفظ الحالة الحالية
     */
    saveCurrentState() {
        try {
            const state = {
                recordsPerPage: recordsPerPage,
                currentPage: currentPage,
                lastView: this.state.currentView,
                timestamp: new Date().toISOString()
            };
            
            localStorage.setItem(
                CONFIG.STORAGE.PREFIX + CONFIG.STORAGE.SETTINGS_KEY,
                JSON.stringify(state)
            );
        } catch (error) {
            console.warn('فشل في حفظ الحالة:', error);
        }
    },

    /**
     * معالجة ظهور الصفحة
     */
    handlePageVisible() {
        // تحديث الوقت المنقضي
        if (this.state.lastRefresh) {
            const timeDiff = new Date() - this.state.lastRefresh;
            
            // تحديث تلقائي إذا مر أكثر من 10 دقائق
            if (timeDiff > 10 * 60 * 1000) {
                this.autoRefresh();
            }
        }
    },

    /**
     * تنظيف الموارد
     */
    cleanup() {
        // إلغاء الأحداث والفواصل الزمنية
        window.removeEventListener('resize', this.handleResize);
        window.removeEventListener('beforeunload', this.handleBeforeUnload);
        
        // حفظ الحالة النهائية
        this.saveCurrentState();
        
        console.log('🧹 تم تنظيف موارد التطبيق');
    }
};

/**
 * وظائف مساعدة للتطبيق الرئيسي
 */

/**
 * تشغيل التطبيق عند تحميل الصفحة
 */
document.addEventListener('DOMContentLoaded', async () => {
    try {
        await OrderManagementApp.init();
    } catch (error) {
        console.error('فشل في تشغيل التطبيق:', error);
    }
});

/**
 * تنظيف عند إغلاق الصفحة
 */
window.addEventListener('beforeunload', () => {
    OrderManagementApp.cleanup();
});

/**
 * وظائف عامة للتطبيق (للتوافق مع الكود الموجود)
 */

// وظيفة عرض نافذة طلب جديد
function showNewOrderModal() {
    OrderManagementApp.createNewOrder();
}

// وظيفة تصدير السجلات
function exportRecords() {
    OrderManagementApp.exportData();
}

// وظيفة تحديث الإحصائيات
function updateStats() {
    const stats = getOrdersStats();
    OrderManagementApp.updateStats(stats);
}

// تصدير كائن التطبيق للاستخدام العام
window.OrderManagementApp = OrderManagementApp;