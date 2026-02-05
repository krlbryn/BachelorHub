<%-- 
    Document   : studentViewWinner
    Created on : 1 Feb 2026, 1:08:14 am
    Author     : ParaNon
--%>

<%-- 
    Document   : studentViewWinner.jsp
    Description: Detailed winner view for a specific election
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
    
    String eIdParam = request.getParameter("electionId");
    if (eIdParam == null) {
        response.sendRedirect("studentResult.jsp");
        return;
    }
    int electionId = Integer.parseInt(eIdParam);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Winners</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentResult.css">
</head>

<body>
    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        
        <div style="margin-bottom: 20px;">
            <a href="studentResult.jsp" style="text-decoration: none; color: #555; font-weight: 600;">
                <i class="fa-solid fa-arrow-left"></i> Back to Election List
            </a>
        </div>

        <div class="result-container">
            <%
                Connection con = null;
                PreparedStatement pst = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.createConnection();
                    
                    // 1. Get Election Title
                    String titleSQL = "SELECT election_Title FROM election WHERE election_ID = ?";
                    pst = con.prepareStatement(titleSQL);
                    pst.setInt(1, electionId);
                    rs = pst.executeQuery();
                    String electionTitle = "";
                    if(rs.next()) electionTitle = rs.getString("election_Title");
                    rs.close(); pst.close();
            %>
            
            <div class="winner-header-block">
                <h1 style="margin:0; color:#333;"><i class="fa-solid fa-trophy" style="color:#ffc107;"></i> Official Results</h1>
                <h2 style="margin: 5px 0 0 0; color:#666; font-size: 1.2rem;"><%= electionTitle %></h2>
            </div>

            <div class="winner-grid">
            <%
                    // 2. Fetch Winners (Group by Position, Ordered by Votes)
                    String sql = "SELECT p.position_Name, c.cand_ID, c.cand_PhotoPath, s.stu_Name, " +
                                 "COUNT(v.vote_ID) as voteCount " +
                                 "FROM position p " +
                                 "JOIN candidate c ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) " +
                                 "JOIN student s ON c.stud_ID = s.stud_ID " +
                                 "LEFT JOIN vote v ON c.cand_ID = v.cand_ID " +
                                 "WHERE p.election_ID = ? " +
                                 "GROUP BY c.cand_ID " +
                                 "ORDER BY p.position_ID ASC, voteCount DESC";

                    pst = con.prepareStatement(sql);
                    pst.setInt(1, electionId);
                    rs = pst.executeQuery();

                    String currentPos = "";
                    boolean positionPrinted = false;

                    while (rs.next()) {
                        String posName = rs.getString("position_Name");
                        String sName = rs.getString("stu_Name");
                        int votes = rs.getInt("voteCount");
                        String photo = rs.getString("cand_PhotoPath");
                        if(photo == null || photo.isEmpty()) photo = "default_user.png";

                        // LOGIC: Only show the FIRST person for each position (The Winner)
                        if (!posName.equals(currentPos)) {
                            // This row is the winner because SQL sorted by DESC votes
            %>
                            <div class="winner-card-large">
                                <div class="winner-position-badge"><%= posName %></div>
                                <div class="crown-icon"><i class="fa-solid fa-crown"></i></div>
                                
                                <img src="<%= request.getContextPath() %>/images/<%= photo %>" class="winner-img">
                                <h3 class="winner-name"><%= sName %></h3>
                                <div class="winner-votes">
                                    <span><%= votes %></span> Votes
                                </div>
                            </div>
            <%
                            currentPos = posName;
                        }
                        // We ignore other candidates in the loop to show ONLY the winner
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception e){}
                    try { if(pst!=null) pst.close(); } catch(Exception e){}
                    try { if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
            </div>
        </div>
    </div>
</body>
</html>
