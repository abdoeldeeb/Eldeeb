/**
 * ==========================================================================
 * نظام إدارة الطلبات - ملف إدارة الإشعارات
 * ==========================================================================
 */

/**
 * عرض إشعار للمستخدم
 * @param {string} title - عنوان الإشعار
 * @param {string} message - نص الإشعار
 * @param {string} type - نوع الإشعار (success, error, warning, info)
 * @param {number} duration - مدة العرض بالمللي ثانية
 */
function showNotification(title, message, type = NOTIFICATION_TYPES.INFO, duration = null) {
    const notification = document.getElementById('notification');
    const icon = document.getElementById('notificationIcon');
    const titleEl = document.getElementById('notificationTitle');
    const messageEl = document.getElementById('notificationMessage');
    
    if (!notification || !icon || !titleEl || !messageEl) {
        console.warn('عناصر الإشعار غير موجودة');
        return;
    }
    
    // تعيين النصوص
    titleEl.textContent = title;
    messageEl.textContent = message;
    
    // تعيين الأيقونة حسب النوع
    icon.innerHTML = NOTIFICATION_ICONS[type] || NOTIFICATION_ICONS[NOTIFICATION_TYPES.INFO];
    
    // تعيين لون الأيقونة
    const colorClass = getNotificationColorClass(type);
    icon.className = `w-5 h-5 ${colorClass}`;
    
    // إظهار الإشعار
    notification.classList.add('show');
    
    // تحديد مدة العرض
    const displayDuration = duration || getNotificationDuration(type);
    
    // إخفاء الإشعار تلقائياً
    setTimeout(() => {
        hideNotification();
    }, displayDuration);
    
    // إضافة صوت التنبيه (اختياري)
    playNotificationSound(type);
}

/**
 * إخفاء الإشعار
 */
function hideNotification() {
    const notification = document.getElementById('notification');
    if (notification) {
        notification.classList.remove('show');
    }
}

/**
 * عرض إشعار نجاح
 * @param {string} title - عنوان الإشعار
 * @param {string} message - نص الإشعار
 */
function showSuccessNotification(title, message) {
    showNotification(title, message, NOTIFICATION_TYPES.SUCCESS);
}

/**
 * عرض إشعار خطأ
 * @param {string} title - عنوان الإشعار
 * @param {string} message - نص الإشعار
 */
function showErrorNotification(title, message) {
    showNotification(title, message, NOTIFICATION_TYPES.ERROR);
}

/**
 * عرض إشعار تحذير
 * @param {string} title - عنوان الإشعار
 * @param {string} message - نص الإشعار
 */
function showWarningNotification(title, message) {
    showNotification(title, message, NOTIFICATION_TYPES.WARNING);
}

/**
 * عرض إشعار معلومات
 * @param {string} title - عنوان الإشعار
 * @param {string} message - نص الإشعار
 */
function showInfoNotification(title, message) {
    showNotification(title, message, NOTIFICATION_TYPES.INFO);
}

/**
 * الحصول على فئة اللون للإشعار
 * @param {string} type - نوع الإشعار
 * @returns {string} فئة CSS للون
 */
function getNotificationColorClass(type) {
    const colorMap = {
        [NOTIFICATION_TYPES.SUCCESS]: 'text-green-600',
        [NOTIFICATION_TYPES.ERROR]: 'text-red-600',
        [NOTIFICATION_TYPES.WARNING]: 'text-yellow-600',
        [NOTIFICATION_TYPES.INFO]: 'text-blue-600'
    };
    
    return colorMap[type] || colorMap[NOTIFICATION_TYPES.INFO];
}

/**
 * الحصول على مدة عرض الإشعار حسب النوع
 * @param {string} type - نوع الإشعار
 * @returns {number} المدة بالمللي ثانية
 */
function getNotificationDuration(type) {
    switch (type) {
        case NOTIFICATION_TYPES.SUCCESS:
            return CONFIG.NOTIFICATIONS.SUCCESS_DURATION;
        case NOTIFICATION_TYPES.ERROR:
            return CONFIG.NOTIFICATIONS.ERROR_DURATION;
        case NOTIFICATION_TYPES.WARNING:
        case NOTIFICATION_TYPES.INFO:
        default:
            return CONFIG.NOTIFICATIONS.DEFAULT_DURATION;
    }
}

