<%-- 
    Document   : studentResult.jsp
    Created on : 31 Jan 2026
    Author     : ParaNon (Fix)
--%>
<%-- 
    Document   : studentResult.jsp
    Description: Lists all elections with conditional buttons
--%>
<%@page import="java.sql.*, java.text.SimpleDateFormat"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("d MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Results</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentResult.css">
</head>

<body>
    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        <div class="header">
            <h1 class="welcome-text">Voting Results</h1>
            <p style="color:#666;">View winners for ended elections and track status.</p>
        </div>

        <div class="result-container">
            <div class="elections-grid-result">
            <%
                Connection con = null;
                Statement st = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.createConnection();
                    st = con.createStatement();
                    
                    // FETCH ALL ELECTIONS
                    String sql = "SELECT * FROM election ORDER BY election_Status = 'Active' DESC, election_ID DESC";
                    rs = st.executeQuery(sql);

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        int eID = rs.getInt("election_ID");
                        String title = rs.getString("election_Title");
                        String status = rs.getString("election_Status"); // Active, Ongoing, Ended
                        Timestamp endObj = rs.getTimestamp("election_EndDate");
                        String endDate = (endObj != null) ? sdf.format(endObj) : "TBA";
                        
                        // LOGIC: Button State
                        String btnClass = "btn-result-disabled";
                        String btnText = "Unavailable";
                        String btnLink = "#";
                        String icon = "fa-lock";

                        if ("Ended".equalsIgnoreCase(status) || "Closed".equalsIgnoreCase(status)) {
                            btnClass = "btn-result-view";
                            btnText = "View Winners";
                            btnLink = "studentViewWinner.jsp?electionId=" + eID;
                            icon = "fa-trophy";
                        } else if ("Active".equalsIgnoreCase(status)) {
                            btnText = "Voting Active";
                            icon = "fa-check-circle";
                        } else if ("Ongoing".equalsIgnoreCase(status)) {
                            btnText = "Election Ongoing";
                            icon = "fa-clock";
                        }
            %>
                    <div class="result-election-card">
                        <div class="card-status status-<%= status.toLowerCase() %>"><%= status %></div>
                        
                        <div class="card-icon-large">
                            <i class="fa-solid fa-square-poll-vertical"></i>
                        </div>
                        
                        <h3 class="res-title"><%= title %></h3>
                        <p class="res-date">Ends on: <%= endDate %></p>
                        
                        <a href="<%= btnLink %>" class="btn-res <%= btnClass %>">
                            <i class="fa-solid <%= icon %>"></i> <%= btnText %>
                        </a>
                    </div>
            <%
                    }
                    if (!hasData) {
            %>
                        <div class="no-data-msg">No elections found in the system.</div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception e){}
                    try { if(st!=null) st.close(); } catch(Exception e){}
                    try { if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
            </div>
        </div>
    </div>
</body>
</html>