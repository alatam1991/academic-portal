<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>Academic Portal Login</h2>

<form method="POST" action="/academic-portal/public/?url=login/authenticate">
    <input type="email" name="email" placeholder="Email" required><br><br>
    <input type="password" name="password" placeholder="Password" required><br><br>
    <button type="submit">Login</button>
</form>

</body>
</html>