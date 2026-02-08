/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

/**
 *
 * @author user
 */
import com.mvc.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AdminCandidateDeleteServlet")
public class AdminCandidateDeleteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String cid = request.getParameter("cid"); // Candidate ID
        String eid = request.getParameter("eid"); // Election ID (to redirect back)

        try {
            Connection con = DBConnection.createConnection();
            String sql = "DELETE FROM candidate WHERE cand_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, cid);
            ps.executeUpdate();
            con.close();
            
            // Redirect back to the list
            response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=deleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=error");
        }
    }
}