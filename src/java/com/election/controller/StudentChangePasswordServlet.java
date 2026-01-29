/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.election.controller;

import com.mvc.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet for handling Student Password Change.
 */
@WebServlet("/StudentChangePasswordServlet")
public class StudentChangePasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userSession = (String) session.getAttribute("userSession");
        
        if (userSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Inputs
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");
        String confirmPass = request.getParameter("confirmPass");

        // 1. Validation: New passwords match?
        if (newPass == null || !newPass.equals(confirmPass)) {
            response.sendRedirect("studentChangePassword.jsp?msg=New passwords do not match!");
            return;
        }

        try {
            Connection con = DBConnection.createConnection();

            // 2. Validation: Check if Old Password is correct for this student
            // assuming userSession is stu_Username
            String sqlCheck = "SELECT stu_Password FROM student WHERE stu_Username = ?";
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setString(1, userSession);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                String dbPass = rs.getString("stu_Password");

                if (dbPass != null && dbPass.equals(oldPass)) {
                    // SUCCESS: Old password is correct. Update to new password.
                    String sqlUpdate = "UPDATE student SET stu_Password = ? WHERE stu_Username = ?";
                    PreparedStatement psUp = con.prepareStatement(sqlUpdate);
                    psUp.setString(1, newPass);
                    psUp.setString(2, userSession);

                    int i = psUp.executeUpdate();
                    
                    psUp.close();

                    if (i > 0) {
                        // Redirect to profile with success status
                        response.sendRedirect("studentProfile.jsp?status=password_changed");
                    } else {
                        response.sendRedirect("studentChangePassword.jsp?msg=Update failed. Please try again.");
                    }
                } else {
                    // FAIL: Old password is wrong
                    response.sendRedirect("studentChangePassword.jsp?msg=Incorrect current password!");
                }
            } else {
                // User not found (shouldn't happen if logged in, but good to handle)
                response.sendRedirect("login.jsp");
            }
            
            rs.close();
            psCheck.close();
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentChangePassword.jsp?msg=Error: " + e.getMessage());
        }
    }
}
