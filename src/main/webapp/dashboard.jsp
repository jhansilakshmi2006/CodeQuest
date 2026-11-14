<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Protect page from unauthenticated access
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    Integer totalXp = (Integer) request.getAttribute("totalXp");
    Integer playerLevel = (Integer) request.getAttribute("playerLevel");
    Integer completedCount = (Integer) request.getAttribute("completedCount");

    if (totalXp == null) totalXp = 0;
    if (playerLevel == null) playerLevel = 1;
    if (completedCount == null) completedCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="index.html" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <a href="DashboardServlet">Dashboard</a>
            <a href="MissionServlet">Missions</a>
            <a href="leaderboard.jsp">Leaderboard</a>
            <a href="LogoutServlet">Logout (<%= username %>)</a>
        </nav>
    </header>

    <div class="container" style="max-width: 800px;">
        <h2>Player Profile: <%= username %></h2>
        
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin: 30px 0; text-align: center;">
            <div style="background: #0f111a; padding: 20px; border-radius: 8px; border: 1px solid #2a2e45;">
                <p style="color: #a0aec0; font-size: 0.9rem;">Player Level</p>
                <h3 style="color: #00e5ff; font-size: 1.8rem; margin-top: 5px;"><%= playerLevel %></h3>
            </div>
            <div style="background: #0f111a; padding: 20px; border-radius: 8px; border: 1px solid #2a2e45;">
                <p style="color: #a0aec0; font-size: 0.9rem;">Total XP</p>
                <h3 style="color: #00e5ff; font-size: 1.8rem; margin-top: 5px;"><%= totalXp %></h3>
            </div>
            <div style="background: #0f111a; padding: 20px; border-radius: 8px; border: 1px solid #2a2e45;">
                <p style="color: #a0aec0; font-size: 0.9rem;">Missions Solved</p>
                <h3 style="color: #00e5ff; font-size: 1.8rem; margin-top: 5px;"><%= completedCount %></h3>
            </div>
        </div>

        <a href="MissionServlet" class="btn">Start Solving Missions</a>
    </div>
</body>
</html>