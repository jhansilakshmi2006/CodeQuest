<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Set, com.codequest.model.Mission" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
    List<Mission> missions = (List<Mission>) request.getAttribute("missions");
    Set<Integer> submittedMissionIds = (Set<Integer>) request.getAttribute("submittedMissionIds");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Missions</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mission-card {
            background: #161926;
            border: 1px solid #2a2e45;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 25px;
        }
        .mission-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: bold;
            margin-left: 8px;
        }
        .badge-cat { background: #3b82f6; color: white; }
        .badge-diff { background: #f59e0b; color: #1e1e1e; }
        .badge-xp { background: #10b981; color: white; }
        .radio-option {
            display: block;
            margin: 10px 0;
            padding: 10px;
            background: #0f111a;
            border-radius: 6px;
            border: 1px solid #2a2e45;
            cursor: pointer;
        }
        .radio-option:hover {
            border-color: #00e5ff;
        }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="DashboardServlet" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <a href="DashboardServlet">Dashboard</a>
            <a href="MissionServlet">Missions</a>
            <a href="leaderboard.jsp">Leaderboard</a>
            <a href="LogoutServlet">Logout (<%= username %>)</a>
        </nav>
    </header>

    <div class="container" style="max-width: 850px;">
        <h2>Available Missions</h2>
        <p style="text-align: center; color: #94a3b8; margin-bottom: 30px;">
            Solve missions to earn XP and increase your rank on the leaderboard.
        </p>

        <% if (missions == null || missions.isEmpty()) { %>
            <p style="text-align: center; color: #94a3b8;">No missions available right now.</p>
        <% } else {
            for (Mission m : missions) {
                boolean isCompleted = submittedMissionIds != null && submittedMissionIds.contains(m.getId());
        %>
            <div class="mission-card">
                <div class="mission-header">
                    <h3 style="color: #00e5ff;"><%= m.getTitle() %></h3>
                    <div>
                        <span class="badge badge-cat"><%= m.getCategory() %></span>
                        <span class="badge badge-diff"><%= m.getDifficulty() %></span>
                        <span class="badge badge-xp">+<%= m.getXpReward() %> XP</span>
                    </div>
                </div>

                <p style="margin: 15px 0; line-height: 1.5; color: #cbd5e1;"><%= m.getDescription() %></p>

                <% if (isCompleted) { %>
                    <div class="alert alert-success" style="margin-top: 15px;">
                        ✓ You have already submitted an answer for this mission.
                    </div>
                <% } else { %>
                    <form action="SubmitAnswerServlet" method="post">
                        <input type="hidden" name="missionId" value="<%= m.getId() %>">

                        <label class="radio-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionA() %>" required>
                            <%= m.getOptionA() %>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionB() %>" required>
                            <%= m.getOptionB() %>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionC() %>" required>
                            <%= m.getOptionC() %>
                        </label>
                        <label class="radio-option">
                            <input type="radio" name="selectedAnswer" value="<%= m.getOptionD() %>" required>
                            <%= m.getOptionD() %>
                        </label>

                        <button type="submit" class="btn" style="margin-top: 15px;">Submit Answer</button>
                    </form>
                <% } %>
            </div>
        <% 
            }
        } 
        %>
    </div>
</body>
</html>