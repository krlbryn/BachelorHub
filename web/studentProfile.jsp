<%-- Document : studentProfile Created on : 29 Jan 2026 Author : Antigravity --%>

<%@page import="java.sql.*" %>
<%@page import="com.mvc.util.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "Loading...";
    String email = "Loading...";
    String id = "Loading...";
    String program = "Not Set";
    String year = "Not Set";
    // 1. New Variable for Image
    String profileImage = "default.png";

    try {
        Connection con = DBConnection.createConnection();
        String sql = "SELECT * FROM student WHERE stu_Username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("stu_Name");
            email = rs.getString("stu_Email");
            id = rs.getString("stud_ID");
            program = rs.getString("stu_Program");
            year = String.valueOf(rs.getInt("stu_Year"));

            // 2. Fetch the image from DB
            String imgDB = rs.getString("stu_Image");
            if (imgDB != null && !imgDB.isEmpty()) {
                profileImage = imgDB;
            }
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>My Profile</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentProfile.css">
    </head>

    <body>

        <jsp:include page="studentNav.jsp" />

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
                    <i class="fa-solid fa-circle-check" style="color: #198754; font-size: 1.1rem;"></i>
                    <span style="margin-left: 8px;">
                        <%
                            if (status.equals("updated"))
                                out.print("Success! Your profile information has been saved.");
                            else if (status.equals("password_changed"))
                                out.print("Security Update: Your password has been changed successfully.");
                        %>
                    </span>
                </div>
                <% } %>

                <div class="profile-header">
                    <div class="profile-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
                        <% if (profileImage.equals("default.png")) { %>
                        <i class="fa-solid fa-user"></i>
                        <% } else {%>
                        <img src="images/<%= profileImage%>" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                        <% }%>
                    </div>

                    <div class="profile-title">
                        <h2><%= name%></h2>
                        <p>Student ID : <%= id%></p>
                        <span class="status-badge" style="background:#e3f2fd; color:#0d47a1;">Student</span>
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
                            <span class="label">Program :</span>
                            <span class="value"><%= program%></span>
                        </div>
                        <div class="info-row">
                            <span class="label">Email :</span>
                            <span class="value"><%= email%></span>
                        </div>
                        <div class="info-row">
                            <span class="label">Year :</span>
                            <span class="value"><%= year%></span>
                        </div>
                    </div>
                </div>

                <div class="divider"></div>

                <div class="info-section">
                    <h3 class="section-title">Account Setting :</h3>
                    <a href="studentUpdateProfile.jsp" class="action-link">
                        <span class="link-text">Update profile</span>
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                    <a href="studentChangePassword.jsp" class="action-link">
                        <span class="link-text">Change Password</span>
                        <i class="fa-solid fa-chevron-right"></i>
                    </a>
                </div>

            </div>
        </main>

    </body>
</html>