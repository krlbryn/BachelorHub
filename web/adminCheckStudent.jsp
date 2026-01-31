<%-- 
    Document   : adminCheckStudenet
    Created on : 31 Jan 2026, 7:13:05 pm
    Author     : ParaNon
--%>

<%@page import="java.sql.*, com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String id = request.getParameter("id");

    // Ensure ID is not null or empty
    if (id != null && !id.trim().isEmpty()) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            // Query to find the student name based on ID
            PreparedStatement ps = con.prepareStatement("SELECT stu_Name FROM student WHERE stud_ID = ?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // If found, return "FOUND:" followed by the name
                out.print("FOUND:" + rs.getString("stu_Name"));
            } else {
                // If not found, return specific keyword
                out.print("NOT_FOUND");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.print("ERROR");
        }
    }
%>