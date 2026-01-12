<%-- 
    Document   : studentDashboard
    Created on : 12 Jan 2026, 9:21:10 am
    Author     : abgmn
--%>

<%@page import="java.sql.*, com.election.utils.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="sidebar">
        <div class="logo-area">🗳️ E-Voting</div>
        <div class="nav-group">
            <a href="dashboard.jsp" class="nav-item active">▣ Dashboard</a>
            <a href="dashboard.jsp" class="nav-item">📄 Vote</a>
        </div>
        <div class="spacer"></div>
        <div class="nav-group"><a href="#" class="nav-item">🚪 Sign Out</a></div>
    </div>

    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Available Elections</h1>
            <div style="background:white; padding:10px; border-radius:50%;">Logo</div>
        </div>

        <div class="election-grid">
            <% 
                Connection con = DBConnection.getConnection();
                String sql = "SELECT * FROM elections";
                PreparedStatement pst = con.prepareStatement(sql);
                ResultSet rs = pst.executeQuery();
                while(rs.next()) {
            %>
            <div class="card">
                <div class="card-image">🌄</div>
                <h3><%= rs.getString("title") %></h3>
                <p style="margin-bottom:15px; color:#555">
                    Start: <%= rs.getString("start_date") %><br>
                    End: <%= rs.getString("end_date") %>
                </p>
                <button class="btn-view" onclick="location.href='vote_page.jsp?id=<%= rs.getString("id") %>'">View Candidates & Vote</button>
            </div>
            <% } con.close(); %>
        </div>
    </div>
</body>
</html>
