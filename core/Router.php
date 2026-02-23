<?php

class Router
{
    public static function route()
    {
        $url = $_GET['url'] ?? 'home/index';

        $url = explode('/', $url);

        $controllerName = ucfirst($url[0]) . 'Controller';
        $method = $url[1] ?? 'index';

        require_once "../app/controllers/$controllerName.php";

        $controller = new $controllerName;
        $controller->$method();
    }
}