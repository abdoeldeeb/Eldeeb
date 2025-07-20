-- ==========================================================================
-- نظام إدارة الطلبات - استعلامات مفيدة وتقارير جاهزة
-- ==========================================================================

-- ==========================================================================
-- 📊 التقارير الإحصائية
-- ==========================================================================

-- 1. إحصائيات شاملة للنظام
SELECT 
    'إجمالي العملاء' as البيان,
    COUNT(*) as القيمة
FROM clients
UNION ALL
SELECT 
    'إجمالي الطلبات',
    COUNT(*)
FROM orders
UNION ALL
SELECT 
    'الطلبات المكتملة',
    COUNT(*)
FROM orders o
JOIN order_statuses s ON o.status_id = s.id
WHERE s.status_key = 'completed'
UNION ALL
SELECT 
    'إجمالي الإيرادات',
    COALESCE(SUM(final_price), 0)
FROM orders 
WHERE payment_status = 'paid';

-- 2. توزيع الطلبات حسب الحالة
SELECT 
    s.status_name_ar as الحالة,
    COUNT(o.id) as عدد_الطلبات,
    ROUND(COUNT(o.id) * 100.0 / (SELECT COUNT(*) FROM orders), 2) as النسبة_المئوية
FROM order_statuses s
LEFT JOIN orders o ON s.id = o.status_id AND o.deleted_at IS NULL
GROUP BY s.id, s.status_name_ar, s.sort_order
ORDER BY s.sort_order;

-- 3. توزيع الطلبات حسب نوع الخدمة
SELECT 
    st.type_name_ar as نوع_الخدمة,
    COUNT(o.id) as عدد_الطلبات,
    COALESCE(SUM(o.final_price), 0) as إجمالي_الإيرادات,
    COALESCE(AVG(o.final_price), 0) as متوسط_قيمة_الطلب
FROM service_types st
LEFT JOIN orders o ON st.id = o.service_type_id AND o.deleted_at IS NULL
GROUP BY st.id, st.type_name_ar
ORDER BY عدد_الطلبات DESC;

-- 4. أفضل العملاء (حسب عدد الطلبات)
SELECT 
    c.full_name as اسم_العميل,
    c.client_type as نوع_العميل,
    COUNT(o.id) as عدد_الطلبات,
    COALESCE(SUM(CASE WHEN o.payment_status = 'paid' THEN o.final_price ELSE 0 END), 0) as إجمالي_المدفوعات,
    c.phone as رقم_الهاتف
FROM clients c
LEFT JOIN orders o ON c.id = o.client_id AND o.deleted_at IS NULL
GROUP BY c.id, c.full_name, c.client_type, c.phone
HAVING COUNT(o.id) > 0
ORDER BY عدد_الطلبات DESC, إجمالي_المدفوعات DESC
LIMIT 10;

-- ==========================================================================
-- 📈 التقارير المالية
-- ==========================================================================

-- 5. الإيرادات الشهرية
SELECT 
    YEAR(created_at) as السنة,
    MONTH(created_at) as الشهر,
    COUNT(*) as عدد_الطلبات,
    SUM(CASE WHEN payment_status = 'paid' THEN final_price ELSE 0 END) as الإيرادات_المحققة,
    SUM(CASE WHEN payment_status = 'partial' THEN final_price ELSE 0 END) as الإيرادات_الجزئية,
    SUM(CASE WHEN payment_status = 'pending' THEN final_price ELSE 0 END) as الإيرادات_المنتظرة
FROM orders 
WHERE deleted_at IS NULL
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY السنة DESC, الشهر DESC;

-- 6. تحليل المدفوعات
SELECT 
    p.payment_method as طريقة_الدفع,
    COUNT(*) as عدد_المدفوعات,
    SUM(p.amount) as إجمالي_المبلغ,
    AVG(p.amount) as متوسط_المدفوعة
FROM payments p
WHERE p.payment_status = 'completed'
GROUP BY p.payment_method
ORDER BY إجمالي_المبلغ DESC;

