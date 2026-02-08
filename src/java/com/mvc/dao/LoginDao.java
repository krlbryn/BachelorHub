/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author ParaNon
 */
package com.mvc.dao;

import com.mvc.bean.LoginBean;
import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import java.sql.SQLException;

public class LoginDao {

    public String authenticateUser(LoginBean loginBean, String role) {
        String usernameEntered = loginBean.getUsername();
        String passwordEntered = loginBean.getPassword();

        Connection con = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        try {
            con = DBConnection.createConnection();
            String sqlQuery = "";

            // === CHOOSE TABLE BASED ON ROLE ===
            if (role.equals("admin")) {
                // Admin Check
                sqlQuery = "SELECT admin_username, admin_Password FROM admin WHERE admin_username = ? AND admin_Password = ?";
            } else {
                // === UPDATED STUDENT CHECK (Using stu_Username) ===
                sqlQuery = "SELECT stu_Username, stu_Password FROM student WHERE stu_Username = ? AND stu_Password = ?";
            }

            preparedStatement = con.prepareStatement(sqlQuery);
            preparedStatement.setString(1, usernameEntered);
            preparedStatement.setString(2, passwordEntered);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Success!
                return "SUCCESS";
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "Invalid credentials";
    }
}
