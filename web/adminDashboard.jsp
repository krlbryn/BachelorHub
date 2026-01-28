<%-- 
    Document   : adminDashboard
    Created on : 28 Jan 2026, 8:28:26 pm
    Author     : ParaNon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Security Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    </head>
    <body>

        <nav class="sidebar">
            <div class="brand">
                <i class="fa-solid fa-check-to-slot"></i>
                <span>Election Admin</span>
            </div>

            <ul class="nav-links">
                <li>
                    <a href="adminDashboard.jsp" class="active">
                        <i class="fa-solid fa-table-columns"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="#"> <i class="fa-solid fa-calendar-check"></i>
                        <span>Manage Elections</span>
                    </a>
                </li>
                <li>
                    <a href="#"> <i class="fa-solid fa-users-gear"></i>
                        <span>Manage Candidates</span>
                    </a>
                </li>
                <li>
                    <a href="#"> <i class="fa-solid fa-person-booth"></i>
                        <span>Voting Page</span>
                    </a>
                </li>
                <li>
                    <a href="#"> <i class="fa-solid fa-chart-pie"></i>
                        <span>Voting Results</span>
                    </a>
                </li>
                <li>
                    <a href="#"> <i class="fa-solid fa-user-tie"></i>
                        <span>My Profile</span>
                    </a>
                </li>
            </ul>

            <div class="logout-section">
                <a href="#" class="logout-link" onclick="openLogoutModal()">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <span>Sign Out</span>
                </a>
            </div>
        </nav>

        <main class="main-content">
            <h1 class="header-title">Dashboard</h1>
            <p class="header-subtitle">Welcome back, <%= userSession%>!</p>

            <div style="padding: 20px; border: 2px dashed #ccc; border-radius: 10px; color: #777; text-align: center;">
                <i class="fa-solid fa-hammer" style="font-size: 30px; margin-bottom: 10px;"></i><br>
                Content Area Ready
            </div>
        </main>

        <div id="logoutModal" class="modal-overlay">
            <div class="modal-box">
                <i class="fa-solid fa-triangle-exclamation" style="color: #d9534f; font-size: 40px; margin-bottom: 15px;"></i>
                <h3 class="modal-title">Confirm Logout</h3>
                <p class="modal-text">Are you sure you want to end your session?</p>

                <div class="modal-buttons">
                    <div class="btn-cancel" onclick="closeLogoutModal()">Cancel</div>
                    <a href="login.jsp" class="btn-confirm">Yes, Log Out</a>
                </div>
            </div>
        </div>

        <script>
            function openLogoutModal() {
                document.getElementById('logoutModal').style.display = 'flex';
            }

            function closeLogoutModal() {
                document.getElementById('logoutModal').style.display = 'none';
            }

            window.onclick = function (event) {
                var modal = document.getElementById('logoutModal');
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>

    </body>
</html>