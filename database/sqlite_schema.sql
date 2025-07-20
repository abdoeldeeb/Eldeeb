-- ==========================================================================
-- نظام إدارة الطلبات - قاعدة بيانات SQLite
-- ==========================================================================

-- تفعيل المفاتيح الخارجية
PRAGMA foreign_keys = ON;
PRAGMA encoding = "UTF-8";

-- ==========================================================================
-- جدول أنواع الخدمات
-- ==========================================================================
CREATE TABLE service_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_key TEXT NOT NULL UNIQUE,
    type_name_ar TEXT NOT NULL,
    type_name_en TEXT NOT NULL,
    description TEXT,
    is_active INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول حالات الطلبات
-- ==========================================================================
CREATE TABLE order_statuses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    status_key TEXT NOT NULL UNIQUE,
    status_name_ar TEXT NOT NULL,
    status_name_en TEXT NOT NULL,
    status_color TEXT DEFAULT '#6B7280',
    status_icon TEXT,
    description TEXT,
    is_active INTEGER DEFAULT 1,
    sort_order INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول العملاء
-- ==========================================================================
CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT NOT NULL,
    phone_secondary TEXT,
    address TEXT,
    city TEXT,
    country TEXT DEFAULT 'Saudi Arabia',
    preferred_language TEXT DEFAULT 'ar' CHECK (preferred_language IN ('ar', 'en')),
    client_type TEXT DEFAULT 'individual' CHECK (client_type IN ('individual', 'company')),
    company_name TEXT,
    tax_number TEXT,
    notes TEXT,
    is_active INTEGER DEFAULT 1,
    total_orders INTEGER DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول الطلبات الرئيسي
-- ==========================================================================
CREATE TABLE orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_number TEXT NOT NULL UNIQUE,
    client_id INTEGER NOT NULL,
    service_type_id INTEGER NOT NULL,
    status_id INTEGER NOT NULL,
    
    -- تفاصيل الطلب
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    delivery_notes TEXT,
    
    -- الأولوية والمواعيد
    priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    
    -- التسعير
    estimated_price DECIMAL(10,2),
    final_price DECIMAL(10,2),
    currency TEXT DEFAULT 'SAR',
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'partial', 'paid', 'refunded')),
    
    -- المعلومات الإضافية
    source TEXT DEFAULT 'website',
    assigned_to INTEGER,
    internal_notes TEXT,
    client_feedback TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    
    -- التواريخ
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    
    -- المفاتيح الخارجية
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (service_type_id) REFERENCES service_types(id),
    FOREIGN KEY (status_id) REFERENCES order_statuses(id)
);

-- ==========================================================================
-- جدول ملفات الطلبات
-- ==========================================================================
CREATE TABLE order_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    file_type TEXT,
    mime_type TEXT,
    file_category TEXT DEFAULT 'input' CHECK (file_category IN ('input', 'output', 'reference', 'other')),
    description TEXT,
    uploaded_by INTEGER,
    is_public INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- ==========================================================================
-- جدول تاريخ الطلبات (تتبع التغييرات)
-- ==========================================================================
CREATE TABLE order_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    old_status_id INTEGER,
    new_status_id INTEGER NOT NULL,
    changed_by INTEGER,
    change_reason TEXT,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (old_status_id) REFERENCES order_statuses(id),
    FOREIGN KEY (new_status_id) REFERENCES order_statuses(id)
);

-- ==========================================================================
-- جدول التعليقات والملاحظات
-- ==========================================================================
CREATE TABLE order_comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    user_id INTEGER,
    comment_type TEXT DEFAULT 'internal' CHECK (comment_type IN ('internal', 'client', 'system')),
    content TEXT NOT NULL,
    is_private INTEGER DEFAULT 1,
    parent_comment_id INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES order_comments(id) ON DELETE CASCADE
);

-- ==========================================================================
-- جدول المدفوعات
-- ==========================================================================
CREATE TABLE payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    payment_method TEXT DEFAULT 'bank_transfer' CHECK (payment_method IN ('cash', 'bank_transfer', 'credit_card', 'online', 'other')),
    amount DECIMAL(10,2) NOT NULL,
    currency TEXT DEFAULT 'SAR',
    transaction_id TEXT,
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
    payment_date DATETIME,
    notes TEXT,
    receipt_file TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- ==========================================================================
