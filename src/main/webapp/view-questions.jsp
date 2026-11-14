<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.codequest.model.Mission" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    List<Mission> missionList = (List<Mission>) request.getAttribute("missionList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - View Missions</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #2a2e45; }
        th { background: #1a1d2e; color: #00e5ff; }
        tr:hover { background: #1a1d2e; }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="admin-dashboard.jsp" class="logo">CodeQuest Admin</a>
        <nav class="nav-links">
            <a href="admin-dashboard.jsp">Dashboard</a>
            <a href="add-question.jsp">Add Mission</a>
            <a href="AdminLogoutServlet">Logout</a>
        </nav>
    </header>

    <div class="container" style="max-width: 900px;">
        <h2>All Active Missions</h2>

        <% if (missionList == null || missionList.isEmpty()) { %>
            <p style="text-align: center; color: #94a3b8; margin: 30px 0;">No missions found. Click "Add Mission" to create your first question.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Difficulty</th>
                        <th>XP Reward</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Mission m : missionList) { %>
                        <tr>
                            <td><%= m.getId() %></td>
                            <td><%= m.getTitle() %></td>
                            <td><%= m.getCategory() %></td>
                            <td><%= m.getDifficulty() %></td>
                            <td><%= m.getXpReward() %> XP</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>