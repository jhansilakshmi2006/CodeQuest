<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Boolean isCorrect = (Boolean) request.getAttribute("isCorrect");
    Integer xpEarned = (Integer) request.getAttribute("xpEarned");
    String missionTitle = (String) request.getAttribute("missionTitle");
    String selectedAnswer = (String) request.getAttribute("selectedAnswer");
    String correctAnswer = (String) request.getAttribute("correctAnswer");

    if (isCorrect == null) isCorrect = false;
    if (xpEarned == null) xpEarned = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Mission Result</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="DashboardServlet" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <a href="DashboardServlet">Dashboard</a>
            <a href="MissionServlet">Missions</a>
            <a href="leaderboard.jsp">Leaderboard</a>
            <a href="LogoutServlet">Logout</a>
        </nav>
    </header>

    <div class="container" style="text-align: center; max-width: 650px;">
        <h2>Mission Evaluation</h2>
        <h3 style="color: #94a3b8; margin-bottom: 25px;"><%= missionTitle %></h3>

        <% if (isCorrect) { %>
            <div class="alert alert-success" style="font-size: 1.2rem; padding: 20px;">
                🎉 Excellent! Your answer is Correct!
                <br><br>
                <strong>+<%= xpEarned %> XP</strong> added to your profile!
            </div>
        <% } else { %>
            <div class="alert alert-error" style="font-size: 1.1rem; padding: 20px;">
                ❌ Incorrect Answer!
                <br><br>
                <span style="font-size: 0.95rem; color: #cbd5e1;">
                    Your Answer: <strong><%= selectedAnswer %></strong><br>
                    Correct Answer: <strong><%= correctAnswer %></strong>
                </span>
            </div>
        <% } %>

        <div style="display: flex; gap: 15px; margin-top: 30px;">
            <a href="MissionServlet" class="btn" style="flex: 1; text-decoration: none;">Next Mission</a>
            <a href="DashboardServlet" class="btn" style="flex: 1; text-decoration: none; background: #3b82f6; color: white;">View Dashboard</a>
        </div>
    </div>
</body>
</html>