-- جدول الإعدادات
-- ==========================================================================
CREATE TABLE system_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    setting_key TEXT NOT NULL UNIQUE,
    setting_value TEXT,
    setting_type TEXT DEFAULT 'string' CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
    description TEXT,
    is_public INTEGER DEFAULT 0,
    category TEXT DEFAULT 'general',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- إنشاء الفهارس
-- ==========================================================================

-- فهارس للعملاء
CREATE INDEX idx_clients_phone ON clients(phone);
CREATE INDEX idx_clients_email ON clients(email);
CREATE INDEX idx_clients_full_name ON clients(full_name);
CREATE INDEX idx_clients_client_type ON clients(client_type);

-- فهارس للطلبات
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_service_type_id ON orders(service_type_id);
CREATE INDEX idx_orders_status_id ON orders(status_id);
CREATE INDEX idx_orders_priority ON orders(priority);
CREATE INDEX idx_orders_estimated_delivery ON orders(estimated_delivery_date);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);

-- فهارس للملفات
CREATE INDEX idx_order_files_order_id ON order_files(order_id);
CREATE INDEX idx_order_files_file_category ON order_files(file_category);
CREATE INDEX idx_order_files_created_at ON order_files(created_at);

-- فهارس لتاريخ الطلبات
CREATE INDEX idx_order_history_order_id ON order_history(order_id);
CREATE INDEX idx_order_history_new_status_id ON order_history(new_status_id);
CREATE INDEX idx_order_history_created_at ON order_history(created_at);

-- فهارس للتعليقات
CREATE INDEX idx_order_comments_order_id ON order_comments(order_id);
CREATE INDEX idx_order_comments_comment_type ON order_comments(comment_type);
CREATE INDEX idx_order_comments_created_at ON order_comments(created_at);
CREATE INDEX idx_order_comments_parent_comment_id ON order_comments(parent_comment_id);

-- فهارس للمدفوعات
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_payment_status ON payments(payment_status);
CREATE INDEX idx_payments_payment_date ON payments(payment_date);
CREATE INDEX idx_payments_transaction_id ON payments(transaction_id);

-- فهارس للإعدادات
CREATE INDEX idx_system_settings_setting_key ON system_settings(setting_key);
CREATE INDEX idx_system_settings_category ON system_settings(category);

-- ==========================================================================
-- Triggers لتحديث updated_at
-- ==========================================================================

-- Trigger لجدول أنواع الخدمات
CREATE TRIGGER update_service_types_updated_at
    AFTER UPDATE ON service_types
    FOR EACH ROW
BEGIN
    UPDATE service_types SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول حالات الطلبات
CREATE TRIGGER update_order_statuses_updated_at
    AFTER UPDATE ON order_statuses
    FOR EACH ROW
BEGIN
    UPDATE order_statuses SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول العملاء
CREATE TRIGGER update_clients_updated_at
    AFTER UPDATE ON clients
    FOR EACH ROW
BEGIN
    UPDATE clients SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول الطلبات
CREATE TRIGGER update_orders_updated_at
    AFTER UPDATE ON orders
    FOR EACH ROW
BEGIN
    UPDATE orders SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول التعليقات
CREATE TRIGGER update_order_comments_updated_at
    AFTER UPDATE ON order_comments
    FOR EACH ROW
BEGIN
    UPDATE order_comments SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول المدفوعات
CREATE TRIGGER update_payments_updated_at
    AFTER UPDATE ON payments
    FOR EACH ROW
BEGIN
    UPDATE payments SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Trigger لجدول الإعدادات
CREATE TRIGGER update_system_settings_updated_at
    AFTER UPDATE ON system_settings
    FOR EACH ROW
BEGIN
    UPDATE system_settings SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- ==========================================================================
-- المشاهدات (Views)
-- ==========================================================================

