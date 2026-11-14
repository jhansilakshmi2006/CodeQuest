package com.codequest.servlet;

import com.codequest.model.Mission;
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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/MissionServlet")
public class MissionServlet extends HttpServlet {
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
        List<Mission> missions = new ArrayList<>();
        Set<Integer> submittedMissionIds = new HashSet<>();

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Fetch mission IDs already attempted by this student
            String subSql = "SELECT mission_id FROM mission_submissions WHERE user_id = ?";
            try (PreparedStatement subStmt = conn.prepareStatement(subSql)) {
                subStmt.setInt(1, userId);
                try (ResultSet subRs = subStmt.executeQuery()) {
                    while (subRs.next()) {
                        submittedMissionIds.add(subRs.getInt("mission_id"));
                    }
                }
            }

            // 2. Fetch all missions from the database (excluding correct_answer)
            String sql = "SELECT id, title, description, category, difficulty, option_a, option_b, option_c, option_d, xp_reward FROM missions ORDER BY id ASC";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Mission m = new Mission();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setDescription(rs.getString("description"));
                    m.setCategory(rs.getString("category"));
                    m.setDifficulty(rs.getString("difficulty"));
                    m.setOptionA(rs.getString("option_a"));
                    m.setOptionB(rs.getString("option_b"));
                    m.setOptionC(rs.getString("option_c"));
                    m.setOptionD(rs.getString("option_d"));
                    m.setXpReward(rs.getInt("xp_reward"));
                    missions.add(m);
                }
            }

            request.setAttribute("missions", missions);
            request.setAttribute("submittedMissionIds", submittedMissionIds);
            request.getRequestDispatcher("missions.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DashboardServlet");
        }
    }
}