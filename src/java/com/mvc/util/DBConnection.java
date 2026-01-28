/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ParaNon
 */
package com.mvc.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection createConnection() {
        Connection con = null;
        
        // ============================================
        // UPDATE THESE VALUES TO MATCH YOUR DATABASE
        // ============================================
        String dbName = "StudentElectionDB"; // Change this to your actual database name
        String url = "jdbc:mysql://localhost:3306/StudentElectionDB?zeroDateTimeBehavior=CONVERT_TO_NULL [root on Default schema]";
        String username = "root";           // Default XAMPP/MySQL username
        String password = "";               // Default XAMPP/MySQL password (leave empty if none)

        try {
            // 1. Load the MySQL JDBC Driver
            // Note: For older MySQL versions, use "com.mysql.jdbc.Driver"
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 2. Establish the connection
            con = DriverManager.getConnection(url, username, password);
            
            // Optional: Print specific success message for debugging
            if(con != null) {
                System.out.println("Database connection established successfully!");
            }

        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found. Check your Libraries.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection Failed. Check URL, User, or Password.");
            e.printStackTrace();
        }

        return con;
    }
}