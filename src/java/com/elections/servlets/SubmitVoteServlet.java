/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/**
 *
 * @author abgmn
 */
package com.elections.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SubmitVoteServlet", urlPatterns = {"/SubmitVoteServlet"})
public class SubmitVoteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String cID = request.getParameter("candidate_id");
        String sID = request.getParameter("student_id");
        
        try {
            Connection con = DBConnection.getConnection();
            String sql = "INSERT INTO votes (candidate_id, student_id) VALUES (?, ?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, cID);
            pst.setString(2, sID);
            
            pst.executeUpdate();
            con.close();
            response.sendRedirect("dashboard.jsp?status=voted");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?status=error");
        }
    }
}
