/**
 * ==========================================================================
 * نظام إدارة الطلبات - ملف إدارة البيانات
 * ==========================================================================
 */

// بيانات الطلبات الأساسية
let orders = [
    {
        id: 'ORD-001',
        clientName: 'أحمد محمد',
        phone: '0501234567',
        serviceType: SERVICE_TYPES.TRANSLATION,
        description: 'ترجمة وثائق قانونية من الإنجليزية إلى العربية',
        status: ORDER_STATUS.COMPLETED,
        createdDate: '2024-01-15',
        lastUpdate: '2024-01-20',
        files: ['contract.pdf', 'legal_docs.docx'],
        priority: 'high',
        estimatedDelivery: '2024-01-25',
        notes: 'عميل مهم - إنجاز سريع'
    },
    {
        id: 'ORD-002',
        clientName: 'فاطمة أحمد',
        phone: '0507654321',
        serviceType: SERVICE_TYPES.EDITING,
        description: 'تدقيق لغوي لرسالة ماجستير في الأدب العربي',
        status: ORDER_STATUS.PROCESSING,
        createdDate: '2024-01-18',
        lastUpdate: '2024-01-19',
        files: ['thesis.docx'],
        priority: 'medium',
        estimatedDelivery: '2024-01-30',
        notes: 'رسالة ماجستير - دقة عالية مطلوبة'
    },
    {
        id: 'ORD-003',
        clientName: 'خالد عبدالله',
        phone: '0551239876',
        serviceType: SERVICE_TYPES.DESIGN,
        description: 'تصميم هوية بصرية لشركة ناشئة',
        status: ORDER_STATUS.PENDING,
        createdDate: '2024-01-20',
        lastUpdate: '2024-01-20',
        files: ['brief.pdf', 'references.zip'],
        priority: 'high',
        estimatedDelivery: '2024-02-05',
        notes: 'مشروع كبير - عدة مراحل'
    },
    {
        id: 'ORD-004',
        clientName: 'سارة الزهراني',
        phone: '0598765432',
        serviceType: SERVICE_TYPES.WRITING,
        description: 'كتابة محتوى تسويقي لموقع إلكتروني',
        status: ORDER_STATUS.REVISION,
        createdDate: '2024-01-16',
        lastUpdate: '2024-01-21',
        files: ['guidelines.docx'],
        priority: 'medium',
        estimatedDelivery: '2024-01-28',
        notes: 'طلب تعديلات من العميل'
    },
    {
        id: 'ORD-005',
        clientName: 'محمد العتيبي',
        phone: '0543217890',
        serviceType: SERVICE_TYPES.RESEARCH,
        description: 'إعداد بحث في مجال تكنولوجيا المعلومات',
        status: ORDER_STATUS.REJECTED,
        createdDate: '2024-01-12',
        lastUpdate: '2024-01-14',
        files: ['requirements.pdf'],
        priority: 'low',
        estimatedDelivery: '2024-02-01',
        notes: 'متطلبات غير واضحة - رفض مؤقت'
    }
];

// متغيرات الحالة العامة
let currentPage = 1;
let recordsPerPage = CONFIG.TABLE.DEFAULT_RECORDS_PER_PAGE;
let filteredOrders = [...orders];
let currentSort = {
    field: 'createdDate',
    direction: 'desc'
};

/**
 * إنشاء بيانات تجريبية إضافية
 */
function generateSampleData() {
    const statuses = Object.values(ORDER_STATUS);
    const services = Object.values(SERVICE_TYPES);
    const priorities = ['low', 'medium', 'high'];
    const names = [
        'علي أحمد', 'نورا محمد', 'عبدالله خالد', 'هند عبدالعزيز', 'عمر السعيد',
        'ريم الحربي', 'سعد القحطاني', 'لطيفة المطيري', 'طارق الشمري', 'مريم البلوي',
        'يوسف الغامدي', 'زينب العجمي', 'فهد الدوسري', 'آمال الرشيد', 'حسام الزهراني'
    ];
    
    for (let i = 6; i <= 50; i++) {
        const randomDate = new Date(2024, 0, Math.floor(Math.random() * 21) + 1);
        const updateDate = new Date(randomDate.getTime() + Math.random() * 10 * 24 * 60 * 60 * 1000);
        const deliveryDate = new Date(updateDate.getTime() + Math.random() * 14 * 24 * 60 * 60 * 1000);
        
        orders.push({
            id: `ORD-${String(i).padStart(3, '0')}`,
            clientName: names[Math.floor(Math.random() * names.length)],
            phone: '050' + Math.floor(Math.random() * 9000000 + 1000000),
            serviceType: services[Math.floor(Math.random() * services.length)],
            description: `وصف الطلب رقم ${i} - ${generateRandomDescription()}`,
            status: statuses[Math.floor(Math.random() * statuses.length)],
            createdDate: randomDate.toISOString().split('T')[0],
            lastUpdate: updateDate.toISOString().split('T')[0],
            files: generateRandomFiles(),
            priority: priorities[Math.floor(Math.random() * priorities.length)],
            estimatedDelivery: deliveryDate.toISOString().split('T')[0],
            notes: generateRandomNotes()
        });
    }
    
    filteredOrders = [...orders];
}

