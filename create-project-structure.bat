@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM =================================================================
REM Order Management System - Project Structure Creator (Windows)
REM إنشاء الهيكل التنظيمي لنظام إدارة الطلبات - ويندوز
REM =================================================================

REM Project configuration
set PROJECT_NAME=order-management-system
set VERSION=2.0.0
set AUTHOR=AI Assistant
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set DATE=%%c-%%a-%%b

echo.
echo ===============================================
echo     🚀 Order Management System Creator
echo     مُنشئ نظام إدارة الطلبات
echo ===============================================
echo.

echo [INFO] بدء إنشاء الهيكل التنظيمي للمشروع...
echo.

REM Check if project directory exists
if exist "%PROJECT_NAME%" (
    echo [WARNING] المجلد %PROJECT_NAME% موجود بالفعل!
    set /p response="هل تريد الاستمرار والكتابة فوقه؟ (y/N): "
    if /i not "!response!"=="y" (
        echo [ERROR] تم إلغاء العملية
        pause
        exit /b 1
    )
    rmdir /s /q "%PROJECT_NAME%"
)

echo [✓] إنشاء الهيكل التنظيمي للمجلدات...

REM Create main project directory
mkdir "%PROJECT_NAME%"
cd "%PROJECT_NAME%"

REM Create directory structure
mkdir assets\css
mkdir assets\js
mkdir assets\images
mkdir assets\fonts
mkdir assets\icons
mkdir components
mkdir pages
mkdir utils
mkdir api\routes
mkdir api\controllers
mkdir api\middleware
mkdir api\models
mkdir config
mkdir database\migrations
mkdir database\seeds
mkdir database\backups
mkdir docs\api
mkdir docs\user-guide
mkdir docs\development
mkdir tests\unit
mkdir tests\integration
mkdir tests\e2e
mkdir build
mkdir dist
mkdir deploy
mkdir logs
mkdir temp
mkdir public
mkdir src
mkdir storage\uploads
mkdir storage\cache
mkdir storage\sessions

echo [✓] تم إنشاء الهيكل التنظيمي للمجلدات

echo [✓] إنشاء الملف الرئيسي index.html...

REM Create main HTML file
(
echo ^<!DOCTYPE html^>
echo ^<html lang="ar" dir="rtl"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>نظام إدارة الطلبات^</title^>
echo     ^<script src="https://cdn.tailwindcss.com"^>^</script^>
echo     ^<link href="https://fonts.googleapis.com/css2?family=Tajawal:wght@300;400;500;700&display=swap" rel="stylesheet"^>
echo     ^<link rel="stylesheet" href="assets/css/styles.css"^>
echo ^</head^>
echo ^<body class="bg-gray-50 font-arabic"^>
echo     ^<div id="loadingScreen" class="fixed inset-0 bg-white z-50 flex items-center justify-center"^>
echo         ^<div class="text-center"^>
echo             ^<div class="loading-spinner mb-4"^>^</div^>
echo             ^<p class="text-gray-600"^>جاري تحميل النظام...^</p^>
echo         ^</div^>
echo     ^</div^>
echo     ^<div id="app" class="hidden"^>
echo         ^<header id="mainHeader"^>^</header^>
echo         ^<nav id="mainNavigation"^>^</nav^>
echo         ^<main id="mainContent" class="container mx-auto px-4 py-8"^>^</main^>
echo         ^<footer id="mainFooter"^>^</footer^>
echo     ^</div^>
echo     ^<div id="modalsContainer"^>^</div^>
echo     ^<div id="notificationsContainer"^>^</div^>
echo     ^<script src="assets/js/config.js"^>^</script^>
echo     ^<script src="assets/js/utils.js"^>^</script^>
echo     ^<script src="assets/js/data.js"^>^</script^>
echo     ^<script src="assets/js/notifications.js"^>^</script^>
echo     ^<script src="assets/js/components.js"^>^</script^>
echo     ^<script src="assets/js/app.js"^>^</script^>
echo ^</body^>
echo ^</html^>
) > index.html

