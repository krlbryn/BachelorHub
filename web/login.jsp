<%-- 
    Document   : login
    Created on : 19 Jan 2026, 4:59:58 pm
    Author     : ParaNon
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Online Student Election - Login</title>
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
                <h2>Log In</h2>

                <%
                    String errorMessage = (String) request.getAttribute("errMessage");
                    if (errorMessage != null) {
                %>
                <div class="error-container">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <%= errorMessage%>
                </div>
                <% }%>

                <form action="LoginServlet" method="post">
                    <div class="input-group">
                        <label for="username">Username</label>
                        <input type="text" id="username" name="username" required placeholder="Enter your admin username">
                    </div>

                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required placeholder="Enter your password" style="padding-right: 40px;">
                        <i class="fa-solid fa-eye-slash toggle-password" id="togglePassword"></i>
                    </div>

                    <button type="submit" class="login-btn">Log In</button>

                    <div class="signup-text">
                        Not an admin? <a href="index.html">Go back home</a>
                    </div>
                </form>
            </div>

            <div class="footer-line"></div>
        </main>

        <script>
            const togglePassword = document.querySelector('#togglePassword');
            const password = document.querySelector('#password');

            togglePassword.addEventListener('click', function (e) {
                const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                password.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
        </script>
    </body>
</html>