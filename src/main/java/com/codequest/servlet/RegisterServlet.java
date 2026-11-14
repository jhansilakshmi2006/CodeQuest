package com.codequest.servlet;

import com.codequest.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Validate mandatory fields and password match
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 2. Database validation and insertion
        try (Connection conn = DBConnection.getConnection()) {
            
            // Check uniqueness of username and email
            String checkSql = "SELECT id FROM users WHERE username = ? OR email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username.trim());
                checkStmt.setString(2, email.trim());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("errorMessage", "Username or email is already registered.");
                        request.getRequestDispatcher("register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Insert new student with starting XP = 0 and Level = 1
            String insertSql = "INSERT INTO users (username, email, password, total_xp, player_level) VALUES (?, ?, ?, 0, 1)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, username.trim());
                insertStmt.setString(2, email.trim());
                insertStmt.setString(3, password);
                insertStmt.executeUpdate();
            }

            // Redirect to login page upon success
            response.sendRedirect("login.jsp?registered=true");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred during registration.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}