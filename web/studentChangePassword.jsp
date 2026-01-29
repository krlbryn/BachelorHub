<%-- Document : studentChangePassword Created on : 29 Jan 2026 Author : Antigravity --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <% String userSession=(String) session.getAttribute("userSession"); if (userSession==null) {
            response.sendRedirect("login.jsp"); return; } String msg=request.getParameter("msg"); %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Change Password</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/css/studentDashboard.css">
                <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">

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
                        margin-bottom: 20px;
                    }

                    .form-group label {
                        display: block;
                        font-weight: bold;
                        margin-bottom: 8px;
                    }

                    .password-wrapper {
                        position: relative;
                        width: 100%;
                    }

                    .form-control {
                        width: 100%;
                        padding: 12px;
                        border: 1px solid #ddd;
                        border-radius: 6px;
                    }

                    .toggle-icon {
                        position: absolute;
                        right: 15px;
                        top: 50%;
                        transform: translateY(-50%);
                        cursor: pointer;
                        color: #666;
                        font-size: 1.1rem;
                    }

                    .toggle-icon:hover {
                        color: #333;
                    }

                    .btn-save {
                        background-color: #28a745;
                        color: white;
                        padding: 12px 25px;
                        border: none;
                        border-radius: 6px;
                        cursor: pointer;
                        font-size: 1rem;
                    }

                    .btn-save:hover {
                        background-color: #218838;
                    }

                    .error-msg {
                        color: #dc3545;
                        background-color: #f8d7da;
                        padding: 10px;
                        border-radius: 5px;
                        margin-bottom: 15px;
                        border: 1px solid #f5c6cb;
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
                    <h1 class="header-title">Change Password</h1>
                    <p class="header-subtitle">Secure your account with a new password</p>

                    <div class="profile-container">
                        <div class="decoration-line"></div>

                        <% if(msg !=null) { %>
                            <div class="error-msg">
                                <i class="fa-solid fa-triangle-exclamation"></i>
                                <%= msg %>
                            </div>
                            <% } %>

                                <div class="info-section">
                                    <!-- Pointing to the new Servlet -->
                                    <form action="StudentChangePasswordServlet" method="post">

                                        <div class="form-group">
                                            <label>Current Password</label>
                                            <div class="password-wrapper">
                                                <input type="password" id="oldPass" name="oldPass" class="form-control"
                                                    placeholder="Enter current password" required>
                                                <i class="fa-solid fa-eye toggle-icon"
                                                    onclick="togglePassword('oldPass', this)"></i>
                                            </div>
                                        </div>

                                        <div class="divider"></div>

                                        <div class="form-group">
                                            <label>New Password</label>
                                            <div class="password-wrapper">
                                                <input type="password" id="newPass" name="newPass" class="form-control"
                                                    placeholder="Enter new password" required>
                                                <i class="fa-solid fa-eye toggle-icon"
                                                    onclick="togglePassword('newPass', this)"></i>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Confirm New Password</label>
                                            <div class="password-wrapper">
                                                <input type="password" id="confirmPass" name="confirmPass"
                                                    class="form-control" placeholder="Re-type new password" required>
                                                <i class="fa-solid fa-eye toggle-icon"
                                                    onclick="togglePassword('confirmPass', this)"></i>
                                            </div>
                                        </div>

                                        <br>
                                        <div style="display: flex; gap: 10px;">
                                            <button type="submit" class="btn-save">Update Password</button>
                                            <a href="studentProfile.jsp"
                                                style="padding: 12px 20px; color: #555; text-decoration: none; border: 1px solid #ccc; border-radius: 6px;">Cancel</a>
                                        </div>

                                    </form>
                                </div>
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
                    function togglePassword(inputId, icon) {
                        const input = document.getElementById(inputId);

                        if (input.type === "password") {
                            input.type = "text";
                            icon.classList.remove("fa-eye");
                            icon.classList.add("fa-eye-slash");
                        } else {
                            input.type = "password";
                            icon.classList.remove("fa-eye-slash");
                            icon.classList.add("fa-eye");
                        }
                    }
                    function confirmLogout() {
                        document.getElementById('logoutModal').style.display = 'flex';
                    }
                    function closeModal() {
                        document.getElementById('logoutModal').style.display = 'none';
                    }
                </script>

            </body>

            </html>