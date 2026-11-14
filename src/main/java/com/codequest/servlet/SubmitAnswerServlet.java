package com.codequest.servlet;

import com.codequest.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/SubmitAnswerServlet")
public class SubmitAnswerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int missionId = Integer.parseInt(request.getParameter("missionId"));
        String selectedAnswer = request.getParameter("selectedAnswer");

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // 1. Check if user already submitted this mission
            String checkSql = "SELECT id FROM mission_submissions WHERE user_id = ? AND mission_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, missionId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect("MissionServlet");
                        return;
                    }
                }
            }

            // 2. Fetch the correct answer and XP reward
            String correctAns = null;
            int xpReward = 0;
            String missionTitle = "";
            String missionSql = "SELECT title, correct_answer, xp_reward FROM missions WHERE id = ?";
            try (PreparedStatement mStmt = conn.prepareStatement(missionSql)) {
                mStmt.setInt(1, missionId);
                try (ResultSet rs = mStmt.executeQuery()) {
                    if (rs.next()) {
                        missionTitle = rs.getString("title");
                        correctAns = rs.getString("correct_answer");
                        xpReward = rs.getInt("xp_reward");
                    }
                }
            }

            boolean isCorrect = correctAns != null && correctAns.trim().equalsIgnoreCase(selectedAnswer.trim());

            // 3. Begin Database Transaction for updates
            conn.setAutoCommit(false);

            // Record submission
            String insertSubSql = "INSERT INTO mission_submissions (user_id, mission_id, answer, is_correct) VALUES (?, ?, ?, ?)";
            try (PreparedStatement insStmt = conn.prepareStatement(insertSubSql)) {
                insStmt.setInt(1, userId);
                insStmt.setInt(2, missionId);
                insStmt.setString(3, selectedAnswer);
                insStmt.setBoolean(4, isCorrect);
                insStmt.executeUpdate();
            }

            // If correct, update total_xp and player_level
            if (isCorrect) {
                // Formula: Level increases every 100 XP
                String updateXpSql = "UPDATE users SET total_xp = total_xp + ?, player_level = 1 + FLOOR((total_xp + ?) / 100) WHERE id = ?";
                try (PreparedStatement upStmt = conn.prepareStatement(updateXpSql)) {
                    upStmt.setInt(1, xpReward);
                    upStmt.setInt(2, xpReward);
                    upStmt.setInt(3, userId);
                    upStmt.executeUpdate();
                }
            }

            conn.commit(); // Commit transaction

            // 4. Send feedback to result page
            request.setAttribute("isCorrect", isCorrect);
            request.setAttribute("xpEarned", isCorrect ? xpReward : 0);
            request.setAttribute("missionTitle", missionTitle);
            request.setAttribute("selectedAnswer", selectedAnswer);
            request.setAttribute("correctAnswer", correctAns);

            request.getRequestDispatcher("mission-result.jsp").forward(request, response);

        } catch (SQLException e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            response.sendRedirect("MissionServlet");
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}