-- 7. الطلبات المتأخرة عن موعد التسليم
SELECT 
    o.order_number as رقم_الطلب,
    o.title as عنوان_الطلب,
    c.full_name as اسم_العميل,
    c.phone as رقم_الهاتف,
    o.estimated_delivery_date as موعد_التسليم_المتوقع,
    DATEDIFF(CURRENT_DATE, o.estimated_delivery_date) as عدد_أيام_التأخير,
    s.status_name_ar as الحالة_الحالية
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN order_statuses s ON o.status_id = s.id
WHERE o.estimated_delivery_date < CURRENT_DATE
  AND s.status_key NOT IN ('completed', 'delivered', 'rejected', 'cancelled')
  AND o.deleted_at IS NULL
ORDER BY عدد_أيام_التأخير DESC;

-- ==========================================================================
-- 🔍 تقارير التشغيل
-- ==========================================================================

-- 8. الطلبات النشطة (قيد العمل)
SELECT 
    o.order_number as رقم_الطلب,
    o.title as عنوان_الطلب,
    c.full_name as اسم_العميل,
    st.type_name_ar as نوع_الخدمة,
    s.status_name_ar as الحالة,
    o.priority as الأولوية,
    o.estimated_delivery_date as موعد_التسليم_المتوقع,
    DATEDIFF(o.estimated_delivery_date, CURRENT_DATE) as أيام_متبقية
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN service_types st ON o.service_type_id = st.id
JOIN order_statuses s ON o.status_id = s.id
WHERE s.status_key IN ('pending', 'processing', 'revision')
  AND o.deleted_at IS NULL
ORDER BY 
    CASE o.priority 
        WHEN 'urgent' THEN 1 
        WHEN 'high' THEN 2 
        WHEN 'medium' THEN 3 
        WHEN 'low' THEN 4 
    END,
    o.estimated_delivery_date;

-- 9. تقرير الملفات حسب نوعها
SELECT 
    f.file_category as فئة_الملف,
    COUNT(*) as عدد_الملفات,
    SUM(f.file_size) as إجمالي_الحجم_بايت,
    ROUND(SUM(f.file_size) / 1024 / 1024, 2) as إجمالي_الحجم_ميجا,
    AVG(f.file_size) as متوسط_حجم_الملف
FROM order_files f
GROUP BY f.file_category
ORDER BY عدد_الملفات DESC;

-- 10. أكثر أنواع الملفات استخداماً
SELECT 
    f.file_type as نوع_الملف,
    COUNT(*) as عدد_الملفات,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM order_files), 2) as النسبة_المئوية
FROM order_files f
WHERE f.file_type IS NOT NULL
GROUP BY f.file_type
ORDER BY عدد_الملفات DESC
LIMIT 10;

-- ==========================================================================
-- 📊 تقارير الجودة والأداء
-- ==========================================================================

-- 11. متوسط تقييم الخدمات
SELECT 
    st.type_name_ar as نوع_الخدمة,
    COUNT(o.rating) as عدد_التقييمات,
    ROUND(AVG(o.rating), 2) as متوسط_التقييم,
    COUNT(CASE WHEN o.rating >= 4 THEN 1 END) as تقييمات_ممتازة,
    ROUND(COUNT(CASE WHEN o.rating >= 4 THEN 1 END) * 100.0 / COUNT(o.rating), 2) as نسبة_الرضا
FROM orders o
JOIN service_types st ON o.service_type_id = st.id
WHERE o.rating IS NOT NULL AND o.deleted_at IS NULL
GROUP BY st.id, st.type_name_ar
ORDER BY متوسط_التقييم DESC;

-- 12. الوقت المتوسط لإكمال الطلبات
SELECT 
    st.type_name_ar as نوع_الخدمة,
    COUNT(*) as عدد_الطلبات_المكتملة,
    ROUND(AVG(DATEDIFF(o.actual_delivery_date, o.created_at)), 1) as متوسط_أيام_الإنجاز,
    MIN(DATEDIFF(o.actual_delivery_date, o.created_at)) as أقل_مدة_إنجاز,
    MAX(DATEDIFF(o.actual_delivery_date, o.created_at)) as أطول_مدة_إنجاز
