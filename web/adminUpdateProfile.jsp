<%-- 
    Document   : adminUpdateProfile
    Created on : 29 Jan 2026, 9:53:03 am
    Author     : ParaNon
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Security & Fetch Data (Same as before)
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Default empty variables
    String name = "";
    String email = "";
    String phone = "";
    String address = "";
    String id = "";
    String image = "default.png"; // Default image

    try {
        Connection con = DBConnection.createConnection();
        // We select the current data so we can pre-fill the boxes
        String sql = "SELECT * FROM admin WHERE admin_username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            id = rs.getString("admin_ID");
            name = rs.getString("admin_Name");
            email = rs.getString("admin_Email");
            phone = rs.getString("admin_Phone");
            address = rs.getString("admin_Address");
            if (rs.getString("admin_Image") != null) {
                image = rs.getString("admin_Image");
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
        <title>Update Profile</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">

        <style>
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .form-control {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .btn-save {
                background-color: #28a745;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .btn-save:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>

        <jsp:include page="adminNav.jsp" />

        <main class="main-content">
            <h1 class="header-title">Update Profile</h1>
            <p class="header-subtitle">Edit your account details below</p>

            <div class="profile-container">
                <div class="decoration-line"></div>

                <form action="AdminUpdateServlet" method="post" enctype="multipart/form-data">

                    <input type="hidden" name="admin_id" value="<%= id%>">
                    <input type="hidden" name="oldImage" value="<%= image%>">

                    <div class="profile-header">
                        <img src="images/<%= image%>" class="profile-avatar-img" style="width:100px; height:100px; object-fit:cover; border-radius:50%;">
                        <div class="profile-title">
                            <h2><%= name%></h2>
                            <p>Admin ID : <%= id%></p>
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
                            <label>Phone Number</label>
                            <input type="text" name="phone" class="form-control" value="<%= phone%>">
                        </div>

                        <div class="form-group">
                            <label>Address</label>
                            <textarea name="address" class="form-control" rows="3"><%= address%></textarea>
                        </div>

                        <div class="divider"></div>

                        <div class="form-group">
                            <label>Profile Picture</label>
                            <input type="file" name="imageFile" class="form-control" accept="image/*">
                            <small style="color: #666;">Leave empty to keep current photo.</small>
                        </div>

                        <br>
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn-save">Save Changes</button>
                            <a href="adminProfile.jsp" style="text-decoration: none; padding: 10px 20px; color: #555; border: 1px solid #ccc; border-radius: 5px;">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>