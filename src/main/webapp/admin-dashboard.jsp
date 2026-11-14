<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Ensure only logged-in admins can access this page
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    String adminUsername = (String) session.getAttribute("adminUsername");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Admin Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="admin-dashboard.jsp" class="logo">CodeQuest Admin</a>
        <nav class="nav-links">
            <a href="admin-dashboard.jsp">Dashboard</a>
            <a href="add-question.jsp">Add Mission</a>
            <a href="ViewQuestionsServlet">View Missions</a>
            <a href="AdminLogoutServlet">Logout (<%= adminUsername %>)</a>
        </nav>
    </header>

    <div class="container" style="text-align: center;">
        <h2>Welcome, Administrator <%= adminUsername %>!</h2>
        <p style="color: #94a3b8; margin-bottom: 30px;">Manage quiz questions and programming challenges for students.</p>

        <div style="display: flex; gap: 20px; justify-content: center;">
            <a href="add-question.jsp" class="btn" style="text-decoration: none;">+ Add New Mission</a>
            <a href="ViewQuestionsServlet" class="btn" style="text-decoration: none; background-color: #3b82f6; color: white;">Manage Missions</a>
        </div>
    </div>
</body>
</html>