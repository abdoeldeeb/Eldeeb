-- ==========================================================================
-- نظام إدارة الطلبات - قاعدة بيانات PostgreSQL
-- ==========================================================================

-- إنشاء قاعدة البيانات
-- CREATE DATABASE order_management_system
-- WITH ENCODING 'UTF8'
--      LC_COLLATE = 'ar_SA.UTF-8'
--      LC_CTYPE = 'ar_SA.UTF-8';

-- \c order_management_system;

-- إنشاء Schema للنظام
CREATE SCHEMA IF NOT EXISTS order_management;

-- تعيين Search Path
SET search_path TO order_management, public;

-- ==========================================================================
-- أنواع البيانات المخصصة (Custom Types)
-- ==========================================================================

-- نوع بيانات للأولويات
CREATE TYPE priority_type AS ENUM ('low', 'medium', 'high', 'urgent');

-- نوع بيانات لحالة الدفع
CREATE TYPE payment_status_type AS ENUM ('pending', 'partial', 'paid', 'refunded');

-- نوع بيانات لطريقة الدفع
CREATE TYPE payment_method_type AS ENUM ('cash', 'bank_transfer', 'credit_card', 'online', 'other');

-- نوع بيانات لحالة المدفوعات
CREATE TYPE payment_completion_type AS ENUM ('pending', 'completed', 'failed', 'refunded');

-- نوع بيانات لنوع العميل
CREATE TYPE client_type_enum AS ENUM ('individual', 'company');

-- نوع بيانات للغة المفضلة
CREATE TYPE language_type AS ENUM ('ar', 'en');

-- نوع بيانات لفئة الملف
CREATE TYPE file_category_type AS ENUM ('input', 'output', 'reference', 'other');

-- نوع بيانات لنوع التعليق
CREATE TYPE comment_type_enum AS ENUM ('internal', 'client', 'system');

-- نوع بيانات لنوع الإعداد
CREATE TYPE setting_type_enum AS ENUM ('string', 'number', 'boolean', 'json');

-- ==========================================================================
-- جدول أنواع الخدمات
-- ==========================================================================
CREATE TABLE service_types (
    id SERIAL PRIMARY KEY,
    type_key VARCHAR(50) NOT NULL UNIQUE,
    type_name_ar VARCHAR(100) NOT NULL,
    type_name_en VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول حالات الطلبات
-- ==========================================================================
CREATE TABLE order_statuses (
    id SERIAL PRIMARY KEY,
    status_key VARCHAR(50) NOT NULL UNIQUE,
    status_name_ar VARCHAR(100) NOT NULL,
    status_name_en VARCHAR(100) NOT NULL,
    status_color VARCHAR(20) DEFAULT '#6B7280',
    status_icon VARCHAR(50),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول العملاء
-- ==========================================================================
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) NOT NULL,
    phone_secondary VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100) DEFAULT 'Saudi Arabia',
    preferred_language language_type DEFAULT 'ar',
    client_type client_type_enum DEFAULT 'individual',
    company_name VARCHAR(255),
    tax_number VARCHAR(50),
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    total_orders INTEGER DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول الطلبات الرئيسي
-- ==========================================================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(20) NOT NULL UNIQUE,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    service_type_id INTEGER NOT NULL REFERENCES service_types(id),
    status_id INTEGER NOT NULL REFERENCES order_statuses(id),
    
    -- تفاصيل الطلب
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    delivery_notes TEXT,
    
    -- الأولوية والمواعيد
    priority priority_type DEFAULT 'medium',
    estimated_delivery_date DATE,
    actual_delivery_date DATE,
    
    -- التسعير
    estimated_price DECIMAL(10,2),
    final_price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'SAR',
    payment_status payment_status_type DEFAULT 'pending',
    
    -- المعلومات الإضافية
    source VARCHAR(50) DEFAULT 'website',
    assigned_to INTEGER, -- معرف الموظف المسؤول
    internal_notes TEXT,
    client_feedback TEXT,
    rating SMALLINT CHECK (rating >= 1 AND rating <= 5),
    
    -- التواريخ
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE NULL
);

