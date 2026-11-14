<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Admin Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="index.html" class="logo">CodeQuest Admin</a>
        <nav class="nav-links">
            <a href="index.html">Home</a>
            <a href="login.jsp">Student Login</a>
        </nav>
    </header>

    <div class="container">
        <h2>Admin Authentication</h2>

        <% 
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) { 
        %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <% } %>

        <form action="AdminLoginServlet" method="post">
            <div class="form-group">
                <label for="username">Admin Username</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn">Login as Admin</button>
        </form>
    </div>
</body>
</html>