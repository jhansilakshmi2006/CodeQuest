<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Add Question</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header class="navbar">
        <a href="admin-dashboard.jsp" class="logo">CodeQuest Admin</a>
        <nav class="nav-links">
            <a href="admin-dashboard.jsp">Dashboard</a>
            <a href="ViewQuestionsServlet">View Missions</a>
            <a href="AdminLogoutServlet">Logout</a>
        </nav>
    </header>

    <div class="container" style="max-width: 700px;">
        <h2>Create New Programming Mission</h2>

        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) { 
        %>
            <div class="alert alert-success"><%= message %></div>
        <% } %>

        <form action="AddQuestionServlet" method="post">
            <div class="form-group">
                <label>Question Title</label>
                <input type="text" name="title" required placeholder="e.g., Array Declaration in Java">
            </div>

            <div class="form-group">
                <label>Question Description / Code Snippet</label>
                <textarea name="description" rows="4" required placeholder="What is the output of int[] arr = new int[5]; System.out.println(arr[0]); ?"></textarea>
            </div>

            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Category</label>
                    <select name="category" required>
                        <option value="Java">Java</option>
                        <option value="SQL">SQL</option>
                        <option value="DSA">DSA</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Difficulty</label>
                    <select name="difficulty" required>
                        <option value="Easy">Easy</option>
                        <option value="Medium">Medium</option>
                        <option value="Hard">Hard</option>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>XP Reward</label>
                    <input type="number" name="xpReward" value="50" required>
                </div>
            </div>

            <div class="form-group">
                <label>Option A</label>
                <input type="text" name="optionA" required>
            </div>
            <div class="form-group">
                <label>Option B</label>
                <input type="text" name="optionB" required>
            </div>
            <div class="form-group">
                <label>Option C</label>
                <input type="text" name="optionC" required>
            </div>
            <div class="form-group">
                <label>Option D</label>
                <input type="text" name="optionD" required>
            </div>

            <div class="form-group">
                <label>Correct Answer (Exact text matching one of the options)</label>
                <input type="text" name="correctAnswer" required placeholder="Must match the right option above">
            </div>

            <button type="submit" class="btn">Save Mission</button>
        </form>
    </div>
</body>
</html>