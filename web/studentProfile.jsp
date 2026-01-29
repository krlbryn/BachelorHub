<%-- Document : studentProfile Created on : 29 Jan 2026 Author : Antigravity --%>

    <%@page import="java.sql.*" %>
        <%@page import="com.mvc.util.DBConnection" %>
            <%@page contentType="text/html" pageEncoding="UTF-8" %>
                <% /* 1. Security Check */ String userSession=(String) session.getAttribute("userSession"); if
                    (userSession==null) { response.sendRedirect("login.jsp"); return; } /* 2. Default Variables */
                    String name="Loading..." ; String email="Loading..." ; String id="Loading..." ; String
                    program="Not Set" ; String year="Not Set" ; String profileImage=null; /* 3. Fetch Data from Database
                    */ try { Connection con=DBConnection.createConnection(); String
                    sql="SELECT * FROM student WHERE stu_Username = ?" ; PreparedStatement ps=con.prepareStatement(sql);
                    ps.setString(1, userSession); ResultSet rs=ps.executeQuery(); if (rs.next()) {
                    name=rs.getString("stu_Name"); email=rs.getString("stu_Email"); id=rs.getString("stud_ID");
                    program=rs.getString("stu_Program"); year=String.valueOf(rs.getInt("stu_Year")); } rs.close();
                    ps.close(); con.close(); } catch (Exception e) { e.printStackTrace(); } %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>My Profile</title>

                        <link
                            href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap"
                            rel="stylesheet">
                        <link rel="stylesheet"
                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/css/studentDashboard.css">
                        <link rel="stylesheet" type="text/css"
                            href="${pageContext.request.contextPath}/css/adminProfile.css">
                        <style>
                            body {
                                display: flex;
                                background-color: #f4f7fa;
                                margin: 0;
                            }

                            .main-content {
                                flex: 1;
                                padding: 30px;
                                margin-left: 0 !important;
                            }

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

                        <!-- SIDEBAR -->
                        <div class="sidebar">
                            <div class="brand">
                                <i class="fa-solid fa-check-to-slot"></i>
                                <span>VOTE</span>
                            </div>

                            <ul class="nav-links">
                                <li>
                                    <a href="studentDashboard.jsp">
                                        <i class="fa-solid fa-border-all"></i>
                                        <span>Dashboard</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="studentVote.jsp">
                                        <i class="fa-solid fa-box-archive"></i>
                                        <span>Vote</span>
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <i class="fa-solid fa-square-poll-vertical"></i>
                                        <span>Voting Results</span>
                                    </a>
                                </li>
                            </ul>

                            <div class="logout-section">
                                <ul class="nav-links">
                                    <li>
                                        <a href="studentProfile.jsp" class="active">
                                            <i class="fa-solid fa-user"></i>
                                            <span>My Profile</span>
                                        </a>
                                    </li>
                                </ul>
                                <a href="#" onclick="confirmLogout()" class="logout-link">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                    <span>Sign Out</span>
                                </a>
                                <div
                                    style="margin-top: 20px; padding-left: 15px; color: #666; font-size: 14px; cursor: pointer;">
                                    <span>Help</span>
                                </div>
                            </div>
                        </div>

                        <main class="main-content">
                            <h1 class="header-title">My Profile</h1>
                            <p class="header-subtitle">Manage your account settings</p>

                            <div class="profile-container">
                                <div class="decoration-line"></div>
                                <% String status=request.getParameter("status"); if (status !=null) { %>
                                    <div class="success-msg">
                                        <i class="fa-solid fa-circle-check"></i>
                                        <% if (status.equals("updated")) { %>
                                            Profile details updated successfully!
                                            <% } else if (status.equals("password_changed")) { %>
                                                Password changed successfully!
                                                <% } %>
                                    </div>
                                    <% } %>

                                        <div class="profile-header">
                                            <div class="profile-avatar">
                                                <i class="fa-solid fa-user"></i>
                                            </div>

                                            <div class="profile-title">
                                                <h2>
                                                    <%= name%>
                                                </h2>
                                                <p>Student ID : <%= id%>
                                                </p>
                                                <span class="status-badge"
                                                    style="background:#e3f2fd; color:#0d47a1;">Student</span>
                                            </div>
                                        </div>

                                        <div class="divider"></div>

                                        <div class="info-section">
                                            <h3 class="section-title">Account Information :</h3>
                                            <div class="info-grid">
                                                <div class="info-row">
                                                    <span class="label">Username :</span>
                                                    <span class="value">
                                                        <%= userSession%>
                                                    </span>
                                                </div>
                                                <div class="info-row">
                                                    <span class="label">Program :</span>
                                                    <span class="value">
                                                        <%= program%>
                                                    </span>
                                                </div>
                                                <div class="info-row">
                                                    <span class="label">Email :</span>
                                                    <span class="value">
                                                        <%= email%>
                                                    </span>
                                                </div>
                                                <div class="info-row">
                                                    <span class="label">Year :</span>
                                                    <span class="value">
                                                        <%= year%>
                                                    </span>
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
                                            <!-- Placeholder for Change Password, similar to Admin -->
                                            <a href="studentChangePassword.jsp" class="action-link">
                                                <span class="link-text">Change Password</span>
                                                <i class="fa-solid fa-chevron-right"></i>
                                            </a>
                                        </div>

                            </div>
                        </main>

                        <!-- Logout Confirmation Modal -->
                        <div id="logoutModal" class="modal-overlay" style="display:none;">
                            <div class="modal-box">
                                <h3 class="modal-title">Confirm Logout</h3>
                                <p class="modal-text">Are you sure you want to sign out?</p>
                                <div class="modal-buttons">
                                    <a href="login.jsp" class="btn-confirm">Yes, Sign Out</a>
                                    <button onclick="closeModal()" class="btn-cancel">Cancel</button>
                                </div>
                            </div>
                        </div>

                        <script>
                            function confirmLogout() {
                                document.getElementById('logoutModal').style.display = 'flex';
                            }
                            function closeModal() {
                                document.getElementById('logoutModal').style.display = 'none';
                            }
                        </script>

                    </body>

                    </html>