/**
 * تشغيل صوت التنبيه (اختياري)
 * @param {string} type - نوع الإشعار
 */
function playNotificationSound(type) {
    // يمكن إضافة أصوات مختلفة لكل نوع
    if (!supportsFeature('audio')) return;
    
    try {
        // إنشاء نغمة بسيطة باستخدام Web Audio API
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const oscillator = audioContext.createOscillator();
        const gainNode = audioContext.createGain();
        
        oscillator.connect(gainNode);
        gainNode.connect(audioContext.destination);
        
        // تحديد التردد حسب نوع الإشعار
        const frequencies = {
            [NOTIFICATION_TYPES.SUCCESS]: 800,
            [NOTIFICATION_TYPES.ERROR]: 400,
            [NOTIFICATION_TYPES.WARNING]: 600,
            [NOTIFICATION_TYPES.INFO]: 500
        };
        
        oscillator.frequency.setValueAtTime(frequencies[type] || 500, audioContext.currentTime);
        oscillator.type = 'sine';
        
        gainNode.gain.setValueAtTime(0.1, audioContext.currentTime);
        gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.1);
        
        oscillator.start(audioContext.currentTime);
        oscillator.stop(audioContext.currentTime + 0.1);
    } catch (error) {
        // تجاهل الأخطاء - الصوت اختياري
    }
}

/**
 * عرض رسالة تأكيد
 * @param {string} message - نص الرسالة
 * @param {Function} onConfirm - وظيفة التأكيد
 * @param {Function} onCancel - وظيفة الإلغاء
 */
function showConfirmDialog(message, onConfirm, onCancel = null) {
    const confirmed = confirm(message);
    
    if (confirmed && typeof onConfirm === 'function') {
        onConfirm();
    } else if (!confirmed && typeof onCancel === 'function') {
        onCancel();
    }
}

/**
 * عرض نافذة تأكيد مخصصة
 * @param {Object} options - خيارات النافذة
 */
function showCustomConfirmDialog(options) {
    const {
        title = 'تأكيد',
        message = 'هل أنت متأكد؟',
        confirmText = 'نعم',
        cancelText = 'إلغاء',
        onConfirm = null,
        onCancel = null,
        type = 'warning'
    } = options;
    
    // إنشاء نافذة تأكيد مخصصة
    const modal = document.createElement('div');
    modal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 z-50 flex items-center justify-center';
    modal.innerHTML = `
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
            <div class="p-6">
                <div class="flex items-center mb-4">
                    <div class="flex-shrink-0">
                        <svg class="w-6 h-6 ${getNotificationColorClass(type)}" fill="currentColor" viewBox="0 0 20 20">
                            ${NOTIFICATION_ICONS[type]}
                        </svg>
                    </div>
                    <div class="mr-3">
                        <h3 class="text-lg font-medium text-gray-900">${sanitizeText(title)}</h3>
                    </div>
                </div>
                <div class="mb-6">
                    <p class="text-sm text-gray-600">${sanitizeText(message)}</p>
                </div>
                <div class="flex justify-end space-x-3 space-x-reverse">
                    <button id="cancelBtn" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                        ${sanitizeText(cancelText)}
                    </button>
                    <button id="confirmBtn" class="px-4 py-2 bg-red-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-red-700">
                        ${sanitizeText(confirmText)}
                    </button>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // ربط الأحداث
    const confirmBtn = modal.querySelector('#confirmBtn');
    const cancelBtn = modal.querySelector('#cancelBtn');
    
    function closeModal() {
        document.body.removeChild(modal);
    }
    
    confirmBtn.addEventListener('click', () => {
        closeModal();
        if (typeof onConfirm === 'function') {
            onConfirm();
        }
    });
    
    cancelBtn.addEventListener('click', () => {
        closeModal();
        if (typeof onCancel === 'function') {
            onCancel();
        }
    });
    
    // إغلاق عند النقر خارج النافذة
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            closeModal();
            if (typeof onCancel === 'function') {
                onCancel();
            }
        }
    });
    
    // التركيز على زر الإلغاء
    cancelBtn.focus();
}

/**
 * عرض نافذة تحميل
 * @param {string} message - رسالة التحميل
 * @returns {Function} وظيفة إغلاق نافذة التحميل
 */
function showLoadingDialog(message = 'جارِ التحميل...') {
    const modal = document.createElement('div');
    modal.id = 'loadingModal';
    modal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 z-50 flex items-center justify-center';
    modal.innerHTML = `
        <div class="bg-white rounded-lg shadow-xl p-8 text-center">
            <div class="loading-spinner mb-4"></div>
            <p class="text-gray-600">${sanitizeText(message)}</p>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    return function hideLoadingDialog() {
        const loadingModal = document.getElementById('loadingModal');
        if (loadingModal) {
            document.body.removeChild(loadingModal);
        }
    };
}

