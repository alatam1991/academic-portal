<?php

require_once __DIR__ . '/../../core/Controller.php';
require_once __DIR__ . '/../middleware/AuthMiddleware.php';
require_once __DIR__ . '/../models/User.php';

class UsersController extends Controller
{
    public function index()
    {
        AuthMiddleware::check('manage_users');

        $userModel = new User();
        $users = $userModel->getAllUsers();

        $this->view('users/index', ['users' => $users]);
    }
}