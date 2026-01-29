<%-- Document : studentUpdateProfile Created on : 29 Jan 2026 Author : Antigravity --%>

    <%@page import="java.sql.*" %>
        <%@page import="com.mvc.util.DBConnection" %>
            <%@page contentType="text/html" pageEncoding="UTF-8" %>
                <% /* 1. Security Check */ String userSession=(String) session.getAttribute("userSession"); if
                    (userSession==null) { response.sendRedirect("login.jsp"); return; } /* Default empty variables */
                    String name="" ; String email="" ; String program="" ; String year="" ; String id="" ; try {
                    Connection con=DBConnection.createConnection(); String
                    sql="SELECT * FROM student WHERE stu_Username = ?" ; PreparedStatement ps=con.prepareStatement(sql);
                    ps.setString(1, userSession); ResultSet rs=ps.executeQuery(); if (rs.next()) {
                    id=rs.getString("stud_ID"); name=rs.getString("stu_Name"); email=rs.getString("stu_Email");
                    program=rs.getString("stu_Program"); year=String.valueOf(rs.getInt("stu_Year")); } rs.close();
                    ps.close(); con.close(); } catch (Exception e) { e.printStackTrace(); } %>

                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <title>Update Profile</title>

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
                            </div>
                        </div>

                        <main class="main-content">
                            <h1 class="header-title">Update Profile</h1>
                            <p class="header-subtitle">Edit your account details below</p>

                            <div class="profile-container">
                                <div class="decoration-line"></div>

                                <% String msg=request.getParameter("msg"); if(msg!=null) { %>
                                    <div
                                        style="background:#f8d7da; color:#721c24; padding:10px; margin-bottom:10px; border-radius:5px;">
                                        <%= msg %>
                                    </div>
                                    <% } %>

                                        <form action="StudentUpdateServlet" method="post">

                                            <input type="hidden" name="stud_id" value="<%= id%>">

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
                                                </div>
                                            </div>

                                            <div class="divider"></div>

                                            <div class="info-section">
                                                <h3 class="section-title">Edit Information :</h3>

                                                <div class="form-group">
                                                    <label>Full Name</label>
                                                    <input type="text" name="name" class="form-control"
                                                        value="<%= name%>" required>
                                                </div>

                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="email" name="email" class="form-control"
                                                        value="<%= email%>" required>
                                                </div>

                                                <div class="form-group">
                                                    <label>Program</label>
                                                    <input type="text" name="program" class="form-control"
                                                        value="<%= program%>">
                                                </div>

                                                <div class="form-group">
                                                    <label>Year</label>
                                                    <input type="number" name="year" class="form-control"
                                                        value="<%= year%>">
                                                </div>

                                                <div class="divider"></div>

                                                <br>
                                                <div style="display: flex; gap: 10px;">
                                                    <button type="submit" class="btn-save">Save Changes</button>
                                                    <a href="studentProfile.jsp"
                                                        style="text-decoration: none; padding: 10px 20px; color: #555; border: 1px solid #ccc; border-radius: 5px;">Cancel</a>
                                                </div>
                                            </div>
                                        </form>
                            </div>
                        </main>

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