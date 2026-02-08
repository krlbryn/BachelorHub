<%-- 
    Document   : login
    Created on : 19 Jan 2026, 4:59:58 pm
    Author     : Karl
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Original Functionality & Security logic
    String type = request.getParameter("type");
    boolean isAdminInit = "admin".equals(type);
    String errorMessage = (String) request.getAttribute("errMessage");
    boolean hasError = (errorMessage != null && !errorMessage.isEmpty());

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | ElectVote Portal</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ElectVoteTheme.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="ivote-bg">

    <header class="top-branding-header">
        <div class="nav-container">
            <a href="index.jsp" class="logo" style="text-decoration: none; color: white;">
                <i class="fa-solid fa-check-to-slot"></i> ElectVote
            </a>
            <div class="nav-actions">
                <a href="index.jsp" class="btn-back-home">
                    <i class="fa-solid fa-house"></i> Back to Home
                </a>
            </div>
        </div>
        
        <div class="header-wave">
            <svg viewBox="0 0 1440 120" preserveAspectRatio="none">
                <path fill="#ffffff" d="M0,32L120,42.7C240,53,480,75,720,74.7C960,75,1200,53,1320,42.7L1440,32L1440,120L1320,120C1200,120,960,120,720,120C480,120,240,120,120,120L0,120Z"></path>
            </svg>
        </div>
    </header>

    <div class="login-wrapper">
        <div class="login-card ev-card">
            <div class="brand-logo">
                <i class="fa-solid fa-check-to-slot"></i>
            </div>
            
            <h1 class="login-title">ElectVote</h1>
            <p class="login-subtitle">Student Election Management Portal</p>

            <form action="LoginServlet" method="post">
                <div class="role-selection">
                    <label class="role-option">
                        <input type="radio" name="role" value="admin" <%= isAdminInit ? "checked" : "" %> onclick="updateLabel('Admin Username', 'Enter Admin Username')">
                        <div class="role-box">
                            <i class="fa-solid fa-user-shield"></i>
                            <span>Admin</span>
                        </div>
                    </label>
                    <label class="role-option">
                        <input type="radio" name="role" value="student" <%= !isAdminInit ? "checked" : "" %> onclick="updateLabel('Student ID', 'Enter Student Username')">
                        <div class="role-box">
                            <i class="fa-solid fa-user-graduate"></i>
                            <span>Student</span>
                        </div>
                    </label>
                </div>

                <div class="form-group">
                    <label id="idLabel"><%= isAdminInit ? "Admin Username" : "Student ID" %></label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-id-badge"></i>
                        <input type="text" name="username" class="form-control-ev" 
                               placeholder="<%= isAdminInit ? "Enter Admin Username" : "Enter Student Username" %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Security Password</label>
                    <div class="input-wrapper">
                        <i class="fa-solid fa-lock"></i>
                        <input type="password" name="password" id="password" class="form-control-ev" placeholder="Enter security password" required>
                        <i class="fa-solid fa-eye-slash toggle-password" id="togglePassword"></i>
                    </div>
                </div>

                <button type="submit" class="ev-btn-primary" style="width: 100%; margin-top: 10px; border: none; cursor: pointer;">
                    Sign In to Portal
                </button>
            </form>
        </div>
    </div>

    <div id="errorModal" class="modal-overlay" style="<%= hasError ? "display: flex;" : "display: none;" %>">
        <div class="modal-box">
            <i class="fa-solid fa-circle-xmark" style="color: #EB5757; font-size: 50px; margin-bottom: 15px;"></i>
            <h3 class="modal-title">Authentication Failed</h3>
            <p class="modal-text"><%= (errorMessage != null) ? errorMessage : "" %></p>
            <button class="ev-btn-primary" onclick="closeErrorModal()" style="border: none; padding: 10px 25px;">Try Again</button>
        </div>
    </div>

    <script>
        function updateLabel(text, placeholder) {
            document.getElementById('idLabel').innerText = text;
            document.getElementsByName('username')[0].placeholder = placeholder;
        }

        const togglePassword = document.querySelector('#togglePassword');
        const passwordField = document.querySelector('#password');
        togglePassword.addEventListener('click', function () {
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });

        function closeErrorModal() { document.getElementById('errorModal').style.display = 'none'; }
    </script>
</body>
</html>