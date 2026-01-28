<%-- 
    Document   : login
    Created on : 19 Jan 2026, 4:59:58 pm
    Author     : ParaNon
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Online Student Election</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&family=UnifrakturMaguntia&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="css/login.css">
    </head>
    <body>

        <header>
            <div class="dots">ooo</div>
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
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <%= errorMessage%>
                </div>
                <% }%>
                <form action="LoginServlet" method="post">
                    <form action="LoginServlet" method="post">
                        <div class="input-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required>
                        </div>
                        <div class="input-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                            <i class="fa-solid fa-eye-slash toggle-password"></i>
                        </div>
                        <button type="submit" class="login-btn">Log In</button>
                        <div class="signup-text">
                            or <a href="signup.jsp" style="color: #333; text-decoration: underline;">Sign up</a>
                        </div>
                    </form>
            </div>
            <div class="footer-line"></div>
            <div class="bottom-logo">🧠</div>
        </main>
    </body>
</html>