-- مشهد شامل للطلبات مع تفاصيل العميل والخدمة
CREATE VIEW orders_detailed AS
SELECT 
    o.id,
    o.order_number,
    o.title,
    o.description,
    o.priority,
    o.estimated_delivery_date,
    o.actual_delivery_date,
    o.estimated_price,
    o.final_price,
    o.payment_status,
    o.rating,
    o.created_at,
    o.updated_at,
    
    -- معلومات العميل
    c.full_name as client_name,
    c.email as client_email,
    c.phone as client_phone,
    c.client_type,
    
    -- معلومات الخدمة
    st.type_name_ar as service_type_ar,
    st.type_name_en as service_type_en,
    
    -- معلومات الحالة
    s.status_name_ar,
    s.status_name_en,
    s.status_color,
    s.status_icon,
    
    -- إحصائيات
    (SELECT COUNT(*) FROM order_files WHERE order_id = o.id) as files_count,
    (SELECT COUNT(*) FROM order_comments WHERE order_id = o.id) as comments_count,
    (SELECT SUM(amount) FROM payments WHERE order_id = o.id AND payment_status = 'completed') as paid_amount
    
FROM orders o
JOIN clients c ON o.client_id = c.id
JOIN service_types st ON o.service_type_id = st.id
JOIN order_statuses s ON o.status_id = s.id
WHERE o.deleted_at IS NULL;

-- مشهد للإحصائيات اليومية
CREATE VIEW daily_statistics AS
SELECT 
    DATE(created_at) as date,
    COUNT(*) as orders_count,
    SUM(CASE WHEN payment_status = 'paid' THEN final_price ELSE 0 END) as daily_revenue,
    AVG(rating) as daily_rating
FROM orders 
WHERE deleted_at IS NULL
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- ==========================================================================
-- إدراج البيانات الأساسية
-- ==========================================================================

-- أنواع الخدمات
INSERT INTO service_types (type_key, type_name_ar, type_name_en, description) VALUES
('translation', 'ترجمة', 'Translation', 'خدمات الترجمة من وإلى اللغات المختلفة'),
('editing', 'تحرير وتدقيق', 'Editing & Proofreading', 'خدمات التحرير والتدقيق اللغوي'),
('design', 'تصميم', 'Design', 'خدمات التصميم الجرافيكي والهوية البصرية'),
('writing', 'كتابة محتوى', 'Content Writing', 'خدمات كتابة المحتوى والإعلانات'),
('research', 'بحث أكاديمي', 'Academic Research', 'خدمات البحث الأكاديمي والدراسات');

-- حالات الطلبات
INSERT INTO order_statuses (status_key, status_name_ar, status_name_en, status_color, status_icon, sort_order) VALUES
('pending', 'قيد المراجعة', 'Pending Review', '#F59E0B', 'clock', 1),
('processing', 'قيد المعالجة', 'In Progress', '#3B82F6', 'cog', 2),
('revision', 'تحتاج مراجعة', 'Needs Revision', '#EF4444', 'exclamation-triangle', 3),
('completed', 'مكتملة', 'Completed', '#10B981', 'check-circle', 4),
('delivered', 'تم التسليم', 'Delivered', '#059669', 'truck', 5),
('rejected', 'مرفوضة', 'Rejected', '#EF4444', 'x-circle', 6),
('cancelled', 'ملغية', 'Cancelled', '#6B7280', 'ban', 7);

-- العملاء التجريبيين
INSERT INTO clients (full_name, email, phone, address, city, client_type, notes) VALUES
('أحمد محمد العلي', 'ahmed.ali@email.com', '0501234567', 'حي النخيل، شارع الملك فهد', 'الرياض', 'individual', 'عميل مهم - إنجاز سريع'),
('فاطمة أحمد الزهراني', 'fatima.zahrani@email.com', '0507654321', 'حي الورود، طريق الملك عبدالعزيز', 'جدة', 'individual', 'رسالة ماجستير - دقة عالية مطلوبة'),
('شركة النجاح للتقنية', 'info@najah-tech.com', '0551239876', 'برج الأعمال، الدور العاشر', 'الرياض', 'company', 'مشروع كبير - عدة مراحل'),
('سارة عبدالله الحربي', 'sara.harbi@email.com', '0598765432', 'حي السلام، شارع العروبة', 'الدمام', 'individual', 'طلب تعديلات من العميل'),
('محمد سعد العتيبي', 'mohammed.otaibi@email.com', '0543217890', 'حي الفيصلية، طريق الأمير محمد', 'جدة', 'individual', 'متطلبات غير واضحة - رفض مؤقت'),
('شركة الإبداع للتسويق', 'contact@ibdaa-marketing.com', '0556789012', 'مجمع الأعمال التجاري', 'الخبر', 'company', 'عميل دائم - خصم خاص'),
('نورا خالد المطيري', 'nora.mutairi@email.com', '0591234567', 'حي الربوة، شارع التحلية', 'الرياض', 'individual', 'عميلة جديدة'),
('مؤسسة الأمل التعليمية', 'info@amal-edu.org', '0587654321', 'المنطقة التعليمية', 'مكة المكرمة', 'company', 'مؤسسة تعليمية');

