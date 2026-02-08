<%-- 
    Document   : adminProfile
    Updated on : Feb 08, 2026
    Description: Admin Profile - Removed Edit Cover Button
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
    String profileImage = null;

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

            String dbPhone = rs.getString("admin_Phone");
            String dbAddress = rs.getString("admin_Address");
            String dbImage = rs.getString("admin_Image");

            if (dbPhone != null && !dbPhone.isEmpty()) phone = dbPhone;
            if (dbAddress != null && !dbAddress.isEmpty()) address = dbAddress;
            if (dbImage != null && !dbImage.isEmpty()) profileImage = dbImage;
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | ElectVote Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* --- iVOTE THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-secondary: #4A90E2;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
            --ev-success: #00c853;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--ev-bg);
            color: var(--ev-text);
            padding-left: 260px;
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- HEADER --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        .header-subtitle { color: var(--ev-muted); font-size: 14px; margin: 0; }

        /* --- PROFILE CARD LAYOUT --- */
        .profile-card {
            background: var(--ev-card);
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            overflow: hidden;
            max-width: 900px;
            margin: 0 auto;
            position: relative;
        }

        /* Blue Banner - Clean (No Button) */
        .profile-banner {
            height: 170px;
            background: linear-gradient(90deg, #1E56A0 0%, #3B82F6 100%);
            position: relative;
        }

        /* --- AVATAR SECTION --- */
        .profile-header-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            /* Negative margin pulls avatar up into the banner */
            margin-top: -90px; 
            padding-bottom: 20px;
            position: relative;
            z-index: 2;
        }

        .avatar-container {
            width: 180px;  /* Size of the circle */
            height: 180px; /* Size of the circle */
            border-radius: 50%;
            border: 6px solid #FFFFFF;
            background: #FFFFFF;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden; /* Ensures image stays inside circle */
            display: flex; 
            align-items: center; 
            justify-content: center;
            margin-bottom: 15px;
        }

        /* Forces image to fill the circle exactly */
        .profile-pic-large { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
            display: block; 
        }
        
        .default-avatar-icon { font-size: 80px; color: #E8EEF3; }

        .user-name { font-size: 24px; font-weight: 700; color: var(--ev-text); margin: 0 0 5px 0; }
        .user-role { color: var(--ev-primary); font-size: 14px; font-weight: 600; margin-bottom: 10px; }
        
        .active-badge {
            background-color: #d1fae5; color: #065f46;
            padding: 4px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .active-dot { width: 6px; height: 6px; background-color: #10b981; border-radius: 50%; }

        /* --- INFO GRID --- */
        .info-section { padding: 10px 40px 40px 40px; }
        
        .section-heading {
            font-size: 12px; font-weight: 700; color: var(--ev-muted);
            text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 15px; margin-top: 20px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .detail-box {
            background: #FAFBFF;
            border: 1px solid #E8EEF3;
            border-radius: 10px;
            padding: 15px 20px;
            display: flex;
            flex-direction: column;
        }

        .detail-label { font-size: 13px; color: var(--ev-muted); margin-bottom: 6px; }
        .detail-value { font-size: 15px; color: var(--ev-text); font-weight: 500; display: flex; align-items: center; gap: 10px; }
        .detail-icon { color: var(--ev-primary); font-size: 16px; width: 20px; }

        /* Footer Actions */
        .card-footer {
            padding: 20px 40px;
            background: #FAFBFF;
            border-top: 1px solid #E8EEF3;
            display: flex;
            justify-content: flex-end;
            gap: 15px;
        }

        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            transition: 0.2s;
            display: flex; align-items: center; gap: 8px;
        }
        .btn-outline { border: 1px solid #E8EEF3; background: white; color: var(--ev-text); }
        .btn-outline:hover { background: #F4F7FE; border-color: var(--ev-muted); }
        .btn-fill { background: var(--ev-primary); color: white; border: none; }
        .btn-fill:hover { background: #154585; box-shadow: 0 4px 10px rgba(30, 86, 160, 0.2); }

        .alert-box {
            padding: 15px; border-radius: 10px; margin-bottom: 25px; 
            display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 500;
        }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">My Profile</h1>
            <p class="header-subtitle">Manage your account information and security settings.</p>
        </div>

        <%
            String status = request.getParameter("status");
            if (status != null) {
                String msg = "";
                if (status.equals("updated")) msg = "Profile details updated successfully!";
                else if (status.equals("password_changed")) msg = "Security password changed successfully!";
        %>
            <div class="alert-box alert-success">
                <i class="fa-solid fa-circle-check"></i> <%= msg %>
            </div>
        <% } %>

        <div class="profile-card">
            
            <div class="profile-banner"></div>
            
            <div class="profile-header-content">
                <div class="avatar-container">
                    <% if (profileImage != null && !profileImage.trim().isEmpty() && !profileImage.equals("default.png")) { %>
                        <img src="${pageContext.request.contextPath}/images/<%= profileImage %>" alt="Profile" class="profile-pic-large">
                    <% } else { %>
                        <i class="fa-solid fa-user default-avatar-icon"></i>
                    <% } %>
                </div>
                <h2 class="user-name"><%= name %></h2>
                <div class="user-role">System Administrator</div>
                <div class="active-badge"><span class="active-dot"></span> Active</div>
            </div>

            <div class="info-section">
                <div class="section-heading">Contact Information</div>
                
                <div class="details-grid">
                    <div class="detail-box">
                        <span class="detail-label">Email Address</span>
                        <div class="detail-value">
                            <i class="fa-regular fa-envelope detail-icon"></i> <%= email %>
                        </div>
                    </div>

                    <div class="detail-box">
                        <span class="detail-label">Phone Number</span>
                        <div class="detail-value">
                            <i class="fa-solid fa-phone detail-icon"></i> <%= phone %>
                        </div>
                    </div>

                    <div class="detail-box">
                        <span class="detail-label">Admin ID</span>
                        <div class="detail-value">
                            <i class="fa-solid fa-id-card detail-icon"></i> <%= id %>
                        </div>
                    </div>

                    <div class="detail-box">
                        <span class="detail-label">Username</span>
                        <div class="detail-value">
                            <i class="fa-solid fa-user-lock detail-icon"></i> <%= userSession %>
                        </div>
                    </div>
                </div>

                <div class="section-heading">Address</div>
                <div class="detail-box">
                    <span class="detail-label">Office / Home Address</span>
                    <div class="detail-value">
                        <i class="fa-solid fa-location-dot detail-icon"></i> <%= address %>
                    </div>
                </div>
            </div>

            <div class="card-footer">
                <a href="adminChangePassword.jsp" class="btn-action btn-outline">
                    <i class="fa-solid fa-key"></i> Change Password
                </a>
                <a href="adminUpdateProfile.jsp" class="btn-action btn-fill">
                    <i class="fa-solid fa-pen-to-square"></i> Update Profile
                </a>
            </div>

        </div>
    </main>

</body>
</html>