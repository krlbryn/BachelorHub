<%-- 
    Document   : adminCreateElection
    Created on : Jan 29, 2026, 1:35:44 PM
    Author     : Karl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Create New Election</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminProfile.css">
    
    <style>
        /* Reusing profile styles, but adding specific adjustments */
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #333; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 5px; font-size: 1rem; }
        
        .btn-create { background-color: #007bff; color: white; padding: 12px 25px; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; }
        .btn-create:hover { background-color: #0056b3; }
        
        .btn-cancel { background-color: #6c757d; color: white; text-decoration: none; padding: 12px 25px; border-radius: 5px; }
        .btn-cancel:hover { background-color: #5a6268; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">New Election Event</h1>
        <p class="header-subtitle">Set up a new voting event for students</p>

        <div class="profile-container">
            <div class="decoration-line"></div>
            
            <div class="info-section">
                <form action="adminCreateElectionAction.jsp" method="post">
                    
                    <div class="form-group">
                        <label>Election Title</label>
                        <input type="text" name="eName" class="form-control" placeholder="Ex: SRC Election 2026" required>
                    </div>

                    <div class="form-group">
                        <label>Election Date</label>
                        <input type="date" name="eDate" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Initial Status</label>
                        <select name="eStatus" class="form-control">
                            <option value="Upcoming">Upcoming (Not visible to students yet)</option>
                            <option value="Active">Active (Live voting)</option>
                            <option value="Closed">Closed (Ended)</option>
                        </select>
                    </div>

                    <div class="divider"></div>

                    <br>
                    <div style="display: flex; gap: 10px;">
                        <button type="submit" class="btn-create">
                            <i class="fa-solid fa-check"></i> Create Event
                        </button>
                        <a href="adminElection.jsp" class="btn-cancel">Cancel</a>
                    </div>
                    
                </form>
            </div>
        </div>
    </main>

</body>
</html>
