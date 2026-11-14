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

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT u.total_xp, u.player_level, COUNT(s.id) AS solved_count " +
                         "FROM users u " +
                         "LEFT JOIN mission_submissions s ON u.id = s.user_id AND s.is_correct = TRUE " +
                         "WHERE u.id = ? " +
                         "GROUP BY u.id, u.total_xp, u.player_level";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("totalXp", rs.getInt("total_xp"));
                        request.setAttribute("playerLevel", rs.getInt("player_level"));
                        request.setAttribute("completedCount", rs.getInt("solved_count"));
                    }
                }
            }
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp");
        }
    }
}