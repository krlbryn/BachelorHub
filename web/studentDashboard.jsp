<%-- 
    Document   : studentDashboard
    Created on : 28 Jan 2026, 9:33:52 pm
    Author     : ParaNon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Check if user is actually logged in, if not, redirect to login
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
    <title>Student Dashboard - Coming Soon</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
</head>
<body>

    <div class="construction-card">
        <div class="icon-box">
            <i class="fa-solid fa-helmet-safety"></i>
        </div>
        
        <h1>Welcome, <%= userSession %>!</h1>
        
        <p>
            You have successfully logged in to the Student Area.<br>
            <strong>This module is currently under development.</strong><br>
            Please check back later when the voting system is live.
        </p>

        <a href="login.jsp" class="btn-logout">Logout</a>
    </div>

</body>
</html>