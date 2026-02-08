<%-- 
    Document   : studentProfile 
    Updated on : Feb 09, 2026 
    Description: Student Profile (Matched to Admin Theme with DB Integration)
--%>

<%@page import="java.sql.*" %>
<%@page import="com.mvc.util.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    // 1. SESSION VALIDATION
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize variables with fallbacks
    String name = "Loading...";
    String email = "Loading...";
    String studentID = "Loading...";
    String program = "Not Set";
    String year = "Not Set";
    String profileImage = "default.png";
    String username = userSession;

    // 2. DATABASE DATA RETRIEVAL
    try {
        Connection con = DBConnection.createConnection();
        // Querying all student details based on the logged-in ID
        String sql = "SELECT * FROM student WHERE stu_id = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("stu_Name");
            email = rs.getString("stu_Email");
            studentID = rs.getString("stud_ID"); // Primary Key
            program = rs.getString("stu_Program");
            year = String.valueOf(rs.getInt("stu_Year"));
            username = rs.getString("stu_Username");

            String imgDB = rs.getString("stu_Image");
            if (imgDB != null && !imgDB.isEmpty()) {
                profileImage = imgDB;
            }
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | ElectVote</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    
    <style>
        /* Admin-Style Profile Card Styling */
        .profile-main-card {
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid #E8EEF3;
            margin-top: 10px;
        }

        .profile-hero {
            display: flex;
            align-items: center;
            gap: 30px;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid #F1F5F9;
        }

        .avatar-container {
            width: 120px;
            height: 120px;
            border-radius: 15px; /* Matched to Admin Square-ish avatar */
            overflow: hidden;
            border: 4px solid #fff;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            background: #F8F9FC;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .avatar-container img { width: 100%; height: 100%; object-fit: cover; }
        .avatar-container i { font-size: 4rem; color: #cbd5e1; }

        .hero-info h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.8rem;
            color: #1a1a3d;
            margin-bottom: 5px;
        }

        .role-tag {
            background: #F4F7FE;
            color: #1E56A0;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            display: inline-block;
        }

        /* Information Grid matching image_df0700 sections */
        .data-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            margin-bottom: 40px;
        }

        .data-box {
            padding: 20px;
            background: #F9FBFD;
            border-radius: 12px;
            border: 1px solid #EDF2F7;
        }

        .data-box label {
            display: block;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #8A92A6;
            margin-bottom: 8px;
            font-weight: 700;
        }

        .data-box span {
            font-size: 15px;
            color: #1a1a3d;
            font-weight: 600;
        }

        /* Action Buttons */
        .settings-grid {
            display: flex;
            gap: 15px;
        }

        .action-card {
            flex: 1;
            padding: 18px;
            border: 1.5px solid #E2E8F0;
            border-radius: 12px;
            text-decoration: none;
            color: #1a1a3d;
            font-weight: 600;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: 0.2s;
        }

        .action-card:hover {
            border-color: #1E56A0;
            background: #F4F7FE;
            color: #1E56A0;
            transform: translateY(-2px);
        }

        .alert-success {
            background: #f0fdf4;
            color: #166534;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #bbf7d0;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }
    </style>
</head>

<body>

    <jsp:include page="studentNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="studentHeader.jsp" />

        <div class="dashboard-container">
            <div class="page-header">
                <h1 class="page-title">Personal Profile</h1>
                <p class="page-subtitle">View and manage your student credentials</p>
            </div>

            <div class="profile-main-card">
                <%-- Status Notifications --%>
                <%
                    String status = request.getParameter("status");
                    if (status != null) {
                %>
                <div class="alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>
                        <%
                            if (status.equals("updated")) out.print("Profile details synchronized successfully.");
                            else if (status.equals("password_changed")) out.print("Security password updated.");
                        %>
                    </span>
                </div>
                <% } %>

                <div class="profile-hero">
                    <div class="avatar-container">
                        <% if (profileImage != null && !profileImage.equals("default.png")) { %>
                            <img src="${pageContext.request.contextPath}/images/<%= profileImage %>" alt="Student Profile">
                        <% } else { %>
                            <i class="fa-solid fa-user-graduate"></i>
                        <% } %>
                    </div>

                    <div class="hero-info">
                        <h2><%= name%></h2>
                        <div class="role-tag">STUDENT ID: <%= studentID %></div>
                    </div>
                </div>

                <div class="data-grid">
                    <div class="data-box">
                        <label>User Login (ID)</label>
                        <span><%= username %></span>
                    </div>
                    <div class="data-box">
                        <label>Major / Program</label>
                        <span><%= program %></span>
                    </div>
                    <div class="data-box">
                        <label>Official Email</label>
                        <span><%= email %></span>
                    </div>
                    <div class="data-box">
                        <label>Academic Year</label>
                        <span>Year <%= year %></span>
                    </div>
                </div>

                <div class="settings-group">
                    <h3 style="font-family: 'Montserrat'; font-size: 1.1rem; margin-bottom: 20px; color: #1a1a3d;">Account Settings</h3>
                    <div class="settings-grid">
                        <a href="studentUpdateProfile.jsp" class="action-card">
                            <span>Update Profile Info</span>
                            <i class="fa-solid fa-user-gear"></i>
                        </a>
                        <a href="studentChangePassword.jsp" class="action-card">
                            <span>Security & Password</span>
                            <i class="fa-solid fa-shield-halved"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

</body>
</html>