-- الطلبات التجريبية
INSERT INTO orders (order_number, client_id, service_type_id, status_id, title, description, priority, estimated_delivery_date, estimated_price, payment_status, source) VALUES
('ORD-001', 1, 1, 4, 'ترجمة وثائق قانونية', 'ترجمة وثائق قانونية من الإنجليزية إلى العربية شاملة العقود والاتفاقيات', 'high', '2024-01-25', 1500.00, 'paid', 'website'),
('ORD-002', 2, 2, 2, 'تدقيق رسالة ماجستير', 'تدقيق لغوي شامل لرسالة ماجستير في الأدب العربي مع التركيز على القواعد والأسلوب', 'medium', '2024-01-30', 800.00, 'partial', 'email'),
('ORD-003', 3, 3, 1, 'تصميم هوية بصرية', 'تصميم هوية بصرية متكاملة لشركة ناشئة تشمل الشعار والألوان والخطوط', 'high', '2024-02-05', 3000.00, 'pending', 'phone'),
('ORD-004', 4, 4, 3, 'كتابة محتوى تسويقي', 'كتابة محتوى تسويقي إبداعي لموقع إلكتروني يشمل صفحات المنتجات والخدمات', 'medium', '2024-01-28', 1200.00, 'pending', 'website'),
('ORD-005', 5, 5, 6, 'بحث أكاديمي في تكنولوجيا المعلومات', 'إعداد بحث شامل في مجال تكنولوجيا المعلومات وتأثيرها على التعليم', 'low', '2024-02-01', 2000.00, 'pending', 'referral'),
('ORD-006', 6, 4, 2, 'حملة إعلانية رقمية', 'إنشاء محتوى لحملة إعلانية رقمية شاملة على وسائل التواصل الاجتماعي', 'high', '2024-02-10', 2500.00, 'partial', 'website'),
('ORD-007', 7, 1, 1, 'ترجمة كتيب طبي', 'ترجمة كتيب طبي متخصص من الإنجليزية إلى العربية مع مراجعة طبية', 'medium', '2024-02-15', 1800.00, 'pending', 'phone'),
('ORD-008', 8, 2, 4, 'مراجعة مناهج تعليمية', 'مراجعة وتدقيق مناهج تعليمية للمرحلة الابتدائية لضمان الجودة اللغوية', 'medium', '2024-01-20', 3500.00, 'paid', 'email');

-- ملفات الطلبات التجريبية
INSERT INTO order_files (order_id, file_name, file_path, file_size, file_type, file_category, description) VALUES
(1, 'contract.pdf', '/uploads/orders/1/contract.pdf', 2048000, 'application/pdf', 'input', 'العقد الأصلي للترجمة'),
(1, 'legal_docs.docx', '/uploads/orders/1/legal_docs.docx', 1536000, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'input', 'الوثائق القانونية المرفقة'),
(2, 'thesis.docx', '/uploads/orders/2/thesis.docx', 5120000, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'input', 'رسالة الماجستير للتدقيق'),
(3, 'brand_brief.pdf', '/uploads/orders/3/brand_brief.pdf', 1024000, 'application/pdf', 'input', 'ملخص متطلبات الهوية البصرية'),
(3, 'reference_designs.zip', '/uploads/orders/3/reference_designs.zip', 10240000, 'application/zip', 'reference', 'تصاميم مرجعية للإلهام'),
(4, 'website_content_guidelines.docx', '/uploads/orders/4/guidelines.docx', 512000, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'input', 'إرشادات كتابة المحتوى');

