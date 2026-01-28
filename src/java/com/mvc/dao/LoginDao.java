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

    public String authenticateUser(LoginBean loginBean) {
        String usernameEntered = loginBean.getUsername(); // This gets the input from the login box
        String passwordEntered = loginBean.getPassword();

        Connection con = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;

        String usernameDB = "";
        String passwordDB = "";

        // ==========================================
        //  UPDATED QUERY: Check 'admin_username'
        // ==========================================
        String sqlQuery = "SELECT admin_username, admin_Password FROM admin WHERE admin_username = ? AND admin_Password = ?";

        try {
            con = DBConnection.createConnection();
            preparedStatement = con.prepareStatement(sqlQuery);

            // 1. Fill in the ? with the data from the login page
            preparedStatement.setString(1, usernameEntered);
            preparedStatement.setString(2, passwordEntered);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                // Get the data from the database column
                usernameDB = resultSet.getString("admin_username");
                passwordDB = resultSet.getString("admin_Password");

                if (usernameEntered.equals(usernameDB) && passwordEntered.equals(passwordDB)) {
                    return "SUCCESS";
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "Invalid user credentials";
    }
}
