<%-- 
    Document   : adminChangePassword
    Created on : 29 Jan 2026, 10:16:08 am
    Author     : ParaNon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
    
    <style>
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; }
        
        /* NEW: Wrapper to hold the input and the eye icon together */
        .password-wrapper {
            position: relative;
            width: 100%;
        }
        
        .form-control { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; }
        
        /* NEW: Style for the Eye Icon */
        .toggle-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%); /* Centers the icon vertically */
            cursor: pointer;
            color: #666;
            font-size: 1.1rem;
        }
        .toggle-icon:hover { color: #333; }

        .btn-save { background-color: #28a745; color: white; padding: 12px 25px; border: none; border-radius: 6px; cursor: pointer; font-size: 1rem; }
        .btn-save:hover { background-color: #218838; }
        
        .error-msg { color: #dc3545; background-color: #f8d7da; padding: 10px; border-radius: 5px; margin-bottom: 15px; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Change Password</h1>
        <p class="header-subtitle">Secure your account with a new password</p>

        <div class="profile-container">
            <div class="decoration-line"></div>
            
            <% if(msg != null) { %>
                <div class="error-msg">
                    <i class="fa-solid fa-triangle-exclamation"></i> <%= msg %>
                </div>
            <% } %>

            <div class="info-section">
                <form action="adminPasswordAction.jsp" method="post">
                    
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
                        <a href="adminProfile.jsp" style="padding: 12px 20px; color: #555; text-decoration: none; border: 1px solid #ccc; border-radius: 6px;">Cancel</a>
                    </div>
                    
                </form>
            </div>
        </div>
    </main>

    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);
            
            if (input.type === "password") {
                input.type = "text"; // Show password
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash"); // Change icon to 'crossed eye'
            } else {
                input.type = "password"; // Hide password
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye"); // Change icon back to 'eye'
            }
        }
    </script>

</body>
</html>
