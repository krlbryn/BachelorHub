<%-- Document : studentUpdateProfile Created on : 29 Jan 2026 Author : Antigravity --%>

<%@page import="java.sql.*" %>
<%@page import="com.mvc.util.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "";
    String email = "";
    String program = "";
    String year = "";
    String id = "";
    // New variable for pre-filling
    String currentImage = "default.png";

    try {
        Connection con = DBConnection.createConnection();
        String sql = "SELECT * FROM student WHERE stu_Username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            id = rs.getString("stud_ID");
            name = rs.getString("stu_Name");
            email = rs.getString("stu_Email");
            program = rs.getString("stu_Program");
            year = String.valueOf(rs.getInt("stu_Year"));

            String imgDB = rs.getString("stu_Image");
            if (imgDB != null && !imgDB.isEmpty()) {
                currentImage = imgDB;
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
        <title>Update Profile</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentUpdateProfile.css">
    </head>

    <body>

        <jsp:include page="studentNav.jsp" />

        <main class="main-content">
            <h1 class="header-title">Update Profile</h1>
            <p class="header-subtitle">Edit your account details below</p>

            <div class="profile-container">
                <div class="decoration-line"></div>

                <% String msg = request.getParameter("msg");
                if (msg != null) {%>
                <div class="error-msg">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <%= msg%>
                </div>
                <% }%>

                <form action="StudentUpdateServlet" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="stud_id" value="<%= id%>">

                    <div class="profile-header">
                        <div class="profile-avatar" style="overflow: hidden; display: flex; align-items: center; justify-content: center;">
                            <% if (currentImage.equals("default.png")) { %>
                            <i class="fa-solid fa-user"></i>
                            <% } else {%>
                            <img src="images/<%= currentImage%>" style="width: 100%; height: 100%; object-fit: cover;">
                            <% }%>
                        </div>

                        <div class="profile-title">
                            <h2><%= name%></h2>
                            <p>Student ID : <%= id%></p>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="info-section">
                        <h3 class="section-title">Edit Information :</h3>

                        

                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" class="form-control" value="<%= name%>" required>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="<%= email%>" required>
                        </div>

                        <div class="form-group">
                            <label>Program</label>
                            <input type="text" name="program" class="form-control" value="<%= program%>">
                        </div>

                        <div class="form-group">
                            <label>Year</label>
                            <input type="number" name="year" class="form-control" value="<%= year%>">
                        </div>
                        
                        <div class="form-group">
                            <label>Profile Picture</label>
                            <input type="file" name="stu_Image" class="form-control" accept="image/*">
                            <small style="color: #666; font-size: 0.85rem;">Leave empty to keep current photo.</small>
                        </div>

                        <div class="divider"></div>
                        <br>

                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn-save">Save Changes</button>
                            <a href="studentProfile.jsp" class="btn-cancel-link">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>

    </body>
</html>