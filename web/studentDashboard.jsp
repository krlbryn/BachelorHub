<%-- Document : studentDashboard Created on : 28 Jan 2026, 9:33:52pm Author : ParaNon --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <% /* Check if user is actually logged in, if not, redirect to login */ String userSession=(String)
            session.getAttribute("userSession"); if (userSession==null) { response.sendRedirect("login.jsp"); return; }
            %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Student Dashboard</title>

                <link
                    href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                <link rel="stylesheet" type="text/css"
                    href="${pageContext.request.contextPath}/css/studentDashboard.css">
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
                            <a href="studentDashboard.jsp" class="active">
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
                                <a href="studentProfile.jsp">
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

                <!-- MAIN CONTENT -->
                <div class="main-content">
                    <div class="header">
                        <h1 class="welcome-text">Student Dashboard</h1>
                        <div class="logo-circle">Logo</div>
                    </div>

                    <div class="content-body">
                        <div
                            style="background: white; padding: 40px; border-radius: 10px; text-align: center; box-shadow: var(--card-shadow);">
                            <i class="fa-solid fa-person-booth"
                                style="font-size: 60px; color: var(--primary-color); margin-bottom: 20px;"></i>
                            <h2 style="margin-bottom: 15px;">Welcome, <%= userSession !=null ? userSession : "Student"
                                    %>!</h2>
                            <p style="color: #666; margin-bottom: 30px; font-size: 16px;">
                                This is your central hub for the student election system.<br>
                                To view available elections and cast your vote, please navigate to the
                                <strong>Vote</strong> page.
                            </p>
                            <a href="studentVote.jsp" class="btn-vote"
                                style="text-decoration: none; display: inline-block; width: auto; padding: 12px 30px;">Go
                                to Vote</a>
                        </div>
                    </div>
                </div>

                <!-- Logout Confirmation Modal -->
                <div id="logoutModal" class="modal-overlay">
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