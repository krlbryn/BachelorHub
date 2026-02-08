<%-- 
    Document   : adminUpdateAction
    Created on : 29 Jan 2026, 9:55:31 am
    Author     : ParaNon
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Retrieve the data sent from the form
    String id = request.getParameter("admin_id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String image = request.getParameter("image");

    try {
        // 2. Connect to the Database
        Connection con = DBConnection.createConnection();

        // 3. Prepare the UPDATE SQL statement
        // We update everything matching the admin_ID
        String sql = "UPDATE admin SET admin_Name=?, admin_Email=?, admin_Phone=?, admin_Address=?, admin_Image=? WHERE admin_ID=?";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, phone);
        ps.setString(4, address);
        ps.setString(5, image);
        ps.setString(6, id); // This is the WHERE clause

        // 4. Execute the update
        int i = ps.executeUpdate();

        if (i > 0) {
            // Success! Go back to the profile page to see the changes.
            // We add ?success=1 to tell the next page "It worked!"
            response.sendRedirect("adminProfile.jsp?status=updated");
        } else {
            // Failure
            out.println("<h3>Failed to update data. Please try again.</h3>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>