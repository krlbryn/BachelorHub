/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.dao;

/**
 *
 * @author ParaNon
 */
import com.mvc.bean.LoginBean;
import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDao {

    public String authenticateUser(LoginBean loginBean, String role) {
        String userInput = loginBean.getUsername(); // This holds Admin Username OR Student ID
        String password = loginBean.getPassword();

        Connection con = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            con = DBConnection.createConnection();
            String sqlQuery = "";

            // === 1. CHOOSE QUERY BASED ON ROLE ===
            if (role.equalsIgnoreCase("admin")) {
                // Admin login uses 'admin_username'
                sqlQuery = "SELECT admin_username, admin_Password FROM admin WHERE admin_username = ? AND admin_Password = ?";
            } else {
                // === UPDATED: Student login uses 'stud_ID' (Student Number) ===
                // We check if the input matches the 'stud_ID' column
                sqlQuery = "SELECT stud_ID, stu_Password FROM student WHERE stud_ID = ? AND stu_Password = ?";
            }

            preparedStatement = con.prepareStatement(sqlQuery);
            preparedStatement.setString(1, userInput);
            preparedStatement.setString(2, password);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return "SUCCESS";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return "Database Error: " + e.getMessage();
        } finally {
            // It is good practice to close resources to prevent memory leaks
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return "Invalid credentials";
    }
}