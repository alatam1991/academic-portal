<?php

require_once '../app/models/Permission.php';

class AuthMiddleware
{
    public static function check($requiredPermission)
{
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    if (!isset($_SESSION['user_id'])) {
        header("Location: /academic-portal/public/?url=login/index");
        exit;
    }

    if (!in_array($requiredPermission, $_SESSION['permissions'])) {
        die("Access Denied ❌");
    }
}}