-- ==========================================================================
-- جدول ملفات الطلبات
-- ==========================================================================
CREATE TABLE order_files (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT NOT NULL,
    file_type VARCHAR(100),
    mime_type VARCHAR(100),
    file_category file_category_type DEFAULT 'input',
    description TEXT,
    uploaded_by INTEGER,
    is_public BOOLEAN DEFAULT FALSE,
    download_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول تاريخ الطلبات (تتبع التغييرات)
-- ==========================================================================
CREATE TABLE order_history (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    old_status_id INTEGER REFERENCES order_statuses(id),
    new_status_id INTEGER NOT NULL REFERENCES order_statuses(id),
    changed_by INTEGER,
    change_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول التعليقات والملاحظات
-- ==========================================================================
CREATE TABLE order_comments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    user_id INTEGER,
    comment_type comment_type_enum DEFAULT 'internal',
    content TEXT NOT NULL,
    is_private BOOLEAN DEFAULT TRUE,
    parent_comment_id INTEGER REFERENCES order_comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول المدفوعات
-- ==========================================================================
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    payment_method payment_method_type DEFAULT 'bank_transfer',
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'SAR',
    transaction_id VARCHAR(100),
    payment_status payment_completion_type DEFAULT 'pending',
    payment_date TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    receipt_file VARCHAR(500),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================================================
-- جدول الإعدادات
-- ==========================================================================
CREATE TABLE system_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    setting_type setting_type_enum DEFAULT 'string',
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    category VARCHAR(50) DEFAULT 'general',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
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

-- فهارس مركبة للأداء
CREATE INDEX idx_orders_search ON orders(order_number, title);
CREATE INDEX idx_orders_date_range ON orders(created_at, estimated_delivery_date);
CREATE INDEX idx_orders_financial ON orders(payment_status, final_price, created_at);

-- ==========================================================================
-- الوظائف والإجراءات
-- ==========================================================================

-- دالة لتحديث timestamp تلقائياً
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- إنشاء triggers لتحديث updated_at
CREATE TRIGGER update_service_types_updated_at 
    BEFORE UPDATE ON service_types 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_order_statuses_updated_at 
    BEFORE UPDATE ON order_statuses 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at 
    BEFORE UPDATE ON clients 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_order_comments_updated_at 
    BEFORE UPDATE ON order_comments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at 
    BEFORE UPDATE ON payments 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_settings_updated_at 
    BEFORE UPDATE ON system_settings 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- دالة لإنشاء رقم طلب جديد
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TEXT AS $$
DECLARE
    next_number INTEGER;
BEGIN
    SELECT COALESCE(MAX(CAST(SUBSTRING(order_number FROM 5) AS INTEGER)), 0) + 1 
    INTO next_number 
    FROM orders 
    WHERE order_number LIKE 'ORD-%';
    
    RETURN 'ORD-' || LPAD(next_number::TEXT, 3, '0');
END;
$$ LANGUAGE plpgsql;

-- دالة لتحديث إحصائيات العميل
CREATE OR REPLACE FUNCTION update_client_stats(client_id_param INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE clients 
    SET 
        total_orders = (
            SELECT COUNT(*) 
            FROM orders 
            WHERE client_id = client_id_param 
            AND deleted_at IS NULL
        ),
        total_spent = (
            SELECT COALESCE(SUM(final_price), 0) 
            FROM orders 
            WHERE client_id = client_id_param 
            AND deleted_at IS NULL 
            AND payment_status = 'paid'
        )
    WHERE id = client_id_param;
END;
$$ LANGUAGE plpgsql;

-- دالة للحصول على إحصائيات شاملة
CREATE OR REPLACE FUNCTION get_order_statistics()
RETURNS TABLE(
    total_orders BIGINT,
    pending_orders BIGINT,
    processing_orders BIGINT,
    completed_orders BIGINT,
    delivered_orders BIGINT,
    rejected_orders BIGINT,
    revision_orders BIGINT,
    total_revenue DECIMAL,
    average_rating DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_orders,
        SUM(CASE WHEN s.status_key = 'pending' THEN 1 ELSE 0 END) as pending_orders,
        SUM(CASE WHEN s.status_key = 'processing' THEN 1 ELSE 0 END) as processing_orders,
        SUM(CASE WHEN s.status_key = 'completed' THEN 1 ELSE 0 END) as completed_orders,
        SUM(CASE WHEN s.status_key = 'delivered' THEN 1 ELSE 0 END) as delivered_orders,
        SUM(CASE WHEN s.status_key = 'rejected' THEN 1 ELSE 0 END) as rejected_orders,
        SUM(CASE WHEN s.status_key = 'revision' THEN 1 ELSE 0 END) as revision_orders,
        SUM(CASE WHEN o.payment_status = 'paid' THEN o.final_price ELSE 0 END) as total_revenue,
        AVG(o.rating) as average_rating
    FROM orders o
    JOIN order_statuses s ON o.status_id = s.id
    WHERE o.deleted_at IS NULL;
END;
$$ LANGUAGE plpgsql;

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
(1, 'internal', 'تم البدء في ترجمة الوثائق القانونية. المترجم المتخصص تم تخصيصه للمشروع.', TRUE),
(1, 'client', 'العميل راضٍ عن جودة الترجمة ويطلب خدمات إضافية في المستقبل.', FALSE),
(2, 'internal', 'الرسالة تحتاج إلى مراجعة شاملة للمصطلحات الأكاديمية.', TRUE),
(3, 'internal', 'العميل أرسل مرجعيات إضافية للتصميم.', TRUE),
(4, 'client', 'العميل طلب تعديل نبرة المحتوى لتكون أكثر ودية.', FALSE);

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
SELECT 'تم إنشاء قاعدة البيانات PostgreSQL بنجاح!' as message;

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