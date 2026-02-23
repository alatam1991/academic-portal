<!DOCTYPE html>
<html>
<head>
    <title>Academic Portal</title>
    <style>
        body { font-family: Arial; margin:0; padding:0; display:flex; }
        .sidebar {
            width:220px;
            background:#0f172a;
            color:white;
            min-height:100vh;
            padding:20px;
        }
        .sidebar a {
            display:block;
            color:white;
            text-decoration:none;
            margin:10px 0;
        }
        .main {
            flex:1;
        }
        .navbar {
            background:#1e3a8a;
            color:white;
            padding:15px;
        }
        .container {
            padding:20px;
        }
    </style>
</head>
<body>

<?php if(isset($_SESSION['user_id'])): ?>
<div class="sidebar">
    <h3>Menu</h3>

    <?php foreach($menuPermissions as $perm): ?>
        <a href="#">
            <?= ucfirst(str_replace('_', ' ', $perm['name'])); ?>
        </a>
    <?php endforeach; ?>

</div>
<?php endif; ?>

<div class="main">

<div class="navbar">
    Academic Portal
    <?php if(isset($_SESSION['user_name'])): ?>
        <span style="float:right;">
            <?= $_SESSION['user_name']; ?> |
            <a style="color:white;" href="/academic-portal/public/?url=login/logout">Logout</a>
        </span>
    <?php endif; ?>
</div>

<div class="container">