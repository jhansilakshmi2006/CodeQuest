package com.codequest.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // MySQL connection parameters
    // If your MySQL uses another port (e.g. 3307), replace 3306 with your port number
    private static final String URL = "jdbc:mysql://localhost:3306/codequest_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "MYSQL_PASSWORD"; // Replace with your MySQL password

    // Static block to load the driver class once when the class is loaded
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found. Ensure mysql-connector-j-26.7.0.jar is in WEB-INF/lib.");
            e.printStackTrace();
        }
    }

    // Method to return a live database connection
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Optional: Run this directly to test connectivity before using with Servlets
    public static void main(String[] args) {
        try (Connection con = DBConnection.getConnection()) {
            if (con != null && !con.isClosed()) {
                System.out.println("Database connection established successfully!");
            }
        } catch (SQLException e) {
            System.err.println("Failed to connect to MySQL database.");
            e.printStackTrace();
        }
    }
}