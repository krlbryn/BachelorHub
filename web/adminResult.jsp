<%-- 
    Document   : adminResult
    Created on : 30 Jan 2026, 10:10:34 am
    Author     : ParaNon
--%>

<%-- Document : adminResult --%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String selectedElectionID = request.getParameter("electionId");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Voting Results</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminResult.css">
    </head>
    <body>

        <jsp:include page="adminNav.jsp" />

        <main class="main-content">
            <h1 class="header-title">Voting Results</h1>
            <p class="header-subtitle">Real-time vote counts and statistics</p>

            <div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; border: 1px solid #eee;">
                <form action="adminResult.jsp" method="get" style="display: flex; gap: 15px; align-items: center;">
                    <label style="font-weight: 600; color: #555;">Select Election:</label>
                    <select name="electionId" style="padding: 8px; border-radius: 5px; border: 1px solid #ddd;" onchange="this.form.submit()">
                        <option value="">-- View All --</option>
                        <%
                            Connection conDrop = DBConnection.createConnection();
                            ResultSet rsDrop = conDrop.createStatement().executeQuery("SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC");
                            while (rsDrop.next()) {
                                String eID = rsDrop.getString("election_ID");
                                String sel = (selectedElectionID != null && selectedElectionID.equals(eID)) ? "selected" : "";
                        %>
                        <option value="<%= eID%>" <%= sel%>><%= rsDrop.getString("election_Title")%></option>
                        <% }
                        rsDrop.close(); %>
                    </select>
                </form>
            </div>

            <div class="content-wrapper">
                <%
                    try {
                        Connection con = DBConnection.createConnection();

                        // FIXED SQL QUERY:
                        // 1. Joins 'candidate_Position' (String) to 'position_Name' (String)
                        // 2. Joins 'election_ID' to ensure we don't mix up elections
                        String sql = "SELECT c.cand_ID, c.cand_PhotoPath, s.stu_Name, "
                                + "p.position_Name, p.position_ID, "
                                + "e.election_Title, e.election_ID, e.election_Status, "
                                + "COUNT(v.vote_ID) as voteCount "
                                + "FROM candidate c "
                                + "JOIN student s ON c.stud_ID = s.stud_ID "
                                + "JOIN election e ON c.election_ID = e.election_ID "
                                + // THE KEY FIX IS HERE:
                                "JOIN position p ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) "
                                + "LEFT JOIN vote v ON c.cand_ID = v.cand_ID "
                                + "WHERE 1=1 ";

                        if (selectedElectionID != null && !selectedElectionID.isEmpty()) {
                            sql += "AND p.election_ID = " + selectedElectionID + " ";
                        }

                        sql += "GROUP BY c.cand_ID ";
                        // Sort by Election -> Position Rank -> Highest Votes (Winner)
                        sql += "ORDER BY e.election_ID DESC, p.position_ID ASC, voteCount DESC";

                        Statement st = con.createStatement();
                        ResultSet rs = st.executeQuery(sql);

                        int currentElectionID = -1;
                        int currentPositionID = -1;
                        boolean firstPass = true;
                        boolean hasData = false;

                        // Winner Tracker
                        boolean isFirstInPosition = false;

                        while (rs.next()) {
                            hasData = true;
                            int eID = rs.getInt("election_ID");
                            int pID = rs.getInt("position_ID");

                            String eTitle = rs.getString("election_Title");
                            String eStatus = rs.getString("election_Status");
                            String pName = rs.getString("position_Name");

                            String name = rs.getString("stu_Name");
                            String photo = rs.getString("cand_PhotoPath");
                            int votes = rs.getInt("voteCount");

                            if (photo == null || photo.isEmpty()) {
                                photo = "default.png";
                            }

                            // 1. ELECTION CHANGE
                            if (eID != currentElectionID) {
                                if (!firstPass) {
                                    out.println("</div></div></div>");
                                }

                                String badgeColor = "#6c757d";
                                if ("Active".equalsIgnoreCase(eStatus))
                                    badgeColor = "#198754";
                                else if ("Ongoing".equalsIgnoreCase(eStatus))
                                    badgeColor = "#0d6efd";
                %>
                <div class="election-section">
                    <div class="election-header">
                        <span class="election-title"><%= eTitle%></span>
                        <span class="election-status-badge" style="background-color: <%= badgeColor%>20; color: <%= badgeColor%>;">
                            <%= eStatus%>
                        </span>
                    </div>
                    <%
                            currentElectionID = eID;
                            currentPositionID = -1;
                        }

                        // 2. POSITION CHANGE
                        if (pID != currentPositionID) {
                            if (currentPositionID != -1)
                                out.println("</div></div>");
                    %>
                    <div class="position-group">
                        <div class="position-header"><%= pName%></div>
                        <div class="group-grid">
                            <%
                                    currentPositionID = pID;
                                    isFirstInPosition = true; // Reset winner flag for new position
                                }

                                // Determine visual style (Winner gets gold border if votes > 0)
                                String cardClass = "result-card";
                                String badgeHTML = "";

                                if (isFirstInPosition && votes > 0) {
                                    cardClass += " winner";
                                    badgeHTML = "<div style='color:#ffc107; font-size:1.2rem; margin-bottom:5px;'><i class='fa-solid fa-crown'></i></div>";
                                }
                                isFirstInPosition = false; // Next person in loop is not first
%>
                            <div class="<%= cardClass%>">
                                <%= badgeHTML%>
                                <div class="card-img-wrapper">
                                    <img src="images/<%= photo%>" alt="<%= name%>">
                                </div>
                                <h3 class="cand-name"><%= name%></h3>

                                <div class="vote-stat">
                                    <span class="vote-number"><%= votes%></span>
                                    <span class="vote-label">Votes</span>
                                </div>
                            </div>
                            <%
                                    firstPass = false;
                                }

                                if (hasData) {
                                    out.println("</div></div></div>");
                                } else {
                            %>
                            <div style="text-align:center; padding:50px; background:white; border-radius:10px;">
                                <i class="fa-solid fa-chart-pie" style="font-size: 3rem; color: #ccc;"></i>
                                <h3 style="color:#666; margin-top:15px;">No results found.</h3>
                            </div>
                            <%
                                    }
                                    con.close();
                                    conDrop.close();
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </div>
                        </main>

                        </body>
                        </html>