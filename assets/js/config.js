/**
 * ==========================================================================
 * نظام إدارة الطلبات - ملف الإعدادات والثوابت
 * ==========================================================================
 */

// إعدادات النظام العامة
const CONFIG = {
    // إعدادات الجدول
    TABLE: {
        DEFAULT_RECORDS_PER_PAGE: 25,
        MAX_RECORDS_PER_PAGE: 100,
        MIN_RECORDS_PER_PAGE: 10
    },
    
    // إعدادات الترقيم
    PAGINATION: {
        VISIBLE_PAGES: 5,
        MOBILE_VISIBLE_PAGES: 3
    },
    
    // إعدادات البحث
    SEARCH: {
        MIN_SEARCH_LENGTH: 2,
        DEBOUNCE_DELAY: 300
    },
    
    // إعدادات الملفات
    FILES: {
        MAX_FILE_SIZE: 10 * 1024 * 1024, // 10 ميجابايت
        ALLOWED_EXTENSIONS: ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.txt'],
        MAX_FILES_COUNT: 5
    },
    
    // إعدادات الإشعارات
    NOTIFICATIONS: {
        DEFAULT_DURATION: 5000, // 5 ثوانِ
        SUCCESS_DURATION: 3000, // 3 ثوانِ
        ERROR_DURATION: 7000 // 7 ثوانِ
    },
    
    // إعدادات الرسوم المتحركة
    ANIMATIONS: {
        FADE_DURATION: 300,
        SLIDE_DURATION: 400,
        BOUNCE_DURATION: 500
    },
    
    // إعدادات API (للمستقبل)
    API: {
        BASE_URL: '/api/v1',
        TIMEOUT: 10000,
        RETRY_COUNT: 3
    },
    
    // إعدادات التخزين المحلي
    STORAGE: {
        PREFIX: 'order_management_',
        ORDERS_KEY: 'orders',
        SETTINGS_KEY: 'user_settings',
        FILTERS_KEY: 'saved_filters'
    }
};

// ثوابت حالات الطلبات
const ORDER_STATUS = {
    PENDING: 'pending',
    PROCESSING: 'processing',
    COMPLETED: 'completed',
    REJECTED: 'rejected',
    REVISION: 'revision'
};

// ثوابت أنواع الخدمات
const SERVICE_TYPES = {
    TRANSLATION: 'translation',
    EDITING: 'editing',
    DESIGN: 'design',
    WRITING: 'writing',
    RESEARCH: 'research'
};

// ثوابت أنواع الإشعارات
const NOTIFICATION_TYPES = {
    SUCCESS: 'success',
    ERROR: 'error',
    WARNING: 'warning',
    INFO: 'info'
};

// خريطة نصوص الحالات باللغة العربية
const STATUS_TEXT_MAP = {
    [ORDER_STATUS.PENDING]: 'قيد المراجعة',
    [ORDER_STATUS.PROCESSING]: 'قيد المعالجة',
    [ORDER_STATUS.COMPLETED]: 'مكتملة',
    [ORDER_STATUS.REJECTED]: 'مرفوضة',
    [ORDER_STATUS.REVISION]: 'تحتاج مراجعة'
};

// خريطة نصوص أنواع الخدمات باللغة العربية
const SERVICE_TEXT_MAP = {
    [SERVICE_TYPES.TRANSLATION]: 'ترجمة',
    [SERVICE_TYPES.EDITING]: 'تحرير وتدقيق',
    [SERVICE_TYPES.DESIGN]: 'تصميم',
    [SERVICE_TYPES.WRITING]: 'كتابة محتوى',
    [SERVICE_TYPES.RESEARCH]: 'بحث أكاديمي'
};

// خريطة ألوان الحالات
const STATUS_COLOR_MAP = {
    [ORDER_STATUS.PENDING]: 'yellow',
    [ORDER_STATUS.PROCESSING]: 'blue',
    [ORDER_STATUS.COMPLETED]: 'green',
    [ORDER_STATUS.REJECTED]: 'red',
    [ORDER_STATUS.REVISION]: 'orange'
};

// خريطة أيقونات الحالات
const STATUS_ICON_MAP = {
    [ORDER_STATUS.PENDING]: 'clock',
    [ORDER_STATUS.PROCESSING]: 'spinner',
    [ORDER_STATUS.COMPLETED]: 'check-circle',
    [ORDER_STATUS.REJECTED]: 'x-circle',
    [ORDER_STATUS.REVISION]: 'exclamation-triangle'
};

// أيقونات SVG للإشعارات
const NOTIFICATION_ICONS = {
    [NOTIFICATION_TYPES.SUCCESS]: '<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>',
    [NOTIFICATION_TYPES.ERROR]: '<path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>',
    [NOTIFICATION_TYPES.WARNING]: '<path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>',
    [NOTIFICATION_TYPES.INFO]: '<path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path>'
};

// تصديرات للاستخدام في ملفات أخرى
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        CONFIG,
        ORDER_STATUS,
        SERVICE_TYPES,
        NOTIFICATION_TYPES,
        STATUS_TEXT_MAP,
        SERVICE_TEXT_MAP,
        STATUS_COLOR_MAP,
        STATUS_ICON_MAP,
        NOTIFICATION_ICONS
    };
}