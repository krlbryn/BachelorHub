<%-- 
    Document   : adminVotePage
    Created on : 29 Jan 2026, 10:55:39 am
    Author     : ParaNon
--%>

<%-- Document : adminVotePage --%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 1. GET FILTERS (Election & Status only)
    // We removed the SQL 'search' logic so the JS can handle the text filtering on the client side
    String selectedElectionID = request.getParameter("electionId");
    String selectedStatus = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voting Page</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminVotePage.css">
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Voting Page</h1>
        <p class="header-subtitle">Preview candidates organized by Election and Position</p>

        <div class="filter-bar">
            <form action="adminVotePage.jsp" method="get" style="display: contents;">
                
                <div class="filter-group" style="flex-grow: 1;">
                    <label class="filter-label">Search Candidate</label>
                    <div style="position: relative;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 12px; top: 13px; color: #999;"></i>
                        <input type="text" id="searchInput" class="filter-select" style="width: 100%; padding-left: 35px;" 
                               placeholder="Type name to auto-search..." onkeyup="liveSearch()">
                    </div>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Election</label>
                    <select name="electionId" class="filter-select" onchange="this.form.submit()">
                        <option value="">All Elections</option>
                        <%
                            Connection conDrop = DBConnection.createConnection();
                            ResultSet rsDrop = conDrop.createStatement().executeQuery("SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC");
                            while(rsDrop.next()) {
                                String eID = rsDrop.getString("election_ID");
                                String sel = (selectedElectionID != null && selectedElectionID.equals(eID)) ? "selected" : "";
                        %>
                            <option value="<%= eID %>" <%= sel %>><%= rsDrop.getString("election_Title") %></option>
                        <% } rsDrop.close(); %>
                    </select>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Status</label>
                    <select name="status" class="filter-select" style="min-width: 130px;" onchange="this.form.submit()">
                        <option value="">All</option>
                        <option value="Active" <%= "Active".equals(selectedStatus) ? "selected" : "" %>>Active</option>
                        <option value="Ongoing" <%= "Ongoing".equals(selectedStatus) ? "selected" : "" %>>Ongoing</option>
                        <option value="Closed" <%= "Closed".equals(selectedStatus) ? "selected" : "" %>>Closed</option>
                    </select>
                </div>
                
                <a href="adminVotePage.jsp" class="btn-reset">Reset</a>
            </form>
        </div>

        <div class="content-wrapper" id="candidateList">
            <%
                try {
                    Connection con = DBConnection.createConnection();
                    
                    String sql = "SELECT c.cand_ID, c.cand_PhotoPath, c.cand_ManifestoDesc, " +
                                 "s.stu_Name, p.position_Name, p.position_ID, e.election_Title, e.election_ID, e.election_Status " +
                                 "FROM candidate c " +
                                 "JOIN student s ON c.stud_ID = s.stud_ID " +
                                 "JOIN position p ON c.position_ID = p.position_ID " +
                                 "JOIN election e ON p.election_ID = e.election_ID " +
                                 "WHERE 1=1 "; 
                    
                    if (selectedElectionID != null && !selectedElectionID.isEmpty()) sql += "AND p.election_ID = " + selectedElectionID + " ";
                    if (selectedStatus != null && !selectedStatus.isEmpty()) sql += "AND e.election_Status = '" + selectedStatus + "' ";
                    
                    sql += "ORDER BY e.election_ID DESC, p.position_ID ASC";
                    
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);

                    int currentElectionID = -1;
                    int currentPositionID = -1;
                    boolean firstPass = true;
                    boolean hasData = false;

                    while (rs.next()) {
                        hasData = true;
                        int eID = rs.getInt("election_ID");
                        int pID = rs.getInt("position_ID");
                        String eTitle = rs.getString("election_Title");
                        String eStatus = rs.getString("election_Status");
                        String pName = rs.getString("position_Name");
                        
                        String name = rs.getString("stu_Name");
                        String photo = rs.getString("cand_PhotoPath");
                        String manifesto = rs.getString("cand_ManifestoDesc");
                        if(photo == null || photo.isEmpty()) photo = "default.png";

                        // ELECTION SECTION START
                        if (eID != currentElectionID) {
                            if (!firstPass) out.println("</div></div></div>");
                            
                            String badgeColor = "#6c757d";
                            if("Active".equalsIgnoreCase(eStatus)) badgeColor = "#198754";
                            else if("Ongoing".equalsIgnoreCase(eStatus)) badgeColor = "#0d6efd";
            %>
                            <div class="election-section">
                                <div class="election-header">
                                    <span class="election-title"><%= eTitle %></span>
                                    <span class="election-status-badge" style="background-color: <%= badgeColor %>20; color: <%= badgeColor %>;">
                                        <%= eStatus %>
                                    </span>
                                </div>
            <%
                            currentElectionID = eID;
                            currentPositionID = -1; 
                        }

                        // POSITION GROUP START
                        if (pID != currentPositionID) {
                            if (currentPositionID != -1) out.println("</div></div>");
            %>
                            <div class="position-group">
                                <div class="position-header"><%= pName %></div>
                                <div class="group-grid">
            <%
                            currentPositionID = pID;
                        }
            %>
                        <div class="candidate-card">
                            <div style="margin-bottom:10px;">
                                <span class="position-badge" style="width: 100%; display: block; text-align: center;"><%= pName %></span>
                            </div>
                            <div class="card-img-wrapper">
                                <img src="images/<%= photo %>" alt="<%= name %>">
                            </div>
                            <h3 class="cand-name"><%= name %></h3>
                            <p class="cand-manifesto">"<%= manifesto %>"</p>
                            <button class="btn-vote">Vote</button>
                        </div>
            <%
                        firstPass = false;
                    } 

                    if (hasData) {
                        out.println("</div></div></div>"); 
                    } else {
            %>
                        <div class="no-data" style="text-align:center; padding:50px; background:white; border-radius:10px;">
                            <i class="fa-solid fa-folder-open" style="font-size: 3rem; color: #ccc;"></i>
                            <h3 style="color:#666; margin-top:15px;">No candidates found.</h3>
                        </div>
            <%
                    }
                    con.close();
                    conDrop.close();
                } catch (Exception e) { e.printStackTrace(); }
            %>
        </div>
        
        <div id="noSearchResults" style="display:none; text-align:center; padding:40px;">
            <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: #ccc; margin-bottom: 15px;"></i>
            <h3 style="color:#555;">No matches found.</h3>
        </div>

    </main>

    <script>
        function liveSearch() {
            // 1. Get typed text
            let input = document.getElementById("searchInput").value.toLowerCase();
            let wrapper = document.getElementById("candidateList");
            
            // 2. Get all major sections
            let sections = wrapper.getElementsByClassName("election-section");
            let totalVisible = 0;

            for (let section of sections) {
                let sectionHasVisibleCandidates = false;
                let groups = section.getElementsByClassName("position-group");

                for (let group of groups) {
                    let groupHasVisibleCandidates = false;
                    let cards = group.getElementsByClassName("candidate-card");

                    for (let card of cards) {
                        let name = card.querySelector(".cand-name").innerText.toLowerCase();
                        
                        // Check if name matches
                        if (name.includes(input)) {
                            card.style.display = ""; // Show
                            groupHasVisibleCandidates = true;
                            sectionHasVisibleCandidates = true;
                            totalVisible++;
                        } else {
                            card.style.display = "none"; // Hide
                        }
                    }

                    // Toggle Group Visibility
                    if (groupHasVisibleCandidates) {
                        group.style.display = "";
                    } else {
                        group.style.display = "none";
                    }
                }

                // Toggle Section Visibility
                if (sectionHasVisibleCandidates) {
                    section.style.display = "";
                } else {
                    section.style.display = "none";
                }
            }
            
            // Show "No Results" message if everything is hidden
            let noResultMsg = document.getElementById("noSearchResults");
            if (totalVisible === 0) {
                noResultMsg.style.display = "block";
            } else {
                noResultMsg.style.display = "none";
            }
        }
    </script>

</body>
</html>