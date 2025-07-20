# قواعد البيانات - نظام إدارة الطلبات

دليل شامل لإعداد واستخدام قواعد البيانات المختلفة لنظام إدارة الطلبات.

## 📋 نظرة عامة

يدعم النظام ثلاث أنواع رئيسية من قواعد البيانات:
- **MySQL/MariaDB** - للمشاريع المتوسطة والكبيرة
- **PostgreSQL** - للمشاريع المتقدمة التي تحتاج ميزات متطورة
- **SQLite** - للمشاريع الصغيرة والنماذج الأولية

## 🗂️ هيكل الملفات

```
database/
├── README.md                 # هذا الملف
├── mysql_schema.sql          # قاعدة بيانات MySQL
├── postgresql_schema.sql     # قاعدة بيانات PostgreSQL
├── sqlite_schema.sql         # قاعدة بيانات SQLite
├── useful_queries.sql        # استعلامات مفيدة
└── migration_scripts/        # نصوص الترحيل (إذا لزم الأمر)
```

## 🗄️ هيكل قاعدة البيانات

### الجداول الأساسية

1. **`service_types`** - أنواع الخدمات
   - ترجمة، تحرير، تصميم، كتابة، بحث أكاديمي

2. **`order_statuses`** - حالات الطلبات
   - قيد المراجعة، قيد المعالجة، مكتملة، مرفوضة، تحتاج مراجعة

3. **`clients`** - بيانات العملاء
   - معلومات شخصية، عنوان، نوع العميل (فرد/شركة)

4. **`orders`** - الطلبات الرئيسية
   - تفاصيل الطلب، التسعير، المواعيد، الأولوية

5. **`order_files`** - ملفات الطلبات
   - ملفات مدخلة، مخرجة، مرجعية

6. **`order_history`** - تاريخ التغييرات
   - تتبع تغييرات حالة الطلب

7. **`order_comments`** - التعليقات والملاحظات
   - تعليقات داخلية، تعليقات العملاء

8. **`payments`** - المدفوعات
   - تفاصيل الدفع، طرق الدفع، حالة الدفع

9. **`system_settings`** - إعدادات النظام
   - إعدادات الشركة، إعدادات النظام

### المشاهدات (Views)

- **`orders_detailed`** - عرض شامل للطلبات مع تفاصيل العميل والخدمة
- **`daily_statistics`** - إحصائيات يومية للطلبات والإيرادات

### الوظائف والإجراءات

- **`generate_order_number()`** - توليد رقم طلب جديد
- **`update_client_stats()`** - تحديث إحصائيات العميل
- **`get_order_statistics()`** - الحصول على إحصائيات شاملة

## 🚀 إعداد قواعد البيانات

### 1. MySQL/MariaDB

#### المتطلبات
- MySQL 5.7+ أو MariaDB 10.3+
- دعم UTF-8mb4

#### خطوات الإعداد
```bash
# 1. الاتصال بـ MySQL
mysql -u root -p

# 2. تشغيل ملف الإعداد
source /path/to/mysql_schema.sql
```

#### إعدادات MySQL المطلوبة
```sql
-- في ملف my.cnf
[mysqld]
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
sql_mode = STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO

[mysql]
default-character-set = utf8mb4

[client]
default-character-set = utf8mb4
```

### 2. PostgreSQL

#### المتطلبات
- PostgreSQL 12+
- دعم UTF-8

#### خطوات الإعداد
```bash
# 1. الاتصال بـ PostgreSQL
psql -U postgres

# 2. إنشاء قاعدة البيانات
CREATE DATABASE order_management_system
WITH ENCODING 'UTF8'
     LC_COLLATE = 'ar_SA.UTF-8'
     LC_CTYPE = 'ar_SA.UTF-8';

# 3. الاتصال بقاعدة البيانات الجديدة
\c order_management_system

# 4. تشغيل ملف الإعداد
\i /path/to/postgresql_schema.sql
```

### 3. SQLite

#### المتطلبات
- SQLite 3.25+
- دعم JSON (للإعدادات المتقدمة)

#### خطوات الإعداد
```bash
# 1. إنشاء قاعدة البيانات
sqlite3 order_management.db

# 2. تشغيل ملف الإعداد
.read sqlite_schema.sql
```

## 📊 البيانات التجريبية

جميع ملفات قواعد البيانات تحتوي على بيانات تجريبية تشمل:

### العملاء (8 عملاء)
- 6 عملاء أفراد
- 2 شركات/مؤسسات
- بيانات اتصال كاملة

### الطلبات (8 طلبات)
- 5 أنواع خدمات مختلفة
- حالات متنوعة (مكتملة، قيد المعالجة، مرفوضة، إلخ)
- ملفات مرفقة ومدفوعات

