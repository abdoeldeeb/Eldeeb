/**
 * ==========================================================================
 * نظام إدارة الطلبات - ملف الوظائف المساعدة
 * ==========================================================================
 */

/**
 * تنسيق التاريخ للعرض باللغة العربية
 */
function formatDate(dateString) {
    if (!dateString) return '';
    
    try {
        const date = new Date(dateString);
        return date.toLocaleDateString('ar-SA', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit'
        });
    } catch (error) {
        console.warn('خطأ في تنسيق التاريخ:', error);
        return dateString;
    }
}

/**
 * تنسيق التاريخ والوقت
 */
function formatDateTime(dateString) {
    if (!dateString) return '';
    
    try {
        const date = new Date(dateString);
        return date.toLocaleString('ar-SA', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
    } catch (error) {
        console.warn('خطأ في تنسيق التاريخ والوقت:', error);
        return dateString;
    }
}

/**
 * الحصول على نص الحالة باللغة العربية
 */
function getStatusText(status) {
    return STATUS_TEXT_MAP[status] || status;
}

/**
 * الحصول على نص نوع الخدمة باللغة العربية
 */
function getServiceText(serviceType) {
    return SERVICE_TEXT_MAP[serviceType] || serviceType;
}

/**
 * تطهير النص من العلامات الخطرة
 */
function sanitizeText(text) {
    if (!text) return '';
    
    return text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

/**
 * تقصير النص مع إضافة نقاط
 */
function truncateText(text, maxLength = 50) {
    if (!text) return '';
    
    if (text.length <= maxLength) {
        return text;
    }
    
    return text.substring(0, maxLength) + '...';
}

/**
 * تبديل الحالة المنطقية لعنصر DOM
 */
function toggleClass(element, className) {
    if (!element) return;
    
    if (element.classList.contains(className)) {
        element.classList.remove(className);
        return false;
    } else {
        element.classList.add(className);
        return true;
    }
}

/**
 * إضافة مهلة زمنية للتنفيذ (debounce)
 */
function debounce(func, wait) {
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

/**
 * تأخير التنفيذ بالمللي ثانية
 */
function delay(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

/**
 * نسخ النص إلى الحافظة
 */
async function copyToClipboard(text) {
    try {
        if (navigator.clipboard && window.isSecureContext) {
            await navigator.clipboard.writeText(text);
            return true;
        } else {
            // للمتصفحات القديمة
            const textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            const success = document.execCommand('copy');
            document.body.removeChild(textArea);
            return success;
        }
    } catch (error) {
        console.error('فشل في نسخ النص:', error);
        return false;
    }
}

/**
 * تحويل الكائن إلى سلسلة استعلام URL
 */
function objectToQueryString(obj) {
    const params = new URLSearchParams();
    
    for (const [key, value] of Object.entries(obj)) {
        if (value !== null && value !== undefined && value !== '') {
            params.append(key, value);
        }
    }
    
    return params.toString();
}

/**
 * تحويل سلسلة استعلام URL إلى كائن
 */
function queryStringToObject(queryString) {
    const params = new URLSearchParams(queryString);
    const obj = {};
    
    for (const [key, value] of params.entries()) {
        obj[key] = value;
    }
    
    return obj;
}

/**
 * فحص صحة عنوان البريد الإلكتروني
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * فحص صحة رقم الهاتف السعودي
 */
function isValidSaudiPhone(phone) {
    const phoneRegex = /^(05|9665)[0-9]{8}$/;
    return phoneRegex.test(phone.replace(/\s+/g, ''));
}

/**
 * تنسيق رقم الهاتف
 */
function formatPhoneNumber(phone) {
    if (!phone) return '';
    
    // إزالة جميع المسافات والرموز
    const cleaned = phone.replace(/\D/g, '');
    
    // تنسيق الرقم السعودي
    if (cleaned.length === 10 && cleaned.startsWith('05')) {
        return cleaned.replace(/(\d{3})(\d{3})(\d{4})/, '$1 $2 $3');
    }
    
    return phone;
}

/**
 * فحص حجم الملف
 */
function isValidFileSize(file, maxSizeInMB = 10) {
    if (!file) return false;
    
    const maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return file.size <= maxSizeInBytes;
}

/**
 * فحص نوع الملف
 */
function isValidFileType(file, allowedExtensions) {
    if (!file || !allowedExtensions) return false;
    
    const fileName = file.name.toLowerCase();
    const fileExtension = '.' + fileName.split('.').pop();
    
    return allowedExtensions.includes(fileExtension);
}

/**
 * تحويل حجم الملف إلى نص قابل للقراءة
 */
function formatFileSize(bytes) {
    if (bytes === 0) return '0 بايت';
    
    const k = 1024;
    const sizes = ['بايت', 'كيلوبايت', 'ميجابايت', 'جيجابايت'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

/**
 * إنشاء معرف فريد
 */
function generateUniqueId() {
    return Date.now().toString(36) + Math.random().toString(36).substr(2);
}

/**
 * فحص ما إذا كان الجهاز محمولاً
 */
function isMobileDevice() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

/**
 * فحص ما إذا كان المتصفح يدعم ميزة معينة
 */
function supportsFeature(feature) {
    switch (feature) {
        case 'localStorage':
            try {
                const test = 'test';
                localStorage.setItem(test, test);
                localStorage.removeItem(test);
                return true;
            } catch (e) {
                return false;
            }
        case 'clipboard':
            return navigator.clipboard && window.isSecureContext;
        case 'notification':
            return 'Notification' in window;
        case 'serviceWorker':
            return 'serviceWorker' in navigator;
        default:
            return false;
    }
}

/**
 * تحديث URL دون إعادة تحميل الصفحة
 */
function updateURL(params) {
    if (!window.history || !window.history.pushState) return;
    
    const url = new URL(window.location);
    
    for (const [key, value] of Object.entries(params)) {
        if (value !== null && value !== undefined && value !== '') {
            url.searchParams.set(key, value);
        } else {
            url.searchParams.delete(key);
        }
    }
    
    window.history.pushState({}, '', url);
}

/**
 * تشفير بسيط للنصوص (Base64)
 */
function encodeText(text) {
    try {
        return btoa(encodeURIComponent(text));
    } catch (error) {
        console.error('خطأ في تشفير النص:', error);
        return text;
    }
}

/**
 * فك تشفير النصوص (Base64)
 */
function decodeText(encodedText) {
    try {
        return decodeURIComponent(atob(encodedText));
    } catch (error) {
        console.error('خطأ في فك تشفير النص:', error);
        return encodedText;
    }
}

/**
 * تحديد لون الخلفية بناءً على النص
 */
function generateColorFromText(text) {
    if (!text) return '#cccccc';
    
    let hash = 0;
    for (let i = 0; i < text.length; i++) {
        const char = text.charCodeAt(i);
        hash = ((hash << 5) - hash) + char;
        hash = hash & hash; // تحويل إلى 32 بت
    }
    
    const hue = Math.abs(hash % 360);
    return `hsl(${hue}, 70%, 85%)`;
}

/**
 * حساب الوقت المنقضي منذ تاريخ معين
 */
function timeAgo(dateString) {
    if (!dateString) return '';
    
    const now = new Date();
    const date = new Date(dateString);
    const diffInSeconds = Math.floor((now - date) / 1000);
    
    const intervals = [
        { label: 'سنة', seconds: 31536000 },
        { label: 'شهر', seconds: 2592000 },
        { label: 'أسبوع', seconds: 604800 },
        { label: 'يوم', seconds: 86400 },
        { label: 'ساعة', seconds: 3600 },
        { label: 'دقيقة', seconds: 60 }
    ];
    
    for (const interval of intervals) {
        const count = Math.floor(diffInSeconds / interval.seconds);
        if (count >= 1) {
            return `منذ ${count} ${interval.label}${count > 1 ? (interval.label === 'ساعة' ? 'ات' : interval.label === 'دقيقة' ? '' : '') : ''}`;
        }
    }
    
    return 'منذ لحظات';
}

/**
 * تحديد اتجاه النص (RTL/LTR)
 */
function getTextDirection(text) {
    if (!text) return 'ltr';
    
    const rtlChars = /[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F]/;
    return rtlChars.test(text) ? 'rtl' : 'ltr';
}

/**
 * تطبيق تأثير التحميل على عنصر
 */
function showLoading(element, text = 'جارِ التحميل...') {
    if (!element) return;
    
    element.disabled = true;
    element.classList.add('loading');
    
    const originalText = element.textContent;
    element.textContent = text;
    
    return function hideLoading() {
        element.disabled = false;
        element.classList.remove('loading');
        element.textContent = originalText;
    };
}

/**
 * تحديد ما إذا كان العنصر مرئياً في منطقة العرض
 */
function isElementInViewport(element) {
    if (!element) return false;
    
    const rect = element.getBoundingClientRect();
    return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
    );
}

/**
 * التمرير السلس إلى عنصر
 */
function scrollToElement(element, offset = 0) {
    if (!element) return;
    
    const elementPosition = element.getBoundingClientRect().top + window.pageYOffset;
    const offsetPosition = elementPosition + offset;
    
    window.scrollTo({
        top: offsetPosition,
        behavior: 'smooth'
    });
}

/**
 * تبديل وضع ملء الشاشة
 */
function toggleFullscreen() {
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen().catch(err => {
            console.warn('خطأ في تفعيل وضع ملء الشاشة:', err);
        });
    } else {
        document.exitFullscreen().catch(err => {
            console.warn('خطأ في إلغاء وضع ملء الشاشة:', err);
        });
    }
}

/**
 * طباعة عنصر محدد
 */
function printElement(element) {
    if (!element) return;
    
    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
        <html>
            <head>
                <title>طباعة</title>
                <style>
                    body { font-family: 'Tajawal', Arial, sans-serif; direction: rtl; }
                    @media print { body { margin: 0; } }
                </style>
            </head>
            <body>
                ${element.innerHTML}
            </body>
        </html>
    `);
    
    printWindow.document.close();
    printWindow.focus();
    
    setTimeout(() => {
        printWindow.print();
        printWindow.close();
    }, 250);
}

/**
 * تحميل ملف
 */
function downloadFile(content, filename, contentType = 'text/plain') {
    const blob = new Blob([content], { type: contentType });
    const url = window.URL.createObjectURL(blob);
    
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    link.style.display = 'none';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // تنظيف الذاكرة
    setTimeout(() => window.URL.revokeObjectURL(url), 100);
}