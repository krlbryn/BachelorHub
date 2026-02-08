/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ParaNon
 */
package com.mvc.controller;

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

/**
 * Servlet to finalize election results by moving data to the electionresult table.
 * Prevents duplicate generation if results already exist.
 */
@WebServlet("/FinalizeResultServlet")
public class FinalizeResultServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String electionIdStr = request.getParameter("electionId");
        
        if (electionIdStr == null || electionIdStr.isEmpty()) {
            response.sendRedirect("adminResult.jsp?error=invalidId");
            return;
        }

        int electionId = Integer.parseInt(electionIdStr);
        Connection con = null;

        try {
            con = DBConnection.createConnection();

            // 1. Double-Check: Do results already exist for this election?
            String checkSQL = "SELECT COUNT(*) FROM electionresult WHERE election_ID = ?";
            PreparedStatement pstCheck = con.prepareStatement(checkSQL);
            pstCheck.setInt(1, electionId);
            ResultSet rsCheck = pstCheck.executeQuery();

            if (rsCheck.next() && rsCheck.getInt(1) > 0) {
                // If data exists, redirect back with the 'already_generated' status
                response.sendRedirect("adminResult.jsp?electionId=" + electionId + "&status=already_generated");
                return;
            }

            // 2. Generate and Insert Final Results
            // This query aggregates live votes and inserts them into the summary table.
            String insertSQL = "INSERT INTO electionresult (election_ID, position_ID, cand_ID, totalVotes) " +
                               "SELECT c.election_ID, p.position_ID, c.cand_ID, COUNT(v.vote_ID) " +
                               "FROM candidate c " +
                               "JOIN position p ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) " +
                               "LEFT JOIN vote v ON c.cand_ID = v.cand_ID " +
                               "WHERE c.election_ID = ? " +
                               "GROUP BY c.cand_ID, p.position_ID";

            PreparedStatement pstInsert = con.prepareStatement(insertSQL);
            pstInsert.setInt(1, electionId);
            
            int rowsAffected = pstInsert.executeUpdate();

            if (rowsAffected > 0) {
                // Success: Redirect with finalized status
                response.sendRedirect("adminResult.jsp?electionId=" + electionId + "&status=finalized");
            } else {
                // No candidates found for this election
                response.sendRedirect("adminResult.jsp?electionId=" + electionId + "&error=nocandidates");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminResult.jsp?electionId=" + electionId + "&error=server_error");
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}