echo [✓] إنشاء ملفات CSS...

REM Create main CSS file
(
echo /* نظام إدارة الطلبات - الأنماط الرئيسية */
echo :root {
echo     --primary-color: #3b82f6;
echo     --secondary-color: #10b981;
echo     --accent-color: #f59e0b;
echo     --danger-color: #ef4444;
echo     --dark-color: #1f2937;
echo     --light-color: #f8fafc;
echo     --border-radius: 8px;
echo     --box-shadow: 0 4px 6px -1px rgba^(0, 0, 0, 0.1^);
echo     --transition: all 0.3s ease;
echo }
echo.
echo * {
echo     box-sizing: border-box;
echo     margin: 0;
echo     padding: 0;
echo }
echo.
echo body {
echo     font-family: 'Tajawal', Arial, sans-serif;
echo     line-height: 1.6;
echo     color: var^(--dark-color^);
echo     direction: rtl;
echo     text-align: right;
echo }
echo.
echo .loading-spinner {
echo     width: 40px;
echo     height: 40px;
echo     border: 4px solid #f3f4f6;
echo     border-top: 4px solid var^(--primary-color^);
echo     border-radius: 50%%;
echo     animation: spin 1s linear infinite;
echo     margin: 0 auto;
echo }
echo.
echo @keyframes spin {
echo     0%% { transform: rotate^(0deg^); }
echo     100%% { transform: rotate^(360deg^); }
echo }
) > assets\css\styles.css

echo [✓] إنشاء ملفات JavaScript...

REM Create config.js
(
echo const CONFIG = {
echo     APP_NAME: 'نظام إدارة الطلبات',
echo     VERSION: '2.0.0',
echo     AUTHOR: 'فريق التطوير',
echo     SERVICE_TYPES: {
echo         translation: { ar: 'ترجمة', en: 'Translation', icon: '🌐', color: '#3b82f6' },
echo         editing: { ar: 'تحرير وتدقيق', en: 'Editing', icon: '✏️', color: '#10b981' },
echo         design: { ar: 'تصميم', en: 'Design', icon: '🎨', color: '#8b5cf6' },
echo         writing: { ar: 'كتابة محتوى', en: 'Writing', icon: '📝', color: '#f59e0b' }
echo     },
echo     ORDER_STATUSES: {
echo         pending: { ar: 'قيد المراجعة', en: 'Pending', color: '#f59e0b' },
echo         processing: { ar: 'قيد المعالجة', en: 'Processing', color: '#3b82f6' },
echo         completed: { ar: 'مكتملة', en: 'Completed', color: '#10b981' },
echo         rejected: { ar: 'مرفوضة', en: 'Rejected', color: '#ef4444' }
echo     }
echo };
) > assets\js\config.js

REM Create basic app.js
(
echo class OrderManagementApp {
echo     constructor^(^) {
echo         this.init^(^);
echo     }
echo     init^(^) {
echo         document.getElementById^('loadingScreen'^).style.display = 'none';
echo         document.getElementById^('app'^).classList.remove^('hidden'^);
echo         document.getElementById^('mainHeader'^).innerHTML = '^<h1^>نظام إدارة الطلبات^</h1^>';
echo         document.getElementById^('mainContent'^).innerHTML = '^<p^>مرحباً بك في نظام إدارة الطلبات!^</p^>';
echo     }
echo }
echo document.addEventListener^('DOMContentLoaded', ^(^) =^> {
echo     new OrderManagementApp^(^);
echo }^);
) > assets\js\app.js

echo [✓] إنشاء ملفات التوثيق...

