<%-- Document : studentChangePassword Created on : 29 Jan 2026 Author : Antigravity --%>

<%-- Document : studentChangePassword --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String msg = request.getParameter("msg"); 
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Change Password</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentChangePassword.css">
</head>

<body>

    <jsp:include page="studentNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Change Password</h1>
        <p class="header-subtitle">Secure your account with a new password</p>

        <div class="profile-container">
            <div class="decoration-line"></div>

            <% if (msg != null) {%>
            <div class="error-msg">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <%= msg%>
            </div>
            <% }%>

            <div class="info-section">
                <form action="StudentChangePasswordServlet" method="post">

                    <div class="form-group">
                        <label>Current Password</label>
                        <div class="password-wrapper">
                            <input type="password" id="oldPass" name="oldPass" class="form-control" placeholder="Enter current password" required>
                            <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('oldPass', this)"></i>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <div class="form-group">
                        <label>New Password</label>
                        <div class="password-wrapper">
                            <input type="password" id="newPass" name="newPass" class="form-control" placeholder="Enter new password" required>
                            <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('newPass', this)"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <div class="password-wrapper">
                            <input type="password" id="confirmPass" name="confirmPass" class="form-control" placeholder="Re-type new password" required>
                            <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('confirmPass', this)"></i>
                        </div>
                    </div>

                    <br>
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn-save">Update Password</button>
                        <a href="studentProfile.jsp" style="padding: 12px 20px; color: #555; text-decoration: none; border: 1px solid #ccc; border-radius: 6px;">Cancel</a>
                    </div>

                </form>
            </div>
        </div>
    </main>

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
    </script>

</body>
</html>