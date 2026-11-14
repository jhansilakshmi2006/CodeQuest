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
import java.util.List;

@WebServlet("/ViewQuestionsServlet")
public class ViewQuestionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        List<Mission> missionList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, title, category, difficulty, xp_reward FROM missions ORDER BY id DESC";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Mission m = new Mission();
                    m.setId(rs.getInt("id"));
                    m.setTitle(rs.getString("title"));
                    m.setCategory(rs.getString("category"));
                    m.setDifficulty(rs.getString("difficulty"));
                    m.setXpReward(rs.getInt("xp_reward"));
                    missionList.add(m);
                }
            }
            request.setAttribute("missionList", missionList);
            request.getRequestDispatcher("view-questions.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp");
        }
    }
}