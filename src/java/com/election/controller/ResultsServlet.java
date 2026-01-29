package com.election.controller;

import com.election.model.ElectionResultBean;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/results")
public class ResultsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ElectionResultBean> results = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/StudentElectionDB", "root", "");

            // Fetch elections where election_Status is 'Completed'
            String sql = "SELECT election_ID, election_Title, election_StartDate, election_EndDate FROM election WHERE election_Status='Completed'";
            ResultSet rsElec = conn.createStatement().executeQuery(sql);

            while (rsElec.next()) {
                int eID = rsElec.getInt("election_ID");
                ElectionResultBean bean = new ElectionResultBean();
                bean.setElection_Title(rsElec.getString("election_Title"));
                bean.setVotingPeriod(rsElec.getString("election_StartDate") + " - " + rsElec.getString("election_EndDate"));

                // Fetch winners for each position using the helper method
                bean.setPresident(getWinner(conn, eID, "PRESIDENT"));
                bean.setVicePresident(getWinner(conn, eID, "VICE PRESIDENT"));
                bean.setSecretary(getWinner(conn, eID, "SECRETARY"));
                bean.setTreasurer(getWinner(conn, eID, "TREASURER"));

                results.add(bean);
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        request.setAttribute("resultsList", results);
        request.getRequestDispatcher("results.jsp").forward(request, response);
    }

    private String getWinner(Connection conn, int eID, String posName) throws SQLException {
        // Query to find the student name with the most votes for a specific position
        String sql = "SELECT s.stu_Name FROM electionresult er " +
                     "JOIN candidate c ON er.cand_ID = c.cand_ID " +
                     "JOIN student s ON c.stud_ID = s.stud_ID " +
                     "JOIN position p ON er.position_ID = p.position_ID " +
                     "WHERE er.election_ID = ? AND p.position_Name = ? " +
                     "ORDER BY er.totalVotes DESC LIMIT 1";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, eID);
        ps.setString(2, posName);
        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getString("stu_Name") : "N/A";
    }
}