REM Create README.md
(
echo # نظام إدارة الطلبات
echo Order Management System
echo.
echo ## 📋 نظرة عامة
echo نظام شامل لإدارة طلبات العملاء والخدمات مع واجهة مستخدم حديثة ومتجاوبة.
echo.
echo ## ✨ المميزات
echo - إدارة الطلبات ^(إضافة، تعديل، حذف، عرض^)
echo - إدارة العملاء التلقائية
echo - تتبع حالات الطلبات
echo - إحصائيات شاملة
echo - تصميم متجاوب
echo - حفظ البيانات محلياً
echo.
echo ## 🚀 التثبيت والتشغيل
echo 1. حمل الملفات أو استنسخ المشروع
echo 2. افتح ملف `index.html` في المتصفح
echo 3. ابدأ في استخدام النظام!
echo.
echo ## 🛠️ التقنيات المستخدمة
echo - HTML5
echo - CSS3 / Tailwind CSS
echo - JavaScript ES6+
echo - Local Storage
echo.
echo ---
echo تم إنشاؤه بواسطة فريق التطوير - %DATE%
) > README.md

echo [✓] إنشاء ملفات قاعدة البيانات...

REM Create database schema
(
echo -- نظام إدارة الطلبات - مخطط قاعدة البيانات
echo CREATE TABLE clients ^(
echo     id INT PRIMARY KEY AUTO_INCREMENT,
echo     name VARCHAR^(255^) NOT NULL,
echo     email VARCHAR^(255^) UNIQUE NOT NULL,
echo     phone VARCHAR^(20^) NOT NULL,
echo     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
echo ^);
echo.
echo CREATE TABLE orders ^(
echo     id INT PRIMARY KEY AUTO_INCREMENT,
echo     order_number VARCHAR^(50^) UNIQUE NOT NULL,
echo     client_id INT NOT NULL,
echo     service_type VARCHAR^(50^) NOT NULL,
echo     title VARCHAR^(255^) NOT NULL,
echo     description TEXT,
echo     status ENUM^('pending', 'processing', 'completed', 'rejected'^) DEFAULT 'pending',
echo     priority ENUM^('low', 'medium', 'high', 'urgent'^) DEFAULT 'medium',
echo     estimated_price DECIMAL^(10,2^),
echo     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
echo     FOREIGN KEY ^(client_id^) REFERENCES clients^(id^) ON DELETE CASCADE
echo ^);
) > database\schema.sql

echo [✓] إنشاء ملفات الإعدادات...

REM Create package.json
(
echo {
echo   "name": "%PROJECT_NAME%",
echo   "version": "%VERSION%",
echo   "description": "نظام شامل لإدارة طلبات العملاء والخدمات",
echo   "main": "index.html",
echo   "scripts": {
echo     "start": "live-server --port=3000 --host=localhost"
echo   },
echo   "keywords": ["order-management", "crm", "arabic"],
echo   "author": "%AUTHOR%",
echo   "license": "MIT"
echo }
) > package.json

REM Create .gitignore
(
echo node_modules/
echo dist/
echo build/
echo *.log
echo .env
echo temp/
echo logs/
) > .gitignore

echo [✓] إنشاء ملفات إضافية...

REM Create empty files for directories
echo. > storage\uploads\.gitkeep
echo. > storage\cache\.gitkeep
echo. > storage\sessions\.gitkeep
echo. > database\backups\.gitkeep
echo. > logs\.gitkeep
echo. > temp\.gitkeep

REM Create LICENSE
(
echo MIT License
echo.
echo Copyright ^(c^) %date:~6,4% %AUTHOR%
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files ^(the "Software"^), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
) > LICENSE

echo.
echo ===============================================
echo ✅ تم إنشاء المشروع بنجاح!
echo ===============================================
echo.
echo 📁 اسم المشروع: %PROJECT_NAME%
echo 📅 تاريخ الإنشاء: %DATE%
echo 🏷️  الإصدار: %VERSION%
echo.
echo الخطوات التالية:
echo 1. cd %PROJECT_NAME%
echo 2. افتح index.html في المتصفح
echo 3. أو استخدم: npm install ^&^& npm start
echo.
echo 🎉 تم إنشاء نظام إدارة الطلبات بنجاح!
echo المشروع جاهز للاستخدام والتطوير!
echo.
pause