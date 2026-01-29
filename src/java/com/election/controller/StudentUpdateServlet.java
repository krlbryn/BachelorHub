/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.election.controller;

import com.mvc.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet for updating Student Profile.
 * Adapted from AdminUpdateServlet but simplified (no image upload).
 */
@WebServlet("/StudentUpdateServlet")
public class StudentUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // A. Get Text Data
        String idStr = request.getParameter("stud_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String program = request.getParameter("program");
        String yearStr = request.getParameter("year");

        // Validate Inputs
        int id = 0;
        int year = 1;
        try {
            id = Integer.parseInt(idStr);
            year = Integer.parseInt(yearStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("studentUpdateProfile.jsp?msg=Invalid ID or Year");
            return;
        }

        // B. Update Database
        try {
            Connection con = DBConnection.createConnection();
            String sql = "UPDATE student SET stu_Name=?, stu_Email=?, stu_Program=?, stu_Year=? WHERE stud_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, program);
            ps.setInt(4, year);
            ps.setInt(5, id);

            int i = ps.executeUpdate();
            
            ps.close();
            con.close();

            if (i > 0) {
                // Success
                response.sendRedirect("studentProfile.jsp?status=updated");
            } else {
                // Failure
                response.sendRedirect("studentUpdateProfile.jsp?msg=Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentUpdateProfile.jsp?msg=Error: " + e.getMessage());
        }
    }
}
