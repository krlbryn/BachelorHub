<%-- 
    Document   : adminPasswordAction
    Created on : 29 Jan 2026, 10:17:11 am
    Author     : ParaNon
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");

    // Inputs from form
    String oldPass = request.getParameter("oldPass");
    String newPass = request.getParameter("newPass");
    String confirmPass = request.getParameter("confirmPass");

    // validation 1: New passwords match?
    if (!newPass.equals(confirmPass)) {
        response.sendRedirect("adminChangePassword.jsp?msg=New passwords do not match!");
        return;
    }

    try {
        Connection con = DBConnection.createConnection();

        // Validation 2: Check if Old Password is correct
        // We select the password for the currently logged-in user
        String sqlCheck = "SELECT admin_Password FROM admin WHERE admin_username = ?";
        PreparedStatement psCheck = con.prepareStatement(sqlCheck);
        psCheck.setString(1, userSession);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            String dbPass = rs.getString("admin_Password");

            if (dbPass.equals(oldPass)) {
                // SUCCESS: Old password is correct. Now we update.
                String sqlUpdate = "UPDATE admin SET admin_Password = ? WHERE admin_username = ?";
                PreparedStatement psUp = con.prepareStatement(sqlUpdate);
                psUp.setString(1, newPass);
                psUp.setString(2, userSession);

                int i = psUp.executeUpdate();

                if (i > 0) {
                    // Update successful -> Logout user or go to profile
                    // Usually safer to logout, but for now let's go to profile
                    // We add ?status=password_changed
                    response.sendRedirect("adminProfile.jsp?status=password_changed");
                }
            } else {
                // FAIL: Old password is wrong
                response.sendRedirect("adminChangePassword.jsp?msg=Incorrect current password!");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>