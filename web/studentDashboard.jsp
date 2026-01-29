<%-- Document : studentDashboard --%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
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
        <title>Student Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    </head>

    <body>

        <jsp:include page="studentNav.jsp" />

        <div class="main-content">
            <div class="header">
                <h1 class="welcome-text">Student Dashboard</h1>
                <div class="logo-circle">Logo</div>
            </div>

            <div class="content-body">
                <div style="background: white; padding: 40px; border-radius: 10px; text-align: center; box-shadow: var(--card-shadow);">
                    <i class="fa-solid fa-person-booth" style="font-size: 60px; color: var(--primary-color); margin-bottom: 20px;"></i>

                    <h2 style="margin-bottom: 15px;">Welcome, <%= userSession%>!</h2>

                    <p style="color: #666; margin-bottom: 30px; font-size: 16px;">
                        This is your central hub for the student election system.<br>
                        To view available elections and cast your vote, please navigate to the
                        <strong>Vote</strong> page.
                    </p>

                    <a href="studentVote.jsp" class="btn-vote" style="text-decoration: none; display: inline-block; width: auto; padding: 12px 30px;">
                        Go to Vote
                    </a>
                </div>
            </div>
        </div>

    </body>
</html>