/**
 * توليد وصف عشوائي للطلب
 */
function generateRandomDescription() {
    const descriptions = [
        'مشروع متوسط الحجم',
        'عمل عاجل ومطلوب بسرعة',
        'مشروع طويل المدى',
        'عمل تجاري مهم',
        'مشروع أكاديمي متخصص',
        'عمل إبداعي متميز',
        'مشروع تقني معقد',
        'عمل تسويقي شامل'
    ];
    return descriptions[Math.floor(Math.random() * descriptions.length)];
}

/**
 * توليد ملفات عشوائية
 */
function generateRandomFiles() {
    const fileTypes = ['pdf', 'docx', 'jpg', 'png', 'txt'];
    const fileCount = Math.floor(Math.random() * 3) + 1;
    const files = [];
    
    for (let i = 0; i < fileCount; i++) {
        const type = fileTypes[Math.floor(Math.random() * fileTypes.length)];
        files.push(`file${i + 1}.${type}`);
    }
    
    return files;
}

/**
 * توليد ملاحظات عشوائية
 */
function generateRandomNotes() {
    const notes = [
        'عميل جديد',
        'طلب متكرر',
        'عميل مميز',
        'يحتاج متابعة',
        'عمل معقد',
        'عميل مهم',
        'طلب عاجل',
        'مشروع كبير'
    ];
    return Math.random() > 0.3 ? notes[Math.floor(Math.random() * notes.length)] : '';
}

/**
 * الحصول على جميع الطلبات
 */
function getAllOrders() {
    return [...orders];
}

/**
 * الحصول على الطلبات المفلترة
 */
function getFilteredOrders() {
    return [...filteredOrders];
}

/**
 * البحث عن طلب بواسطة المعرف
 */
function findOrderById(orderId) {
    return orders.find(order => order.id === orderId);
}

/**
 * إضافة طلب جديد
 */
function addOrder(orderData) {
    const newOrder = {
        id: generateOrderId(),
        createdDate: new Date().toISOString().split('T')[0],
        lastUpdate: new Date().toISOString().split('T')[0],
        status: ORDER_STATUS.PENDING,
        priority: 'medium',
        files: [],
        notes: '',
        ...orderData
    };
    
    orders.unshift(newOrder);
    applyCurrentFilters();
    saveToLocalStorage();
    
    return newOrder;
}

/**
 * تحديث طلب موجود
 */
function updateOrder(orderId, updateData) {
    const orderIndex = orders.findIndex(order => order.id === orderId);
    
    if (orderIndex !== -1) {
        orders[orderIndex] = {
            ...orders[orderIndex],
            ...updateData,
            lastUpdate: new Date().toISOString().split('T')[0]
        };
        
        applyCurrentFilters();
        saveToLocalStorage();
        
        return orders[orderIndex];
    }
    
    return null;
}

/**
 * حذف طلب
 */
function deleteOrder(orderId) {
    const orderIndex = orders.findIndex(order => order.id === orderId);
    
    if (orderIndex !== -1) {
        orders.splice(orderIndex, 1);
        applyCurrentFilters();
        saveToLocalStorage();
        return true;
    }
    
    return false;
}

/**
 * توليد معرف طلب جديد
 */
function generateOrderId() {
    const maxId = orders.reduce((max, order) => {
        const num = parseInt(order.id.split('-')[1]);
        return num > max ? num : max;
    }, 0);
    
    return `ORD-${String(maxId + 1).padStart(3, '0')}`;
}

/**
 * تطبيق الفلاتر الحالية
 */
function applyCurrentFilters() {
    // سيتم تنفيذها في ملف filters.js
    if (typeof applyFilters === 'function') {
        applyFilters();
    } else {
        filteredOrders = [...orders];
    }
}

/**
 * الحصول على إحصائيات الطلبات
 */
function getOrdersStats() {
    const total = orders.length;
    const pending = orders.filter(order => order.status === ORDER_STATUS.PENDING).length;
    const processing = orders.filter(order => order.status === ORDER_STATUS.PROCESSING).length;
    const completed = orders.filter(order => order.status === ORDER_STATUS.COMPLETED).length;
    const rejected = orders.filter(order => order.status === ORDER_STATUS.REJECTED).length;
    const revision = orders.filter(order => order.status === ORDER_STATUS.REVISION).length;
    
    return {
        total,
        pending,
        processing,
        completed,
        rejected,
        revision,
        completionRate: total > 0 ? Math.round((completed / total) * 100) : 0
    };
}

/**
 * فلترة الطلبات حسب معايير متعددة
 */