FROM orders o
JOIN service_types st ON o.service_type_id = st.id
JOIN order_statuses s ON o.status_id = s.id
WHERE s.status_key IN ('completed', 'delivered')
  AND o.actual_delivery_date IS NOT NULL
  AND o.deleted_at IS NULL
GROUP BY st.id, st.type_name_ar
ORDER BY متوسط_أيام_الإنجاز;

-- ==========================================================================
-- 🕐 تقارير زمنية متقدمة
-- ==========================================================================

-- 13. نشاط النظام خلال أيام الأسبوع
SELECT 
    CASE DAYOFWEEK(created_at)
        WHEN 1 THEN 'الأحد'
        WHEN 2 THEN 'الاثنين'
        WHEN 3 THEN 'الثلاثاء'
        WHEN 4 THEN 'الأربعاء'
        WHEN 5 THEN 'الخميس'
        WHEN 6 THEN 'الجمعة'
        WHEN 7 THEN 'السبت'
    END as يوم_الأسبوع,
    COUNT(*) as عدد_الطلبات,
    ROUND(AVG(final_price), 2) as متوسط_قيمة_الطلب
FROM orders 
WHERE deleted_at IS NULL
GROUP BY DAYOFWEEK(created_at)
ORDER BY DAYOFWEEK(created_at);

-- 14. أداء النظام في الـ 30 يوماً الماضية
SELECT 
    DATE(created_at) as التاريخ,
    COUNT(*) as طلبات_جديدة,
    SUM(CASE WHEN payment_status = 'paid' THEN final_price ELSE 0 END) as الإيرادات_اليومية,
    COUNT(CASE WHEN DATE(created_at) = DATE(updated_at) THEN NULL ELSE id END) as طلبات_محدثة
FROM orders 
WHERE created_at >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY)
  AND deleted_at IS NULL
GROUP BY DATE(created_at)
ORDER BY التاريخ DESC;

-- ==========================================================================
-- 🔍 استعلامات البحث المتقدم
-- ==========================================================================

-- 15. البحث في جميع النصوص
-- استبدل 'النص_المطلوب' بالنص الذي تريد البحث عنه
SELECT 
    'طلب' as نوع_النتيجة,
    o.order_number as المعرف,
    o.title as العنوان,
    c.full_name as العميل,
    'في عنوان الطلب' as موقع_النص
FROM orders o
JOIN clients c ON o.client_id = c.id
WHERE o.title LIKE '%النص_المطلوب%' AND o.deleted_at IS NULL

UNION ALL

SELECT 
    'طلب',
    o.order_number,
    o.title,
    c.full_name,
    'في وصف الطلب'
FROM orders o
JOIN clients c ON o.client_id = c.id
WHERE o.description LIKE '%النص_المطلوب%' AND o.deleted_at IS NULL

UNION ALL

SELECT 
    'عميل',
    c.id,
    c.full_name,
    c.email,
    'في اسم العميل'
FROM clients c
WHERE c.full_name LIKE '%النص_المطلوب%'

UNION ALL

SELECT 
    'تعليق',
    oc.order_id,
    oc.content,
    (SELECT o.order_number FROM orders o WHERE o.id = oc.order_id),
    'في التعليقات'
FROM order_comments oc
WHERE oc.content LIKE '%النص_المطلوب%';

-- ==========================================================================
-- 📋 تقارير إدارية
-- ==========================================================================

-- 16. ملخص يومي للمديرين
SELECT 
    'طلبات جديدة اليوم' as البيان,
    COUNT(*) as القيمة
FROM orders 
WHERE DATE(created_at) = CURRENT_DATE

UNION ALL

SELECT 
    'طلبات مكتملة اليوم',
    COUNT(*)
FROM orders o
JOIN order_statuses s ON o.status_id = s.id
WHERE DATE(o.updated_at) = CURRENT_DATE 
  AND s.status_key = 'completed'

UNION ALL

SELECT 
    'مدفوعات اليوم',
    COUNT(*)
FROM payments 
WHERE DATE(payment_date) = CURRENT_DATE 
  AND payment_status = 'completed'

UNION ALL

SELECT 
    'إيرادات اليوم',
    COALESCE(SUM(amount), 0)
FROM payments 
WHERE DATE(payment_date) = CURRENT_DATE 
  AND payment_status = 'completed';

