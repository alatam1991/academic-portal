<?php

class Router
{
    public static function route()
    {
        $url = $_GET['url'] ?? 'home/index';
        $url = explode('/', filter_var(trim($url), FILTER_SANITIZE_URL));

        $controllerName = ucfirst($url[0]) . 'Controller';
        $method = $url[1] ?? 'index';

        $controllerPath = __DIR__ . "/../app/controllers/$controllerName.php";

        // 1️⃣ تأكد أن الملف موجود
        if (!file_exists($controllerPath)) {
            die("Controller File Not Found ❌");
        }

        // 2️⃣ حمل الملف
        require_once $controllerPath;

        // 3️⃣ تأكد أن الكلاس موجود
        if (!class_exists($controllerName)) {
            die("Controller Class Not Found ❌");
        }

        $controller = new $controllerName;

        // 4️⃣ تأكد أن الميثود موجود
        if (!method_exists($controller, $method)) {
            die("Method Not Found ❌");
        }

        $controller->$method();
    }
}