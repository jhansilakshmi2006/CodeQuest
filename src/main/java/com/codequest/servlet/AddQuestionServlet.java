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
import java.sql.SQLException;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        int adminId = (int) session.getAttribute("adminId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctAnswer = request.getParameter("correctAnswer");
        int xpReward = Integer.parseInt(request.getParameter("xpReward"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO missions (title, description, category, difficulty, option_a, option_b, option_c, option_d, correct_answer, xp_reward, created_by) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, title);
                stmt.setString(2, description);
                stmt.setString(3, category);
                stmt.setString(4, difficulty);
                stmt.setString(5, optionA);
                stmt.setString(6, optionB);
                stmt.setString(7, optionC);
                stmt.setString(8, optionD);
                stmt.setString(9, correctAnswer);
                stmt.setInt(10, xpReward);
                stmt.setInt(11, adminId);
                stmt.executeUpdate();
            }
            
            request.setAttribute("message", "Mission added successfully!");
            request.getRequestDispatcher("add-question.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp");
        }
    }
}