-- 17. الطلبات التي تحتاج متابعة عاجلة
SELECT 
    o.order_number as رقم_الطلب,
    o.title as عنوان_الطلب,
    c.full_name as اسم_العميل,
    c.phone as رقم_الهاتف,
    s.status_name_ar as الحالة,
    o.priority as الأولوية,
    o.estimated_delivery_date as موعد_التسليم,
    CASE 
        WHEN o.estimated_delivery_date < CURRENT_DATE THEN 'متأخر'
        WHEN o.estimated_delivery_date = CURRENT_DATE THEN 'موعد التسليم اليوم'
        WHEN DATEDIFF(o.estimated_delivery_date, CURRENT_DATE) <= 3 THEN 'يحتاج متابعة قريبة'
        ELSE 'عادي'
    END as حالة_العجلة
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN order_statuses s ON o.status_id = s.id
WHERE s.status_key IN ('pending', 'processing', 'revision')
  AND o.deleted_at IS NULL
  AND (
    o.estimated_delivery_date <= DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY)
    OR o.priority IN ('high', 'urgent')
  )
ORDER BY 
    CASE 
        WHEN o.estimated_delivery_date < CURRENT_DATE THEN 1
        WHEN o.estimated_delivery_date = CURRENT_DATE THEN 2
        WHEN o.priority = 'urgent' THEN 3
        WHEN o.priority = 'high' THEN 4
        ELSE 5
    END,
    o.estimated_delivery_date;

-- ==========================================================================
-- 📊 تقارير للتصدير
-- ==========================================================================

-- 18. تقرير شامل للطلبات (للتصدير)
SELECT 
    o.order_number as 'رقم الطلب',
    c.full_name as 'اسم العميل',
    c.phone as 'رقم الهاتف',
    c.email as 'البريد الإلكتروني',
    st.type_name_ar as 'نوع الخدمة',
    o.title as 'عنوان الطلب',
    o.description as 'وصف الطلب',
    s.status_name_ar as 'الحالة',
    o.priority as 'الأولوية',
    o.estimated_price as 'السعر المتوقع',
    o.final_price as 'السعر النهائي',
    o.payment_status as 'حالة الدفع',
    o.created_at as 'تاريخ الإنشاء',
    o.estimated_delivery_date as 'موعد التسليم المتوقع',
    o.actual_delivery_date as 'تاريخ التسليم الفعلي',
    o.rating as 'التقييم',
    o.notes as 'ملاحظات'
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN service_types st ON o.service_type_id = st.id
JOIN order_statuses s ON o.status_id = s.id
WHERE o.deleted_at IS NULL
ORDER BY o.created_at DESC;

-- ==========================================================================
-- 🔧 استعلامات الصيانة
-- ==========================================================================

-- 19. فحص سلامة البيانات
SELECT 
    'طلبات بدون عملاء' as المشكلة,
    COUNT(*) as العدد
FROM orders o
LEFT JOIN clients c ON o.client_id = c.id
WHERE c.id IS NULL

UNION ALL

SELECT 
    'ملفات بدون طلبات',
    COUNT(*)
FROM order_files f
LEFT JOIN orders o ON f.order_id = o.id
WHERE o.id IS NULL

UNION ALL

SELECT 
    'مدفوعات بدون طلبات',
    COUNT(*)
FROM payments p
LEFT JOIN orders o ON p.order_id = o.id
WHERE o.id IS NULL

UNION ALL

SELECT 
    'تعليقات بدون طلبات',
    COUNT(*)
FROM order_comments oc
LEFT JOIN orders o ON oc.order_id = o.id
WHERE o.id IS NULL;

-- 20. تنظيف البيانات القديمة (تشغيل بحذر!)
-- هذا مثال فقط - لا تشغله دون مراجعة
/*
-- حذف الطلبات المحذوفة نهائياً بعد 6 شهور
DELETE FROM orders 
WHERE deleted_at IS NOT NULL 
  AND deleted_at < DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- حذف سجلات التاريخ القديمة (أكثر من سنتين)
DELETE FROM order_history 
WHERE created_at < DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR);
*/