/**
 * عرض شريط تقدم
 * @param {number} progress - نسبة التقدم (0-100)
 * @param {string} message - رسالة التقدم
 */
function showProgressBar(progress, message = '') {
    let progressModal = document.getElementById('progressModal');
    
    if (!progressModal) {
        progressModal = document.createElement('div');
        progressModal.id = 'progressModal';
        progressModal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 z-50 flex items-center justify-center';
        progressModal.innerHTML = `
            <div class="bg-white rounded-lg shadow-xl p-8 min-w-80">
                <div class="mb-4">
                    <div class="flex justify-between items-center mb-2">
                        <span class="text-sm font-medium text-gray-900" id="progressMessage">جارِ المعالجة...</span>
                        <span class="text-sm text-gray-500" id="progressPercent">0%</span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2">
                        <div id="progressBar" class="bg-blue-600 h-2 rounded-full transition-all duration-300" style="width: 0%"></div>
                    </div>
                </div>
            </div>
        `;
        document.body.appendChild(progressModal);
    }
    
    const progressBar = progressModal.querySelector('#progressBar');
    const progressPercent = progressModal.querySelector('#progressPercent');
    const progressMessage = progressModal.querySelector('#progressMessage');
    
    if (progressBar) {
        progressBar.style.width = `${Math.min(100, Math.max(0, progress))}%`;
    }
    
    if (progressPercent) {
        progressPercent.textContent = `${Math.round(progress)}%`;
    }
    
    if (progressMessage && message) {
        progressMessage.textContent = message;
    }
    
    // إغلاق تلقائي عند اكتمال التقدم
    if (progress >= 100) {
        setTimeout(() => {
            hideProgressBar();
        }, 1000);
    }
}

/**
 * إخفاء شريط التقدم
 */
function hideProgressBar() {
    const progressModal = document.getElementById('progressModal');
    if (progressModal) {
        document.body.removeChild(progressModal);
    }
}

/**
 * عرض نافذة إدخال نص
 * @param {Object} options - خيارات النافذة
 * @returns {Promise} وعد يحتوي على النص المدخل
 */
