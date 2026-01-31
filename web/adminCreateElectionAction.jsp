<%-- 
    Document   : adminCreateElectionAction
    Created on : Jan 29, 2026, 1:36:22 PM
    Author     : user
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 1. Get Parameters
    String name = request.getParameter("eName");
    String date = request.getParameter("eDate");
    String status = request.getParameter("eStatus");

    try {
        // 2. Connect to DB
        Connection con = DBConnection.createConnection();
        
        // 3. Insert Query
        String sql = "INSERT INTO election (election_name, election_date, election_status) VALUES (?, ?, ?)";
        
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, date);
        ps.setString(3, status);
        
        // 4. Execute
        int i = ps.executeUpdate();
        
        if (i > 0) {
            // Success! Go back to the list and show success message
            response.sendRedirect("adminElection.jsp?msg=success");
        } else {
            // Failed
            out.println("<h3>Failed to create election.</h3>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