### البيانات المرجعية
- 5 أنواع خدمات
- 7 حالات طلبات
- إعدادات نظام شاملة

## 🔍 استعلامات مفيدة

### الإحصائيات العامة
```sql
-- إحصائيات شاملة للطلبات
SELECT * FROM get_order_statistics(); -- PostgreSQL/MySQL
```

### البحث والفلترة
```sql
-- البحث في الطلبات
SELECT * FROM orders_detailed 
WHERE client_name LIKE '%أحمد%' 
   OR title LIKE '%ترجمة%';

-- الطلبات حسب الحالة
SELECT status_name_ar, COUNT(*) as count
FROM orders_detailed 
GROUP BY status_name_ar;
```

### التقارير المالية
```sql
-- الإيرادات الشهرية
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') as month,
    COUNT(*) as orders_count,
    SUM(final_price) as total_revenue
FROM orders 
WHERE payment_status = 'paid'
GROUP BY DATE_FORMAT(created_at, '%Y-%m');
```

## 🔧 الصيانة والنسخ الاحتياطي

### MySQL
```bash
# إنشاء نسخة احتياطية
mysqldump -u username -p order_management_system > backup.sql

# استعادة النسخة الاحتياطية
mysql -u username -p order_management_system < backup.sql
```

### PostgreSQL
```bash
# إنشاء نسخة احتياطية
pg_dump -U username order_management_system > backup.sql

# استعادة النسخة الاحتياطية
psql -U username order_management_system < backup.sql
```

### SQLite
```bash
# إنشاء نسخة احتياطية
cp order_management.db backup_$(date +%Y%m%d).db

# أو باستخدام SQL
sqlite3 order_management.db ".backup backup.db"
```

## 📈 تحسين الأداء

### فهارس مُحسَّنة للأداء
جميع قواعد البيانات تحتوي على فهارس محسنة:

```sql
-- فهارس البحث السريع
CREATE INDEX idx_orders_search ON orders (order_number, title);

-- فهارس التقارير الزمنية
CREATE INDEX idx_orders_date_range ON orders (created_at, estimated_delivery_date);

-- فهارس التقارير المالية
CREATE INDEX idx_orders_financial ON orders (payment_status, final_price, created_at);
```

### نصائح لتحسين الأداء

1. **استخدم المشاهدات** للاستعلامات المعقدة المتكررة
2. **احرص على الفهارس** للحقول المستخدمة في WHERE و JOIN
3. **نظف البيانات القديمة** دورياً باستخدام `deleted_at`
4. **راقب حجم جدول التاريخ** `order_history`

## 🔐 الأمان

### أفضل الممارسات

1. **تشفير كلمات المرور** قبل التخزين
2. **استخدام المعاملات** للعمليات المالية
3. **تدقيق العمليات** في جدول التاريخ
4. **النسخ الاحتياطية المنتظمة**

### المفاتيح الخارجية
جميع الجداول محمية بمفاتيح خارجية لضمان:
- سلامة البيانات
- الحذف المتتالي الآمن
- منع البيانات المتيتمة

## 🔄 الترحيل والتحديث

### إضافة حقول جديدة
```sql
-- مثال: إضافة حقل جديد لجدول العملاء
ALTER TABLE clients ADD COLUMN social_media_handle VARCHAR(100);
```

### تحديث هيكل البيانات
```sql
-- مثال: تحديث نوع بيانات
ALTER TABLE orders MODIFY COLUMN priority ENUM('low', 'medium', 'high', 'urgent', 'critical');
```

## 🐛 استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### مشكلة الترميز
```sql
-- للتحقق من ترميز قاعدة البيانات
SHOW CREATE DATABASE order_management_system; -- MySQL
```

#### مشكلة المفاتيح الخارجية
```sql
-- تعطيل فحص المفاتيح الخارجية مؤقتاً (للضرورة فقط)
SET FOREIGN_KEY_CHECKS = 0; -- MySQL
```

#### مشكلة الصلاحيات
```sql
-- منح الصلاحيات المطلوبة
GRANT ALL PRIVILEGES ON order_management_system.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```

## 📞 الدعم

إذا واجهت مشاكل في إعداد قاعدة البيانات:

1. تأكد من إصدار قاعدة البيانات
2. تحقق من إعدادات الترميز
3. راجع ملفات سجل الأخطاء
4. تأكد من الصلاحيات المطلوبة

---

**ملاحظة**: هذا النظام مصمم للاستخدام مع البيانات باللغة العربية، لذا تأكد من إعداد الترميز بشكل صحيح لضمان عرض النصوص العربية بشكل سليم.