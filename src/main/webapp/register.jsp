<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Register</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="index.html" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <a href="login.jsp">Student Login</a>
            <a href="admin-login.jsp">Admin Login</a>
        </nav>
    </header>

    <div class="container">
        <h2>Student Registration</h2>

        <%-- Display validation or failure messages using scriptlets --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div class="alert alert-error"><%= errorMessage %></div>
        <%
            }
        %>

        <form action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <p style="text-align: center; margin-top: 20px; font-size: 0.9rem;">
            Already registered? <a href="login.jsp" style="color: #00e5ff;">Log in here</a>
        </p>
    </div>
</body>
</html>