-- تاريخ الطلبات
INSERT INTO order_history (order_id, old_status_id, new_status_id, change_reason, notes) VALUES
(1, 1, 2, 'بدء العمل على الطلب', 'تم تخصيص مترجم متخصص'),
(1, 2, 4, 'اكتمال الترجمة', 'تم إنهاء الترجمة ومراجعتها'),
(2, 1, 2, 'بدء المراجعة', 'تم تخصيص مدقق لغوي'),
(4, 1, 3, 'طلب توضيحات', 'العميل طلب تعديلات على المحتوى'),
(5, 1, 6, 'متطلبات غير واضحة', 'تم رفض الطلب لعدم وضوح المتطلبات');

-- التعليقات
INSERT INTO order_comments (order_id, comment_type, content, is_private) VALUES
(1, 'internal', 'تم البدء في ترجمة الوثائق القانونية. المترجم المتخصص تم تخصيصه للمشروع.', 1),
(1, 'client', 'العميل راضٍ عن جودة الترجمة ويطلب خدمات إضافية في المستقبل.', 0),
(2, 'internal', 'الرسالة تحتاج إلى مراجعة شاملة للمصطلحات الأكاديمية.', 1),
(3, 'internal', 'العميل أرسل مرجعيات إضافية للتصميم.', 1),
(4, 'client', 'العميل طلب تعديل نبرة المحتوى لتكون أكثر ودية.', 0);

-- المدفوعات
INSERT INTO payments (order_id, payment_method, amount, transaction_id, payment_status, payment_date, notes) VALUES
(1, 'bank_transfer', 1500.00, 'TXN-2024-001', 'completed', '2024-01-22 10:30:00', 'دفعة كاملة عبر التحويل البنكي'),
(2, 'online', 400.00, 'TXN-2024-002', 'completed', '2024-01-19 14:15:00', 'دفعة أولى - 50% من القيمة'),
(6, 'credit_card', 1250.00, 'TXN-2024-003', 'completed', '2024-01-25 09:45:00', 'دفعة أولى للحملة الإعلانية'),
(8, 'bank_transfer', 3500.00, 'TXN-2024-004', 'completed', '2024-01-18 11:20:00', 'دفعة كاملة للمناهج التعليمية');

-- إعدادات النظام
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, category) VALUES
('company_name', 'شركة الإبداع للخدمات اللغوية', 'string', 'اسم الشركة', 'company'),
('company_email', 'info@creativity-lang.com', 'string', 'البريد الإلكتروني للشركة', 'company'),
('company_phone', '+966-11-234-5678', 'string', 'هاتف الشركة', 'company'),
('company_address', 'الرياض، المملكة العربية السعودية', 'string', 'عنوان الشركة', 'company'),
('default_currency', 'SAR', 'string', 'العملة الافتراضية', 'general'),
('tax_rate', '15', 'number', 'نسبة الضريبة المضافة', 'financial'),
('max_file_size', '10485760', 'number', 'الحد الأقصى لحجم الملف بالبايت (10 ميجا)', 'uploads'),
('allowed_file_types', '["pdf","doc","docx","jpg","jpeg","png","txt","zip"]', 'json', 'أنواع الملفات المسموحة', 'uploads'),
('email_notifications', 'true', 'boolean', 'تفعيل الإشعارات عبر البريد الإلكتروني', 'notifications'),
('auto_backup', 'true', 'boolean', 'تفعيل النسخ الاحتياطي التلقائي', 'system');

-- ==========================================================================
-- إحصائيات سريعة
-- ==========================================================================

-- عرض إحصائيات سريعة
SELECT 'تم إنشاء قاعدة البيانات SQLite بنجاح!' as message;

SELECT 
    (SELECT COUNT(*) FROM clients) as total_clients,
    (SELECT COUNT(*) FROM orders) as total_orders,
    (SELECT COUNT(*) FROM order_files) as total_files,
    (SELECT COUNT(*) FROM service_types) as service_types_count,
    (SELECT COUNT(*) FROM order_statuses) as status_types_count;

-- عرض أحدث الطلبات
SELECT 
    order_number,
    title,
    client_name,
    service_type_ar,
    status_name_ar,
    created_at
FROM orders_detailed 
ORDER BY created_at DESC 
LIMIT 5;