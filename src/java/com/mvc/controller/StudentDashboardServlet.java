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

        // 2. Fetch Data from Database
        ElectionDao electionDao = new ElectionDao();
        List<ElectionBean> allElections = electionDao.getAllElections();
        
        // 3. Separate Elections into Lists
        List<ElectionBean> activeList = new ArrayList<>();
        List<ElectionBean> endedList = new ArrayList<>();
        int upcomingCount = 0;

        for (ElectionBean e : allElections) {
            // Check status (Case insensitive)
            String status = e.getElectionStatus();
            if (status != null) {
                if (status.equalsIgnoreCase("Active") || status.equalsIgnoreCase("Ongoing")) {
                    activeList.add(e);
                } else if (status.equalsIgnoreCase("Ended") || status.equalsIgnoreCase("Closed")) {
                    endedList.add(e);
                } else if (status.equalsIgnoreCase("Upcoming")) {
                    upcomingCount++;
                }
            }
        }

        // 4. Create Stats Map for the widgets
        Map<String, Integer> stats = new HashMap<>();
        stats.put("activeCount", activeList.size());
        stats.put("endedCount", endedList.size());
        stats.put("upcomingCount", upcomingCount);

        // 5. Send Data to JSP
        request.setAttribute("activeList", activeList);
        request.setAttribute("endedList", endedList);
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