<%-- 
    Document   : create_election
    Created on : 12 Jan 2026, 9:23:26 am
    Author     : abgmn
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Create Election</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="sidebar">
        <div class="logo-area">⚙️ Admin</div>
        <div class="nav-group">
            <a href="#" class="nav-item active">➕ Create Election</a>
        </div>
        <div class="spacer"></div>
        <div class="nav-group"><a href="../dashboard.jsp" class="nav-item">🚪 Logout</a></div>
    </div>

    <div class="main-content">
        <h1 class="page-title" style="margin-bottom:20px;">Create New Election</h1>
        <div class="form-container">
            <form action="${pageContext.request.contextPath}/AddElectionServlets" method="POST">
                <div class="form-group">
                    <label>Title</label>
                    <input type="text" name="title" required>
                </div>
                <div class="form-group">
                    <label>Start Date</label>
                    <input type="date" name="start_date" required>
                </div>
                <div class="form-group">
                    <label>End Date</label>
                    <input type="date" name="end_date" required>
                </div>
                <button type="submit" class="btn-submit">Create Election</button>
            </form>
        </div>
    </div>
</body>
</html>
