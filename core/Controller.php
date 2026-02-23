<?php

class Controller
{
    public function view($view, $data = [])
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        if (isset($_SESSION['permissions'])) {
            require_once __DIR__ . '/../app/models/Permission.php';
            $permissionModel = new Permission();
            $menuPermissions = $permissionModel
            ->getPermissionDetailsByNames($_SESSION['permissions']);
        } else {
            $menuPermissions = [];
        }

        extract($data);
        require_once __DIR__ . '/../app/views/layouts/header.php';
        require_once __DIR__ . '/../app/views/' . $view . '.php';
        require_once __DIR__ . '/../app/views/layouts/footer.php';
    }
}