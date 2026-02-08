<%-- 
    Document   : adminChangePassword
    Updated on : Feb 08, 2026
    Description: Change Password Page with iVOTE Theme
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
    <title>Change Password | ElectVote Admin</title>
    
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
            --ev-danger: #ff1744;
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

        /* --- FORM CARD --- */
        .password-card {
            background: var(--ev-card);
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            max-width: 600px;
            margin: 0 auto;
        }

        .form-group { margin-bottom: 20px; }
        
        .form-label { 
            display: block; font-weight: 600; font-size: 13px; 
            color: var(--ev-text); margin-bottom: 8px; 
        }
        
        .password-wrapper { position: relative; width: 100%; }
        
        .form-control { 
            width: 100%; padding: 12px 40px 12px 15px; /* Right padding for eye icon */
            border: 2px solid #E8EEF3; border-radius: 10px; 
            font-family: 'Poppins', sans-serif; font-size: 14px; color: #1a1a3d;
            box-sizing: border-box; transition: 0.3s;
        }
        .form-control:focus { outline: none; border-color: var(--ev-primary); background: #F9FBFD; }

        .toggle-icon {
            position: absolute; right: 15px; top: 50%;
            transform: translateY(-50%);
            cursor: pointer; color: #8A92A6; font-size: 14px;
            transition: 0.2s;
        }
        .toggle-icon:hover { color: var(--ev-primary); }

        /* --- BUTTONS --- */
        .form-actions {
            display: flex; justify-content: flex-end; gap: 15px;
            margin-top: 30px; padding-top: 20px; border-top: 1px solid #E8EEF3;
        }

        .btn-update {
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white; padding: 12px 30px; border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer; transition: 0.3s;
            box-shadow: 0 4px 15px rgba(30, 86, 160, 0.2);
        }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.3); }

        .btn-cancel {
            background: #F4F7FE; color: var(--ev-muted); padding: 12px 25px; 
            border: none; border-radius: 10px; font-weight: 600; 
            text-decoration: none; display: flex; align-items: center; justify-content: center;
            transition: 0.2s;
        }
        .btn-cancel:hover { background: #E8EEF3; color: var(--ev-text); }

        /* --- ALERT --- */
        .alert-error {
            background: #FFF5F5; color: #D32F2F; border: 1px solid #FFCDD2;
            padding: 15px; border-radius: 10px; margin-bottom: 25px;
            font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 10px;
        }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Change Password</h1>
            <p class="header-subtitle">Update your credentials to keep your account secure.</p>
        </div>

        <div class="password-card">
            
            <% if(msg != null) { %>
                <div class="alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i> <%= msg %>
                </div>
            <% } %>

            <form action="adminPasswordAction.jsp" method="post">
                
                <div class="form-group">
                    <label class="form-label">Current Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="oldPass" name="oldPass" class="form-control" placeholder="Enter current password" required>
                        <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('oldPass', this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">New Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="newPass" name="newPass" class="form-control" placeholder="Enter new password" required>
                        <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('newPass', this)"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Confirm New Password</label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPass" name="confirmPass" class="form-control" placeholder="Re-type new password" required>
                        <i class="fa-solid fa-eye toggle-icon" onclick="togglePassword('confirmPass', this)"></i>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="adminProfile.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-update">Update Password</button>
                </div>
                
            </form>
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