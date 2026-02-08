<%-- 
    Document   : studentChangePassword 
    Updated on : Feb 09, 2026 
    Description: Security Settings - Update Password (Centered iVOTE Theme)
--%>

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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Settings | ElectVote</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">

    <style>
        /* Centering Logic */
        .centered-content-wrapper {
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 20px;
            min-height: 70vh;
        }

        /* Security Form Aesthetics */
        .security-card {
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 4px 25px rgba(0,0,0,0.06);
            border: 1px solid #E8EEF3;
            width: 100%;
            max-width: 550px; /* Standardized card width */
        }

        .form-section-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.15rem;
            color: #1a1a3d;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .password-field-group {
            margin-bottom: 22px;
        }

        .password-field-group label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #1a1a3d;
            margin-bottom: 10px;
            font-family: 'Montserrat', sans-serif;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i.field-icon {
            position: absolute;
            left: 18px;
            color: #8A92A6;
            font-size: 14px;
        }

        .password-input {
            width: 100%;
            padding: 14px 45px 14px 48px;
            border: 1.5px solid #E2E8F0;
            border-radius: 12px;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background-color: #F9FBFD;
        }

        .password-input:focus {
            outline: none;
            background-color: #fff;
            border-color: #1E56A0;
            box-shadow: 0 0 0 4px rgba(30, 86, 160, 0.1);
        }

        .toggle-view {
            position: absolute;
            right: 18px;
            cursor: pointer;
            color: #8A92A6;
            transition: 0.2s;
            font-size: 14px;
        }

        .toggle-view:hover { color: #1E56A0; }

        /* Action Buttons */
        .btn-group-security {
            display: flex;
            gap: 15px;
            margin-top: 35px;
            padding-top: 25px;
            border-top: 1px solid #F1F5F9;
        }

        .btn-update-pass {
            background: linear-gradient(135deg, #1E56A0 0%, #4A90E2 100%);
            color: white;
            border: none;
            padding: 15px 25px;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            font-family: 'Montserrat', sans-serif;
            flex: 2;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 13px;
            letter-spacing: 0.5px;
        }

        .btn-update-pass:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 20px rgba(30, 86, 160, 0.3); 
        }

        .btn-cancel-security {
            background: #F4F7FE;
            color: #1E56A0;
            text-decoration: none;
            padding: 15px 25px;
            border-radius: 12px;
            font-weight: 700;
            font-family: 'Montserrat', sans-serif;
            text-align: center;
            flex: 1;
            font-size: 13px;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .alert-security {
            background: #fff5f5;
            color: #c53030;
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            border: 1px solid #feb2b2;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 600;
        }
    </style>
</head>

<body>

    <jsp:include page="studentNav.jsp" />

    <main class="main-content">
        <jsp:include page="studentHeader.jsp" />

        <div class="dashboard-container">
            <div class="page-header" style="text-align: center; margin-bottom: 30px;">
                <h1 class="page-title">Security Settings</h1>
                <p class="page-subtitle">Update your credentials to keep your account secure</p>
            </div>

            <div class="centered-content-wrapper">
                <div class="security-card">
                    <% if (msg != null) { %>
                    <div class="alert-security">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%= msg %>
                    </div>
                    <% } %>

                    <form action="StudentChangePasswordServlet" method="post">
                        <h3 class="form-section-title"><i class="fa-solid fa-shield-halved" style="color: #1E56A0;"></i> Authentication Reset</h3>

                        <div class="password-field-group">
                            <label>Current Password</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-key field-icon"></i>
                                <input type="password" id="oldPass" name="oldPass" class="password-input" placeholder="Verify current password" required>
                                <i class="fa-solid fa-eye toggle-view" onclick="togglePassword('oldPass', this)"></i>
                            </div>
                        </div>

                        <div style="height: 1px; background: #F1F5F9; margin: 25px 0;"></div>

                        <div class="password-field-group">
                            <label>New Password</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-lock field-icon"></i>
                                <input type="password" id="newPass" name="newPass" class="password-input" placeholder="Min. 8 characters" required>
                                <i class="fa-solid fa-eye toggle-view" onclick="togglePassword('newPass', this)"></i>
                            </div>
                        </div>

                        <div class="password-field-group">
                            <label>Confirm New Password</label>
                            <div class="input-wrapper">
                                <i class="fa-solid fa-check-double field-icon"></i>
                                <input type="password" id="confirmPass" name="confirmPass" class="password-input" placeholder="Repeat new password" required>
                                <i class="fa-solid fa-eye toggle-view" onclick="togglePassword('confirmPass', this)"></i>
                            </div>
                        </div>

                        <div class="btn-group-security">
                            <button type="submit" class="btn-update-pass">Update Security Key</button>
                            <a href="studentProfile.jsp" class="btn-cancel-security">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

    <script>
        function togglePassword(inputId, icon) {
            const input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                icon.classList.replace("fa-eye", "fa-eye-slash");
            } else {
                input.type = "password";
                icon.classList.replace("fa-eye-slash", "fa-eye");
            }
        }
    </script>

</body>
</html>