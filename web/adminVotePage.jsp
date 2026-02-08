<%-- 
    Document   : adminVotePage
    Updated on : Feb 08, 2026
    Description: Candidate Preview with iVOTE Theme & Filters
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

    // 1. GET FILTERS
    String selectedElectionID = request.getParameter("electionId");
    String selectedStatus = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voting Page Preview | ElectVote Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* --- iVOTE THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-secondary: #4A90E2;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
            --ev-success: #00c853;
            --ev-danger: #ff1744;
            --ev-warning: #ffc107;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--ev-bg);
            color: var(--ev-text);
            padding-left: 260px; /* Sidebar Width */
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- PAGE HEADER --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        .header-subtitle { color: var(--ev-muted); font-size: 14px; margin: 0; }

        /* --- FILTER BAR (Card Style) --- */
        .filter-bar {
            background: var(--ev-card);
            padding: 20px 25px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            display: flex;
            align-items: flex-end; /* Align inputs to bottom */
            gap: 20px;
            margin-bottom: 30px;
            border: 1px solid #E8EEF3;
        }

        .filter-group { display: flex; flex-direction: column; gap: 8px; }
        .filter-label { font-weight: 600; color: var(--ev-text); font-size: 13px; }
        
        .filter-select {
            padding: 10px 15px;
            border-radius: 10px;
            border: 2px solid #E8EEF3;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: #1a1a3d;
            background-color: #F9FBFD;
            transition: 0.3s;
            height: 45px; /* Consistent height */
            box-sizing: border-box;
        }
        .filter-select:focus { outline: none; border-color: var(--ev-primary); background: white; }

        .btn-reset {
            padding: 10px 20px;
            color: var(--ev-muted);
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            border-radius: 10px;
            background: #F4F7FE;
            transition: 0.2s;
            height: 45px;
            display: flex; align-items: center;
        }
        .btn-reset:hover { background: #E8EEF3; color: var(--ev-text); }

        /* --- ELECTION SECTIONS --- */
        .election-section {
            margin-bottom: 40px;
            animation: fadeIn 0.5s ease-out;
        }

        .election-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #E8EEF3;
        }

        .election-title { font-size: 20px; font-weight: 700; color: var(--ev-primary); }
        
        .election-status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        /* --- POSITION GROUPS --- */
        .position-group { margin-bottom: 25px; }
        .position-header {
            font-size: 16px;
            font-weight: 600;
            color: var(--ev-text);
            margin-bottom: 15px;
            padding-left: 10px;
            border-left: 4px solid var(--ev-secondary);
        }

        /* --- CANDIDATE CARDS --- */
        .group-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
        }

        .candidate-card {
            background: var(--ev-card);
            border-radius: 16px;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(30, 86, 160, 0.15);
            border-color: rgba(74, 144, 226, 0.3);
        }

        .card-img-wrapper img {
            width: 90px; height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #F4F7FE;
            margin-bottom: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .position-badge {
            display: inline-block;
            background: rgba(74, 144, 226, 0.1);
            color: var(--ev-secondary);
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 12px;
            margin-bottom: 10px;
        }

        .cand-name { font-size: 16px; font-weight: 700; color: #1a1a3d; margin: 0 0 5px; }
        .cand-manifesto { font-size: 13px; color: #5F6D7E; font-style: italic; line-height: 1.4; margin-bottom: 15px; height: 36px; overflow: hidden; }

        .btn-vote {
            width: 100%;
            padding: 10px;
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: default; /* Disabled for admin preview */
            opacity: 0.7;
        }
        
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Empty States */
        .no-data { text-align: center; padding: 60px; color: var(--ev-muted); background: white; border-radius: 16px; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Voting Page Preview</h1>
            <p class="header-subtitle">View candidates exactly as students will see them, organized by Election and Position.</p>
        </div>

        <div class="filter-bar">
            <form action="adminVotePage.jsp" method="get" style="display: contents;">

                <div class="filter-group" style="flex-grow: 1;">
                    <label class="filter-label">Search Candidate</label>
                    <div style="position: relative;">
                        <i class="fa-solid fa-magnifying-glass" style="position: absolute; left: 15px; top: 14px; color: #8A92A6;"></i>
                        <input type="text" id="searchInput" class="filter-select" style="width: 100%; padding-left: 40px;" 
                               placeholder="Type name to filter list..." onkeyup="liveSearch()">
                    </div>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Election</label>
                    <select name="electionId" class="filter-select" onchange="this.form.submit()" style="min-width: 200px;">
                        <option value="">All Elections</option>
                        <%
                            Connection conDrop = DBConnection.createConnection();
                            ResultSet rsDrop = conDrop.createStatement().executeQuery("SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC");
                            while (rsDrop.next()) {
                                String eID = rsDrop.getString("election_ID");
                                String sel = (selectedElectionID != null && selectedElectionID.equals(eID)) ? "selected" : "";
                        %>
                        <option value="<%= eID%>" <%= sel%>><%= rsDrop.getString("election_Title")%></option>
                        <% } rsDrop.close();%>
                    </select>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Status</label>
                    <select name="status" class="filter-select" style="min-width: 130px;" onchange="this.form.submit()">
                        <option value="">All Status</option>
                        <option value="Active" <%= "Active".equals(selectedStatus) ? "selected" : ""%>>Active</option>
                        <option value="Ongoing" <%= "Ongoing".equals(selectedStatus) ? "selected" : ""%>>Ongoing</option>
                        <option value="Closed" <%= "Closed".equals(selectedStatus) ? "selected" : ""%>>Closed</option>
                    </select>
                </div>

                <a href="adminVotePage.jsp" class="btn-reset">
                    <i class="fa-solid fa-rotate-left" style="margin-right: 8px;"></i> Reset
                </a>
            </form>
        </div>

        <div class="content-wrapper" id="candidateList">
            <%
                try {
                    Connection con = DBConnection.createConnection();

                    // QUERY: Fetches Candidates linked to Election & Position
                    String sql = "SELECT c.cand_ID, c.cand_PhotoPath, c.cand_ManifestoDesc, "
                            + "s.stu_Name, p.position_Name, p.position_ID, e.election_Title, e.election_ID, e.election_Status "
                            + "FROM candidate c "
                            + "JOIN student s ON c.stud_ID = s.stud_ID "
                            + "JOIN election e ON c.election_ID = e.election_ID "
                            + "JOIN position p ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) "
                            + "WHERE 1=1 ";

                    if (selectedElectionID != null && !selectedElectionID.isEmpty()) {
                        sql += "AND e.election_ID = " + selectedElectionID + " ";
                    }
                    if (selectedStatus != null && !selectedStatus.isEmpty()) {
                        sql += "AND e.election_Status = '" + selectedStatus + "' ";
                    }

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
                        if (photo == null || photo.isEmpty()) photo = "default.png";

                        // --- START ELECTION SECTION ---
                        if (eID != currentElectionID) {
                            if (!firstPass) {
                                out.println("</div></div></div>"); // Close previous candidate-card, group-grid, election-section
                            }

                            String badgeColor = "#8A92A6"; // Default gray
                            String badgeBg = "rgba(138, 146, 166, 0.1)";
                            
                            if ("Active".equalsIgnoreCase(eStatus)) { badgeColor = "#00c853"; badgeBg = "rgba(0, 200, 83, 0.1)"; }
                            else if ("Ongoing".equalsIgnoreCase(eStatus)) { badgeColor = "#007bff"; badgeBg = "rgba(0, 123, 255, 0.1)"; }
                            else if ("Closed".equalsIgnoreCase(eStatus)) { badgeColor = "#ff1744"; badgeBg = "rgba(255, 23, 68, 0.1)"; }
            %>
            <div class="election-section">
                <div class="election-header">
                    <span class="election-title"><%= eTitle%></span>
                    <span class="election-status-badge" style="background-color: <%= badgeBg%>; color: <%= badgeColor%>;">
                        <%= eStatus%>
                    </span>
                </div>
            <%
                        currentElectionID = eID;
                        currentPositionID = -1;
                    }

                    // --- START POSITION GROUP ---
                    if (pID != currentPositionID) {
                        if (currentPositionID != -1) {
                            out.println("</div></div>"); // Close previous group-grid, position-group
                        }
            %>
                <div class="position-group">
                    <div class="position-header"><%= pName%></div>
                    <div class="group-grid">
            <%
                        currentPositionID = pID;
                    }
            %>
                        <div class="candidate-card">
                            <span class="position-badge"><%= pName%></span>
                            <div class="card-img-wrapper">
                                <img src="images/<%= photo%>" alt="<%= name%>">
                            </div>
                            <h3 class="cand-name"><%= name%></h3>
                            <p class="cand-manifesto">"<%= manifesto%>"</p>
                            <button class="btn-vote">Preview Vote</button>
                        </div>
            <%
                        firstPass = false;
                    }

                    if (hasData) {
                        out.println("</div></div></div>"); // Close final tags
                    } else {
            %>
                <div class="no-data">
                    <i class="fa-solid fa-folder-open" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                    <h3>No candidates found.</h3>
                    <p>Try changing the filters or adding candidates.</p>
                </div>
            <%
                    }
                    con.close();
                    conDrop.close();
                } catch (Exception e) { e.printStackTrace(); }
            %>
        </div>

        <div id="noSearchResults" style="display:none; text-align:center; padding:60px;">
            <i class="fa-solid fa-magnifying-glass" style="font-size: 3rem; color: #ccc; margin-bottom: 15px;"></i>
            <h3 style="color:#555;">No matches found.</h3>
        </div>

    </main>

    <script>
        function liveSearch() {
            let input = document.getElementById("searchInput").value.toLowerCase();
            let wrapper = document.getElementById("candidateList");
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
                        if (name.includes(input)) {
                            card.style.display = "";
                            groupHasVisibleCandidates = true;
                            sectionHasVisibleCandidates = true;
                            totalVisible++;
                        } else {
                            card.style.display = "none";
                        }
                    }

                    group.style.display = groupHasVisibleCandidates ? "" : "none";
                }
                section.style.display = sectionHasVisibleCandidates ? "" : "none";
            }

            let noResultMsg = document.getElementById("noSearchResults");
            noResultMsg.style.display = (totalVisible === 0) ? "block" : "none";
        }
    </script>

</body>
</html>