function filterOrders(filters) {
    let result = [...orders];
    
    // فلترة حسب النص
    if (filters.search && filters.search.length >= CONFIG.SEARCH.MIN_SEARCH_LENGTH) {
        const searchTerm = filters.search.toLowerCase();
        result = result.filter(order => 
            order.clientName.toLowerCase().includes(searchTerm) ||
            order.id.toLowerCase().includes(searchTerm) ||
            SERVICE_TEXT_MAP[order.serviceType].toLowerCase().includes(searchTerm) ||
            order.description.toLowerCase().includes(searchTerm) ||
            order.phone.includes(searchTerm)
        );
    }
    
    // فلترة حسب الحالة
    if (filters.status) {
        result = result.filter(order => order.status === filters.status);
    }
    
    // فلترة حسب التاريخ
    if (filters.date) {
        result = result.filter(order => order.createdDate === filters.date);
    }
    
    // فلترة حسب نوع الخدمة
    if (filters.serviceType) {
        result = result.filter(order => order.serviceType === filters.serviceType);
    }
    
    // فلترة حسب الأولوية
    if (filters.priority) {
        result = result.filter(order => order.priority === filters.priority);
    }
    
    return result;
}

/**
 * ترتيب الطلبات
 */
function sortOrders(field, direction = 'asc') {
    const sorted = [...filteredOrders].sort((a, b) => {
        let valueA = a[field];
        let valueB = b[field];
        
        // معالجة التواريخ
        if (field.includes('Date')) {
            valueA = new Date(valueA);
            valueB = new Date(valueB);
        }
        
        // معالجة النصوص
        if (typeof valueA === 'string') {
            valueA = valueA.toLowerCase();
            valueB = valueB.toLowerCase();
        }
        
        if (direction === 'asc') {
            return valueA > valueB ? 1 : valueA < valueB ? -1 : 0;
        } else {
            return valueA < valueB ? 1 : valueA > valueB ? -1 : 0;
        }
    });
    
    filteredOrders = sorted;
    currentSort = { field, direction };
    
    return sorted;
}

/**
 * حفظ البيانات في التخزين المحلي
 */
function saveToLocalStorage() {
    try {
        localStorage.setItem(
            CONFIG.STORAGE.PREFIX + CONFIG.STORAGE.ORDERS_KEY,
            JSON.stringify(orders)
        );
    } catch (error) {
        console.warn('فشل في حفظ البيانات في التخزين المحلي:', error);
    }
}

/**
 * تحميل البيانات من التخزين المحلي
 */
function loadFromLocalStorage() {
    try {
        const saved = localStorage.getItem(
            CONFIG.STORAGE.PREFIX + CONFIG.STORAGE.ORDERS_KEY
        );
        
        if (saved) {
            const parsedOrders = JSON.parse(saved);
            if (Array.isArray(parsedOrders) && parsedOrders.length > 0) {
                orders = parsedOrders;
                filteredOrders = [...orders];
                return true;
            }
        }
    } catch (error) {
        console.warn('فشل في تحميل البيانات من التخزين المحلي:', error);
    }
    
    return false;
}

/**
 * تصدير البيانات إلى CSV
 */
function exportToCSV(data = filteredOrders) {
    const headers = [
        'رقم الطلب',
        'اسم العميل',
        'رقم الهاتف',
        'نوع الخدمة',
        'الحالة',
        'الأولوية',
        'تاريخ الإنشاء',
        'آخر تحديث',
        'التسليم المتوقع',
        'الوصف',
        'الملاحظات'
    ];
    
    const csvContent = [
        headers.join(','),
        ...data.map(order => [
            order.id,
            order.clientName,
            order.phone,
            SERVICE_TEXT_MAP[order.serviceType],
            STATUS_TEXT_MAP[order.status],
            order.priority,
            order.createdDate,
            order.lastUpdate,
            order.estimatedDelivery || '',
            `"${order.description.replace(/"/g, '""')}"`,
            `"${(order.notes || '').replace(/"/g, '""')}"`
        ].join(','))
    ].join('\n');
    
    return csvContent;
}

/**
 * استيراد البيانات من CSV
 */
function importFromCSV(csvContent) {
    try {
        const lines = csvContent.split('\n');
        const headers = lines[0].split(',');
        const importedOrders = [];
        
        for (let i = 1; i < lines.length; i++) {
            if (lines[i].trim()) {
                const values = lines[i].split(',');
                // منطق تحويل CSV إلى كائن طلب
                // يمكن تطوير هذا حسب الحاجة
            }
        }
        
        return importedOrders;
    } catch (error) {
        console.error('خطأ في استيراد البيانات:', error);
        return [];
    }
}

/**
 * تهيئة البيانات عند تحميل الصفحة
 */
function initializeData() {
    // محاولة تحميل البيانات من التخزين المحلي
    const loaded = loadFromLocalStorage();
    
    // إذا لم تكن هناك بيانات محفوظة، استخدم البيانات التجريبية
    if (!loaded) {
        generateSampleData();
        saveToLocalStorage();
    }
    
    return getOrdersStats();
}