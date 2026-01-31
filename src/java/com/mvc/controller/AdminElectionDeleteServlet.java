/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

/**
 *
 * @author Karl
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminElectionDeleteServlet")
public class AdminElectionDeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check: Ensure Admin is logged in
        HttpSession session = request.getSession();
        String userSession = (String) session.getAttribute("userSession");
        
        if (userSession == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Get Election ID to delete
        String eid = request.getParameter("eid");

        if (eid != null && !eid.isEmpty()) {
            Connection con = null;
            try {
                con = DBConnection.createConnection();
                
                // === CLEANUP: Delete related data first to prevent DB errors ===
                
                // A. Delete Votes linked to this election
                PreparedStatement ps1 = con.prepareStatement("DELETE FROM vote WHERE election_ID = ?");
                ps1.setString(1, eid);
                ps1.executeUpdate();
                
                // B. Delete Election Results linked to this election
                PreparedStatement ps2 = con.prepareStatement("DELETE FROM electionresult WHERE election_ID = ?");
                ps2.setString(1, eid);
                ps2.executeUpdate();

                // C. Delete Candidates linked to this election
                PreparedStatement ps3 = con.prepareStatement("DELETE FROM candidate WHERE election_ID = ?");
                ps3.setString(1, eid);
                ps3.executeUpdate();

                // D. Delete Positions linked to this election (if any exist)
                PreparedStatement ps4 = con.prepareStatement("DELETE FROM position WHERE election_ID = ?");
                ps4.setString(1, eid);
                ps4.executeUpdate();

                // === FINAL STEP: Delete the Election itself ===
                String sql = "DELETE FROM election WHERE election_ID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, eid);
                
                int i = ps.executeUpdate();
                
                if (i > 0) {
                    response.sendRedirect("adminElection.jsp?msg=deleted");
                } else {
                    response.sendRedirect("adminElection.jsp?msg=error");
                }

            } catch (Exception e) {
                e.printStackTrace();
                // Redirect with a specific error so you know it was a DB constraint issue
                response.sendRedirect("adminElection.jsp?msg=constraint");
            } finally {
                // Always close the connection
                if (con != null) {
                    try { con.close(); } catch (Exception e) { e.printStackTrace(); }
                }
            }
        } else {
            response.sendRedirect("adminElection.jsp?msg=error");
        }
    }
}