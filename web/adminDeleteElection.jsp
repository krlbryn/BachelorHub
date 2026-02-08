<%-- 
    Document   : adminDeleteElection
    Created on : Jan 29, 2026, 10:45:12?PM
    Author     : user
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("eid"); // Get ID from URL

    if(id != null) {
        try {
            Connection con = DBConnection.createConnection();
            String sql = "DELETE FROM election WHERE election_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            
            int i = ps.executeUpdate();
            if(i > 0) {
                response.sendRedirect("adminElection.jsp?msg=deleted");
            } else {
                response.sendRedirect("adminElection.jsp?msg=error");
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
%>
