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
    
    // 1. GET THE FILTER ID FROM URL
    String selectedElectionID = request.getParameter("electionId");
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
        <p class="header-subtitle">Preview candidates by election</p>

        <div class="filter-section">
            <form action="adminVotePage.jsp" method="get" style="display: flex; align-items: center; gap: 15px; width: 100%;">
                <label class="filter-label">Choose Election:</label>
                
                <select name="electionId" class="filter-select">
                    <option value="">-- Show All Elections --</option>
                    <%
                        // POPULATE DROPDOWN WITH ELECTIONS FROM DATABASE
                        Connection conDropdown = DBConnection.createConnection();
                        String sqlDropdown = "SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC";
                        Statement stDrop = conDropdown.createStatement();
                        ResultSet rsDrop = stDrop.executeQuery(sqlDropdown);
                        
                        while(rsDrop.next()) {
                            String eID = rsDrop.getString("election_ID");
                            String eTitle = rsDrop.getString("election_Title");
                            
                            // Check if this option was previously selected to keep it highlighted
                            String selected = (selectedElectionID != null && selectedElectionID.equals(eID)) ? "selected" : "";
                    %>
                        <option value="<%= eID %>" <%= selected %>><%= eTitle %></option>
                    <%
                        }
                        rsDrop.close();
                        // Note: We don't close connection yet because we need it for the next query, 
                        // or we can just use a new one. Let's use a new one below for clarity.
                    %>
                </select>
                
                <button type="submit" class="btn-filter">Filter</button>
            </form>
        </div>
        <div class="candidates-grid">

            <%
                try {
                    Connection con = DBConnection.createConnection();
                    
                    // BASE QUERY
                    String sql = "SELECT c.cand_ID, c.cand_PhotoPath, c.cand_ManifestoDesc, " +
                                 "s.stu_Name, p.position_Name " +
                                 "FROM candidate c " +
                                 "JOIN student s ON c.stud_ID = s.stud_ID " +
                                 "JOIN position p ON c.position_ID = p.position_ID ";
                    
                    // DYNAMIC FILTER LOGIC
                    if (selectedElectionID != null && !selectedElectionID.isEmpty()) {
                        sql += "WHERE p.election_ID = " + selectedElectionID + " ";
                    }
                    
                    sql += "ORDER BY p.position_ID ASC";
                    
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
                    <h3>No candidates found for this selection.</h3>
                    <p>Try changing the filter or add candidates in "Manage Candidates".</p>
                </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <p style="color:red">Error: <%= e.getMessage() %></p>
            <% } %>

        </div>
    </main>

</body>
</html>