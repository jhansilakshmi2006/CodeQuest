<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Student Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="index.html" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <a href="register.jsp">Student Register</a>
            <a href="admin-login.jsp">Admin Login</a>
        </nav>
    </header>

    <div class="container">
        <h2>Student Login</h2>

        <%-- Check if the user was just redirected after successful registration --%>
        <%
            String registered = request.getParameter("registered");
            if ("true".equals(registered)) {
        %>
            <div class="alert alert-success">Registration successful! Please log in.</div>
        <%
            }
        %>

        <%-- Display authentication failure messages --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <%
            }
        %>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="identifier">Username or Email</label>
                <input type="text" id="identifier" name="identifier" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn">Login</button>
        </form>

        <p style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            Don't have an account? <a href="register.jsp" style="color: #00e5ff;">Register here</a>
        </p>
    </div>
</body>
</html>