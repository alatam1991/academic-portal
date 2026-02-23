<?php

require_once __DIR__ . '/../../core/Controller.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';

class HomeController extends Controller
{
    public function index()
    {
        $this->view('login');
    }

    public function dashboard()
    {
        // التحقق من تسجيل الدخول + الصلاحية
        AuthMiddleware::check('view_dashboard');
        $this->view('dashboard');
        
    }
}