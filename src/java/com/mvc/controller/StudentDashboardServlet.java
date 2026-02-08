/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

import com.mvc.bean.ElectionBean;
import com.mvc.dao.ElectionDao;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StudentDashboardServlet", urlPatterns = {"/studentDashboard"})
public class StudentDashboardServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("userSession") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Fetch Data from Database via DAO
        ElectionDao electionDao = new ElectionDao();
        List<ElectionBean> allElections = electionDao.getAllElections();
        
        // 3. Prepare Lists for different election statuses
        List<ElectionBean> activeList = new ArrayList<>();
        List<ElectionBean> endedList = new ArrayList<>();
        List<ElectionBean> upcomingList = new ArrayList<>(); // To store full upcoming election data

        for (ElectionBean e : allElections) {
            String status = e.getElectionStatus();
            if (status != null) {
                // Separate based on status (Case insensitive)
                if (status.equalsIgnoreCase("Active") || status.equalsIgnoreCase("Ongoing")) {
                    activeList.add(e);
                } else if (status.equalsIgnoreCase("Ended") || status.equalsIgnoreCase("Closed")) {
                    endedList.add(e);
                } else if (status.equalsIgnoreCase("Upcoming")) {
                    upcomingList.add(e); // Store the object to display in the list
                }
            }
        }

        // 4. Create Stats Map for the top dashboard widgets
        Map<String, Integer> stats = new HashMap<>();
        stats.put("activeCount", activeList.size());
        stats.put("endedCount", endedList.size());
        stats.put("upcomingCount", upcomingList.size());

        // 5. Set Attributes to be accessed by the JSP
        request.setAttribute("activeList", activeList);
        request.setAttribute("endedList", endedList);
        request.setAttribute("upcomingList", upcomingList); // The JSP can now loop through this
        request.setAttribute("stats", stats);

        // 6. Forward to the JSP (The View)
        request.getRequestDispatcher("studentDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}