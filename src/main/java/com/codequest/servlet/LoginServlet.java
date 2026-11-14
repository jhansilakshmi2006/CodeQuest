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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String identifier = request.getParameter("identifier");
        String password = request.getParameter("password");

        if (identifier == null || identifier.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please provide both identifier and password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check username or email matching the password
            String sql = "SELECT id, username FROM users WHERE (username = ? OR email = ?) AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, identifier.trim());
                stmt.setString(2, identifier.trim());
                stmt.setString(3, password);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Create and populate session
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", rs.getInt("id"));
                        session.setAttribute("username", rs.getString("username"));

                        // Redirect to the student dashboard servlet
                        response.sendRedirect("DashboardServlet");
                    } else {
                        request.setAttribute("errorMessage", "Invalid username/email or password.");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred during login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}