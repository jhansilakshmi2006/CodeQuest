<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.codequest.util.DBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Global Leaderboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .leaderboard-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        .leaderboard-table th, .leaderboard-table td {
            padding: 14px 18px;
            text-align: left;
            border-bottom: 1px solid #2a2e45;
        }
        .leaderboard-table th {
            background-color: #1a1d2e;
            color: #00e5ff;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .leaderboard-table tr:hover {
            background-color: #1a1d2e;
        }
        .rank-badge {
            font-size: 1.2rem;
            font-weight: bold;
        }
        .rank-1 { color: #ffd700; } /* Gold */
        .rank-2 { color: #c0c0c0; } /* Silver */
        .rank-3 { color: #cd7f32; } /* Bronze */
        .current-user-row {
            background: rgba(0, 229, 255, 0.1) !important;
            border-left: 3px solid #00e5ff;
        }
    </style>
</head>
<body>
    <header class="navbar">
        <a href="index.html" class="logo">CodeQuest</a>
        <nav class="nav-links">
            <%
                String sessionUser = (String) session.getAttribute("username");
                if (sessionUser != null) {
            %>
                <a href="DashboardServlet">Dashboard</a>
                <a href="MissionServlet">Missions</a>
                <a href="leaderboard.jsp" style="color: #00e5ff;">Leaderboard</a>
                <a href="LogoutServlet">Logout (<%= sessionUser %>)</a>
            <%
                } else {
            %>
                <a href="index.html">Home</a>
                <a href="login.jsp">Student Login</a>
                <a href="register.jsp">Register</a>
                <a href="leaderboard.jsp" style="color: #00e5ff;">Leaderboard</a>
            <%
                }
            %>
        </nav>
    </header>

    <div class="container" style="max-width: 900px;">
        <h2>🏆 Global Leaderboard</h2>
        <p style="text-align: center; color: #94a3b8; margin-bottom: 25px;">
            Top coders ranked by total experience points (XP) earned from solved missions.
        </p>

        <%
            boolean hasPlayers = false;
            try (Connection conn = DBConnection.getConnection()) {
                // Fetch ranks sorted by XP descending, and count solved missions
                String sql = "SELECT u.id, u.username, u.player_level, u.total_xp, " +
                             "COUNT(s.id) AS solved_count " +
                             "FROM users u " +
                             "LEFT JOIN mission_submissions s ON u.id = s.user_id AND s.is_correct = TRUE " +
                             "GROUP BY u.id, u.username, u.player_level, u.total_xp " +
                             "ORDER BY u.total_xp DESC, solved_count DESC, u.username ASC";

                try (PreparedStatement stmt = conn.prepareStatement(sql);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    int rank = 1;
                    while (rs.next()) {
                        if (!hasPlayers) {
                            hasPlayers = true;
        %>
            <table class="leaderboard-table">
                <thead>
                    <tr>
                        <th style="width: 80px;">Rank</th>
                        <th>Player</th>
                        <th>Level</th>
                        <th>Missions Solved</th>
                        <th>Total XP</th>
                    </tr>
                </thead>
                <tbody>
        <%
                        }
                        String rowUser = rs.getString("username");
                        int level = rs.getInt("player_level");
                        int totalXp = rs.getInt("total_xp");
                        int solvedCount = rs.getInt("solved_count");
                        boolean isCurrent = sessionUser != null && sessionUser.equalsIgnoreCase(rowUser);
        %>
                    <tr class="<%= isCurrent ? "current-user-row" : "" %>">
                        <td>
                            <% if (rank == 1) { %>
                                <span class="rank-badge rank-1">🥇 #1</span>
                            <% } else if (rank == 2) { %>
                                <span class="rank-badge rank-2">🥈 #2</span>
                            <% } else if (rank == 3) { %>
                                <span class="rank-badge rank-3">🥉 #3</span>
                            <% } else { %>
                                <span style="font-weight: bold; color: #a0aec0;">#<%= rank %></span>
                            <% } %>
                        </td>
                        <td>
                            <strong><%= rowUser %></strong>
                            <% if (isCurrent) { %>
                                <span style="color: #00e5ff; font-size: 0.85rem; margin-left: 6px;">(You)</span>
                            <% } %>
                        </td>
                        <td>Level <%= level %></td>
                        <td><%= solvedCount %></td>
                        <td style="color: #00e5ff; font-weight: bold;"><%= totalXp %> XP</td>
                    </tr>
        <%
                        rank++;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }

            if (hasPlayers) {
        %>
                </tbody>
            </table>
        <%
            } else {
        %>
            <div style="text-align: center; color: #94a3b8; padding: 40px 0;">
                <p style="font-size: 1.1rem;">No players found on the leaderboard yet.</p>
                <p style="margin-top: 10px; font-size: 0.9rem;">Register an account and complete missions to be the first!</p>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>