<?php

require_once '../core/Controller.php';
require_once '../app/models/User.php';

class LoginController extends Controller
{
    public function index()
    {
        $this->view('login');
    }

    public function authenticate()
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $email = $_POST['email'];
        $password = $_POST['password'];

        $userModel = new User();
        $user = $userModel->findByEmail($email);

        if ($user && password_verify($password, $user['password'])) {
            require_once '../app/models/Permission.php';
            $permissionModel = new Permission();
            $permissions = $permissionModel->getPermissionsByRole($user['role_id']);

            $_SESSION['user_id'] = $user['id'];
            $_SESSION['user_name'] = $user['name'];
            $_SESSION['role_id'] = $user['role_id'];
            $_SESSION['permissions'] = $permissions; // 🔥 تخزين الصلاحيات

            header("Location: /academic-portal/public/?url=home/dashboard");
            exit;

        } else {
            echo "Invalid Email or Password";
        }
    }
     public function logout()
    {
        session_start();

        $_SESSION = [];

        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                time() - 42000,
                $params["path"],
                $params["domain"],
                $params["secure"],
                $params["httponly"]
            );
        }
        #session_unset();
        session_destroy();

        header("Location: /academic-portal/public/?url=login/index");
        exit;
    }
}
