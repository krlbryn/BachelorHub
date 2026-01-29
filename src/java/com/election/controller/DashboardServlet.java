package com.election.controller;

import com.election.model.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/dashboard") // Access this via http://localhost:8080/ElectionManagementSystem/dashboard
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("stud_ID"); 
        
        DashboardStats stats = new DashboardStats();
        List<Election> activeElections = new ArrayList<>();
        Set<Integer> votedIds = new HashSet<>();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/StudentElectionDB", "root", "");
            
            // 1. Get Stats for the blue boxes
            ResultSet rsStats = conn.createStatement().executeQuery("SELECT election_Status, COUNT(*) FROM election GROUP BY election_Status");
            while(rsStats.next()){
                String status = rsStats.getString(1);
                if(status.equalsIgnoreCase("Ongoing")) stats.setActiveCount(rsStats.getInt(2));
                else if(status.equalsIgnoreCase("Completed")) stats.setEndedCount(rsStats.getInt(2));
                else if(status.equalsIgnoreCase("Upcoming")) stats.setUpcomingCount(rsStats.getInt(2));
            }

            // 2. Fetch all Elections (Dynamic)
            ResultSet rsList = conn.createStatement().executeQuery("SELECT * FROM election");
            while(rsList.next()) {
                Election e = new Election();
                e.setElection_ID(rsList.getInt("election_ID"));
                e.setElection_Title(rsList.getString("election_Title"));
                e.setElection_Status(rsList.getString("election_Status"));
                e.setStartDate(rsList.getString("election_StartDate"));
                e.setEndDate(rsList.getString("election_EndDate"));
                activeElections.add(e);
            }

            // 3. Check Voted Status
            if (studentId != null) {
                PreparedStatement ps = conn.prepareStatement("SELECT election_ID FROM vote WHERE stud_ID = ?");
                ps.setString(1, studentId);
                ResultSet rsV = ps.executeQuery();
                while(rsV.next()) votedIds.add(rsV.getInt("election_ID"));
            }
            conn.close();
        } catch (Exception e) { e.printStackTrace(); }
        
        request.setAttribute("stats", stats);
        request.setAttribute("activeElections", activeElections);
        request.setAttribute("votedIds", votedIds);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}