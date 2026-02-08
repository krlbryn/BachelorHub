<%-- 
    Document   : adminProfile
    Created on : 29 Jan 2026, 8:24:35 am
    Author     : ParaNon
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Security Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Default Variables
    String name = "Loading...";
    String email = "Loading...";
    String id = "Loading...";
    String phone = "Not Set";
    String address = "Not Set";
    String profileImage = null; // New variable for image

    // 3. Fetch Data from Database
    try {
        Connection con = DBConnection.createConnection();
        String sql = "SELECT * FROM admin WHERE admin_username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("admin_Name");
            email = rs.getString("admin_Email");
            id = rs.getString("admin_ID");

            // Handle optional columns
            String dbPhone = rs.getString("admin_Phone");
            String dbAddress = rs.getString("admin_Address");
            String dbImage = rs.getString("admin_Image"); // Fetch image column

            if (dbPhone != null && !dbPhone.isEmpty()) {
                phone = dbPhone;
            }
            if (dbAddress != null && !dbAddress.isEmpty()) {
                address = dbAddress;
            }
            if (dbImage != null && !dbImage.isEmpty()) {
                profileImage = dbImage;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Profile</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
        <style>
            /* Add this for the green success box */
            .success-msg {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 5px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-weight: 500;
            }
        </style>
    </head>
    <body>

        <jsp:include page="adminNav.jsp" />

        <main class="main-content">
            <h1 class="header-title">My Profile</h1>
            <p class="header-subtitle">Manage your account settings</p>

            <div class="profile-container">
                <div class="decoration-line"></div>
                <%
                    String status = request.getParameter("status");
                    if (status != null) {
                %>
                <div class="success-msg">
                    <i class="fa-solid fa-circle-check"></i>
                    <%
                        if (status.equals("updated")) {
                            out.print("Profile details updated successfully!");
                        } else if (status.equals("password_changed")) {
                            out.print("Password changed successfully!");
                        }
                    %>
                </div>
                <% } %>

                <div class="profile-header">
                    <%-- Updated Container with dynamic context pathing --%>
                    <div class="profile-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center; background: #f0f2f5; border: 3px solid #fff; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border-radius: 50%;">
                        <%
                            // Check if the image from DB is valid and not the placeholder string
                            if (profileImage != null && !profileImage.trim().isEmpty() && !profileImage.equals("default.png")) {
                        %>
                        <%-- Standardized path approach to detect files in the images folder --%>
                        <img src="${pageContext.request.contextPath}/images/<%= profileImage%>" 
                             alt="Admin Profile" 
                             class="profile-avatar-img"
                             style="width: 100%; height: 100%; object-fit: cover;">
                        <% } else { %>
                        <%-- Fallback icon if no custom image is found in DB --%>
                        <i class="fa-solid fa-user" style="font-size: 3.5rem; color: #adb5bd;"></i>
                        <% }%>
                    </div>

                    <div class="profile-title">
                        <h2><%= name%></h2>
                        <p>Admin ID : <%= id%></p>
                        <span class="status-badge">Status : Active</span>
                    </div>
                </div>

                <div class="divider"></div>

                <div class="info-section">
                    <h3 class="section-title">Account Information :</h3>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="label">Username :</span>
                            <span class="value"><%= userSession%></span>
                        </div>
                        <div class="info-row">
                            <span class="label">Phone Number :</span>
                            <span class="value"><%= phone%></span>
                        </div>
                        <div class="info-row">
                            <span class="label">Email :</span>
                            <span class="value"><%= email%></span>
                        </div>
                        <div class="info-row">
                            <span class="label">Address :</span>
                            <span class="value"><%= address%></span>
                        </div>
                    </div>
                </div>

                <div class="divider"></div>

                <div class="info-section">
                    <h3 class="section-title">Account Setting :</h3>
                    <a href="adminUpdateProfile.jsp" class="action-link">
                        <span class="link-text">Update profile</span>
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                    <a href="adminChangePassword.jsp" class="action-link">
                        <span class="link-text">Change Password</span>
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>

            </div>
        </main>

    </body>
</html>