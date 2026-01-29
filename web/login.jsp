<%-- 
    Document   : login
    Created on : 19 Jan 2026, 4:59:58 pm
    Author     : ParaNon
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. Determine Mode (Admin vs Student)
    String type = request.getParameter("type");
    boolean isAdmin = "admin".equals(type);

    String roleValue = isAdmin ? "admin" : "student";
    String pageTitle = isAdmin ? "Admin Login" : "Student Login";
    String labelText = isAdmin ? "Username" : "Student Username";
    String placeholderText = isAdmin ? "Enter Admin Username" : "Enter Student Username";

    String toggleLink = isAdmin ? "login.jsp" : "login.jsp?type=admin";
    String toggleText = isAdmin ? "Not an admin? Go back home" : "An admin? Click here";

    // 2. Check for Error Message
    String errorMessage = (String) request.getAttribute("errMessage");
    boolean hasError = (errorMessage != null && !errorMessage.isEmpty());

    // Prevent caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Online Student Election - <%= pageTitle%></title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
    </head>
    <body>

        <header>
            <h1>Online Student Election</h1>
        </header>

        <main>
            <div class="login-card">
                <h2><%= pageTitle%></h2>

                <form action="LoginServlet" method="post">
                    <input type="hidden" name="role" value="<%= roleValue%>">

                    <div class="input-group">
                        <label for="username"><%= labelText%></label>
                        <input type="text" id="username" name="username" required placeholder="<%= placeholderText%>">
                    </div>

                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required placeholder="Enter password" style="padding-right: 40px;">
                        <i class="fa-solid fa-eye-slash toggle-password" id="togglePassword"></i>
                    </div>

                    <button type="submit" class="login-btn">Log In</button>

                    <div class="signup-text">
                        <a href="<%= toggleLink%>" style="font-weight: bold;"><%= toggleText%></a>
                    </div>
                </form>
            </div>

            <div class="footer-line"></div>
        </main>

        <div id="errorModal" class="modal-overlay">
            <div class="modal-box">
                <i class="fa-solid fa-circle-xmark" style="color: #d9534f; font-size: 50px; margin-bottom: 15px;"></i>
                <h3 class="modal-title">Login Failed</h3>
                <p class="modal-text"><%= (errorMessage != null) ? errorMessage : ""%></p>
                <button class="btn-close" onclick="closeErrorModal()">Try Again</button>
            </div>
        </div>

        <script>
            // Password Toggle Script
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#password');

            togglePassword.addEventListener('click', function (e) {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });

            // Error Modal Script
            function closeErrorModal() {
                document.getElementById('errorModal').style.display = 'none';
            }

            // Auto-open modal if Java says there is an error
            <% if (hasError) { %>
            document.getElementById('errorModal').style.display = 'flex';
            <% }%>
        </script>

    </body>
</html>