function showPromptDialog(options) {
    return new Promise((resolve, reject) => {
        const {
            title = 'إدخال نص',
            message = 'يرجى إدخال النص:',
            placeholder = '',
            defaultValue = '',
            confirmText = 'موافق',
            cancelText = 'إلغاء'
        } = options;
        
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 z-50 flex items-center justify-center';
        modal.innerHTML = `
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
                <div class="p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">${sanitizeText(title)}</h3>
                    <p class="text-sm text-gray-600 mb-4">${sanitizeText(message)}</p>
                    <input type="text" id="promptInput" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500 mb-4" 
                           placeholder="${sanitizeText(placeholder)}" value="${sanitizeText(defaultValue)}">
                    <div class="flex justify-end space-x-3 space-x-reverse">
                        <button id="promptCancel" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                            ${sanitizeText(cancelText)}
                        </button>
                        <button id="promptConfirm" class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                            ${sanitizeText(confirmText)}
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const input = modal.querySelector('#promptInput');
        const confirmBtn = modal.querySelector('#promptConfirm');
        const cancelBtn = modal.querySelector('#promptCancel');
        
        function closeModal() {
            document.body.removeChild(modal);
        }
        
        function confirmAction() {
            const value = input.value.trim();
            closeModal();
            resolve(value);
        }
        
        function cancelAction() {
            closeModal();
            reject(new Error('تم إلغاء الإدخال'));
        }
        
        confirmBtn.addEventListener('click', confirmAction);
        cancelBtn.addEventListener('click', cancelAction);
        
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                confirmAction();
            } else if (e.key === 'Escape') {
                cancelAction();
            }
        });
        
        // التركيز على حقل الإدخال
        input.focus();
        input.select();
    });
}

/**
 * عرض نافذة اختيار من قائمة
 * @param {Object} options - خيارات النافذة
 * @returns {Promise} وعد يحتوي على الخيار المختار
 */
function showSelectDialog(options) {
    return new Promise((resolve, reject) => {
        const {
            title = 'اختيار',
            message = 'يرجى الاختيار من القائمة:',
            choices = [],
            confirmText = 'موافق',
            cancelText = 'إلغاء'
        } = options;
        
        if (!Array.isArray(choices) || choices.length === 0) {
            reject(new Error('قائمة الخيارات فارغة'));
            return;
        }
        
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 z-50 flex items-center justify-center';
        
        const choicesHtml = choices.map((choice, index) => `
            <label class="flex items-center p-2 hover:bg-gray-50 rounded">
                <input type="radio" name="selectChoice" value="${index}" class="mr-3" ${index === 0 ? 'checked' : ''}>
                <span>${sanitizeText(choice.text || choice)}</span>
            </label>
        `).join('');
        
        modal.innerHTML = `
            <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4">
                <div class="p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">${sanitizeText(title)}</h3>
                    <p class="text-sm text-gray-600 mb-4">${sanitizeText(message)}</p>
                    <div class="space-y-2 mb-4 max-h-60 overflow-y-auto">
                        ${choicesHtml}
                    </div>
                    <div class="flex justify-end space-x-3 space-x-reverse">
                        <button id="selectCancel" class="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50">
                            ${sanitizeText(cancelText)}
                        </button>
                        <button id="selectConfirm" class="px-4 py-2 bg-blue-600 border border-transparent rounded-md text-sm font-medium text-white hover:bg-blue-700">
                            ${sanitizeText(confirmText)}
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        const confirmBtn = modal.querySelector('#selectConfirm');
        const cancelBtn = modal.querySelector('#selectCancel');
        
        function closeModal() {
            document.body.removeChild(modal);
        }
        
        function confirmAction() {
            const selected = modal.querySelector('input[name="selectChoice"]:checked');
            if (selected) {
                const index = parseInt(selected.value);
                const choice = choices[index];
                closeModal();
                resolve(choice.value !== undefined ? choice.value : choice);
            } else {
                closeModal();
                reject(new Error('لم يتم اختيار أي عنصر'));
            }
        }
        
        function cancelAction() {
            closeModal();
            reject(new Error('تم إلغاء الاختيار'));
        }
        
        confirmBtn.addEventListener('click', confirmAction);
        cancelBtn.addEventListener('click', cancelAction);
        
        // النقر المزدوج على الخيار للتأكيد
        modal.querySelectorAll('input[name="selectChoice"]').forEach(radio => {
            radio.addEventListener('dblclick', confirmAction);
        });
    });
}

/**
 * تهيئة نظام الإشعارات
 */
function initNotifications() {
    // التحقق من وجود عناصر الإشعار
    const notification = document.getElementById('notification');
    if (!notification) {
        console.warn('عنصر الإشعار غير موجود في الصفحة');
        return;
    }
    
    // ربط حدث إغلاق الإشعار
    const closeBtn = notification.querySelector('button[onclick="hideNotification()"]');
    if (closeBtn) {
        closeBtn.addEventListener('click', hideNotification);
    }
    
    // إغلاق الإشعار بالضغط على Escape
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            hideNotification();
        }
    });
    
    // طلب إذن للإشعارات المتصفح (اختياري)
    if (supportsFeature('notification')) {
        if (Notification.permission === 'default') {
            // يمكن طلب الإذن عند الحاجة
        }
    }
}