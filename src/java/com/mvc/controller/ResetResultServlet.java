/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

import com.mvc.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ResetResultServlet")
public class ResetResultServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int electionId = Integer.parseInt(request.getParameter("electionId"));
        
        try (Connection con = DBConnection.createConnection()) {
            // Delete pre-calculated results to allow re-generation
            String sql = "DELETE FROM electionresult WHERE election_ID = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, electionId);
            pst.executeUpdate();
            
            response.sendRedirect("adminResult.jsp?electionId=" + electionId + "&status=reset");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminResult.jsp?error=reset_fail");
        }
    }
}