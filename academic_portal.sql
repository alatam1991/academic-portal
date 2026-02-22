-- ============================================
-- إنشاء قاعدة البيانات
-- ============================================

CREATE DATABASE IF NOT EXISTS academic_portal;
-- إنشاء قاعدة بيانات باسم academic_portal إذا لم تكن موجودة

USE academic_portal;
-- تحديد قاعدة البيانات للعمل عليها


-- ============================================
-- 1️⃣ Core System
-- ============================================

-- جدول الأدوار (الصلاحيات العامة مثل عميد، طالب، عضو هيئة تدريس)
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY, -- معرف فريد لكل دور
    name VARCHAR(100) NOT NULL, -- اسم الدور
    description TEXT, -- وصف الدور
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- تاريخ الإنشاء
);

-- جدول المستخدمين (كل من يدخل النظام)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- معرف المستخدم
    name VARCHAR(150) NOT NULL, -- الاسم الكامل
    email VARCHAR(150) UNIQUE NOT NULL, -- البريد الإلكتروني فريد
    password VARCHAR(255) NOT NULL, -- كلمة المرور مشفرة
    role_id INT NOT NULL, -- الدور المرتبط بالمستخدم
    status ENUM('active','inactive') DEFAULT 'active', -- حالة الحساب
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- تاريخ الإنشاء
    FOREIGN KEY (role_id) REFERENCES roles(id) -- ربط المستخدم بالدور
);

-- جدول الصلاحيات التفصيلية
CREATE TABLE permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL, -- اسم الصلاحية
    module VARCHAR(100) NOT NULL -- اسم النظام المرتبط
);

-- جدول ربط الأدوار بالصلاحيات
CREATE TABLE role_permissions (
    role_id INT,
    permission_id INT,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (permission_id) REFERENCES permissions(id)
);

-- جدول سجل العمليات (Logs)
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


-- ============================================
-- 2️⃣ الهيكل الأكاديمي
-- ============================================

-- جدول الأقسام
CREATE TABLE departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول أعضاء هيئة التدريس
CREATE TABLE instructors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    department_id INT,
    academic_rank VARCHAR(100), -- الدرجة العلمية
    hire_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- جدول الطلاب
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    department_id INT,
    level INT, -- المستوى الدراسي
    gpa DECIMAL(4,2) DEFAULT 0.00, -- المعدل التراكمي
    enrollment_year YEAR,
    status ENUM('active','graduated','suspended') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (department_id) REFERENCES departments(id)
);


-- ============================================
-- 3️⃣ الخطط والمقررات
-- ============================================

-- جدول الخطط الدراسية
CREATE TABLE study_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    name VARCHAR(150),
    description TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- جدول المقررات
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT,
    course_code VARCHAR(50) UNIQUE,
    course_name VARCHAR(150),
    credit_hours INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- جدول ربط الخطة بالمقررات
CREATE TABLE plan_courses (
    plan_id INT,
    course_id INT,
    semester INT,
    PRIMARY KEY (plan_id, course_id),
    FOREIGN KEY (plan_id) REFERENCES study_plans(id),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);


-- ============================================
-- 4️⃣ القاعات والجداول
-- ============================================

-- جدول القاعات
CREATE TABLE classrooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(50),
    capacity INT,
    type ENUM('lecture','lab')
);

-- جدول الجداول الدراسية
CREATE TABLE schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    instructor_id INT,
    classroom_id INT,
    day_of_week VARCHAR(20),
    start_time TIME,
    end_time TIME,
    semester VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES courses(id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(id),
    FOREIGN KEY (classroom_id) REFERENCES classrooms(id)
);


-- ============================================
-- 5️⃣ التسجيل والنتائج
-- ============================================

-- جدول تسجيل الطلاب في المقررات
CREATE TABLE registrations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    schedule_id INT,
    registration_date DATE,
    status ENUM('registered','withdrawn') DEFAULT 'registered',
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id)
);

-- جدول الدرجات
CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id INT,
    midterm DECIMAL(5,2),
    final_exam DECIMAL(5,2),
    total DECIMAL(5,2),
    grade_letter VARCHAR(2),
    FOREIGN KEY (registration_id) REFERENCES registrations(id)
);

-- جدول الحضور
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id INT,
    date DATE,
    status ENUM('present','absent','excused'),
    FOREIGN KEY (registration_id) REFERENCES registrations(id)
);

-- جدول الإنذارات الأكاديمية
CREATE TABLE warnings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    reason TEXT,
    warning_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(id)
);


-- ============================================
-- 6️⃣ التعليم الإلكتروني
-- ============================================

-- جدول الواجبات
CREATE TABLE assignments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    title VARCHAR(150),
    description TEXT,
    due_date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- جدول المشاريع
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    title VARCHAR(150),
    description TEXT,
    due_date DATE,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- جدول الإعلانات
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    content TEXT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id)
);


-- ============================================
-- 7️⃣ المراسلات
-- ============================================

CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT,
    receiver_id INT,
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id)
);


-- ============================================
-- 8️⃣ الجودة والتقارير
-- ============================================

CREATE TABLE reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    generated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (generated_by) REFERENCES users(id)
);


-- ============================================
-- 9️⃣ الأرشفة الإلكترونية
-- ============================================

CREATE TABLE archives (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150),
    file_path VARCHAR(255),
    uploaded_by INT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(id)
);