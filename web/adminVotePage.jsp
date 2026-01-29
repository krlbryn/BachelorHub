<%-- 
    Document   : adminVotePage
    Created on : 29 Jan 2026, 10:55:39 am
    Author     : ParaNon
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
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
    <title>Voting Page Preview</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminVotePage.css">
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Voting Page</h1>
        <p class="header-subtitle">Preview of active candidates</p>

        <div class="candidates-grid">

            <%
                try {
                    Connection con = DBConnection.createConnection();
                    String sql = "SELECT c.cand_ID, c.cand_PhotoPath, c.cand_ManifestoDesc, " +
                                 "s.stu_Name, p.position_Name " +
                                 "FROM candidate c " +
                                 "JOIN student s ON c.stud_ID = s.stud_ID " +
                                 "JOIN position p ON c.position_ID = p.position_ID " +
                                 "ORDER BY p.position_ID ASC";
                    
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);

                    boolean hasCandidates = false;
                    while (rs.next()) {
                        hasCandidates = true;
                        String name = rs.getString("stu_Name");
                        String position = rs.getString("position_Name");
                        String photo = rs.getString("cand_PhotoPath");
                        String manifesto = rs.getString("cand_ManifestoDesc");
                        
                        if(photo == null || photo.isEmpty()) photo = "default.png";
            %>

                <div class="candidate-card">
                    <div class="position-badge"><%= position %></div>
                    
                    <div class="card-img-wrapper">
                        <img src="images/<%= photo %>" alt="<%= name %>">
                    </div>
                    
                    <h3 class="cand-name"><%= name %></h3>
                    <p class="cand-manifesto">"<%= manifesto %>"</p>
                    
                    <button class="btn-vote" onclick="alert('Voting is simulated for Admins.')">Vote</button>
                </div>

            <% 
                    }
                    if (!hasCandidates) {
            %>
                <div class="no-data">
                    <h3>No candidates found.</h3>
                    <p>Go to "Manage Candidates" to add someone first.</p>
                </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <p style="color:red">Error loading candidates: <%= e.getMessage() %></p>
            <% } %>

        </div>
    </main>

</body>
</html>