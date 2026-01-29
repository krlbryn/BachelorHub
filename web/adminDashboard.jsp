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

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Dashboard</h1>
        <p class="header-subtitle">Welcome back, <%= userSession%>!</p>

        <div style="padding: 20px; border: 2px dashed #ccc; border-radius: 10px; color: #777; text-align: center;">
            <i class="fa-solid fa-hammer" style="font-size: 30px; margin-bottom: 10px;"></i><br>
            Content Area Ready
        </div>
    </main>

</body>
</html>