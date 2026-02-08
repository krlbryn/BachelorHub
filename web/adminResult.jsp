<%-- 
    Document   : adminResult
    Updated on : Feb 08, 2026
    Description: Election Results & Reports with Theme
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
    String selectedElectionID = request.getParameter("electionId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Voting Results | ElectVote Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <style>
        /* --- iVOTE THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
            --gold: #FFD700;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--ev-bg);
            color: var(--ev-text);
            padding-left: 260px;
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- HEADER --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        .header-subtitle { color: var(--ev-muted); font-size: 14px; margin: 0; }

        /* --- FILTER BAR --- */
        .filter-bar {
            background: var(--ev-card);
            padding: 15px 25px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 30px;
            border: 1px solid #E8EEF3;
        }
        
        .filter-select {
            padding: 10px 15px;
            border-radius: 10px;
            border: 2px solid #E8EEF3;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: #1a1a3d;
            min-width: 300px;
            background-color: #F9FBFD;
        }

        /* --- STATUS BANNERS --- */
        .action-banner {
            border-radius: 12px;
            padding: 20px 25px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            animation: fadeIn 0.5s ease-out;
        }
        
        .banner-finalize { background: #FFF8E1; border: 1px solid #FFECB3; color: #856404; }
        .banner-success { background: #E8F5E9; border: 1px solid #C8E6C9; color: #1B5E20; }

        .btn-action {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-family: 'Poppins', sans-serif;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.2s;
            font-size: 14px;
        }
        
        .btn-gold { background: #FFC107; color: #000; }
        .btn-gold:hover { background: #FFB300; }
        
        .btn-blue { background: var(--ev-primary); color: white; }
        .btn-blue:hover { background: #154585; }
        
        .btn-red { background: #FF1744; color: white; }
        .btn-red:hover { background: #D50000; }

        /* --- RESULTS GRID --- */
        .election-section { margin-bottom: 40px; }
        .election-header {
            display: flex; align-items: center; gap: 15px;
            border-bottom: 2px solid #E8EEF3;
            padding-bottom: 10px; margin-bottom: 20px;
        }
        .election-title { font-size: 20px; font-weight: 700; color: var(--ev-primary); }
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; }

        .position-group { margin-bottom: 30px; }
        .position-title { font-size: 16px; font-weight: 600; color: #1a1a3d; margin-bottom: 15px; padding-left: 10px; border-left: 4px solid var(--ev-primary); }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 25px;
        }

        /* --- CANDIDATE RESULT CARD --- */
        .result-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            position: relative;
            overflow: hidden;
        }

        /* Winner Styling */
        .result-card.winner {
            border: 2px solid var(--gold);
            background: linear-gradient(180deg, #FFFCF2 0%, #FFFFFF 100%);
            box-shadow: 0 10px 30px rgba(255, 215, 0, 0.15);
        }
        
        .crown-icon {
            position: absolute;
            top: 15px; right: 15px;
            color: var(--gold);
            font-size: 20px;
            filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
            animation: float 3s ease-in-out infinite;
        }

        .cand-img {
            width: 80px; height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #F4F7FE;
            margin-bottom: 15px;
        }
        .winner .cand-img { border-color: var(--gold); }

        .cand-name { font-size: 16px; font-weight: 700; color: #1a1a3d; margin: 0 0 5px; }
        
        .vote-stat { margin-top: 15px; }
        .vote-count { font-size: 28px; font-weight: 700; color: var(--ev-primary); line-height: 1; }
        .vote-label { font-size: 12px; color: var(--ev-muted); text-transform: uppercase; letter-spacing: 1px; }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-5px); } }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Voting Results</h1>
            <p class="header-subtitle">View live vote counts, finalize outcomes, and export reports.</p>
        </div>

        <div class="filter-bar">
            <label style="font-weight: 600; color: #1a1a3d;">Select Election:</label>
            <form action="adminResult.jsp" method="get" style="margin: 0;">
                <select name="electionId" class="filter-select" onchange="this.form.submit()">
                    <option value="">-- View All Elections --</option>
                    <%
                        Connection conDrop = DBConnection.createConnection();
                        ResultSet rsDrop = conDrop.createStatement().executeQuery("SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC");
                        while (rsDrop.next()) {
                            String eID = rsDrop.getString("election_ID");
                            String sel = (selectedElectionID != null && selectedElectionID.equals(eID)) ? "selected" : "";
                    %>
                    <option value="<%= eID%>" <%= sel%>><%= rsDrop.getString("election_Title")%></option>
                    <% } rsDrop.close(); %>
                </select>
            </form>
        </div>

        <%
            if (selectedElectionID != null && !selectedElectionID.isEmpty()) {
                PreparedStatement psStatus = conDrop.prepareStatement("SELECT election_Status FROM election WHERE election_ID = ?");
                psStatus.setString(1, selectedElectionID);
                ResultSet rsStatus = psStatus.executeQuery();

                PreparedStatement psCheck = conDrop.prepareStatement("SELECT COUNT(*) FROM electionresult WHERE election_ID = ?");
                psCheck.setString(1, selectedElectionID);
                ResultSet rsRes = psCheck.executeQuery();
                
                int resultsExist = 0;
                if(rsRes.next()) resultsExist = rsRes.getInt(1);

                if (rsStatus.next()) {
                    String statusValue = rsStatus.getString("election_Status");
                    if ("Closed".equalsIgnoreCase(statusValue)) {
                        if (resultsExist > 0) { 
        %>
                        <div class="action-banner banner-success" id="resultToolbar">
                            <div>
                                <strong style="font-size: 16px;"><i class="fa-solid fa-check-circle"></i> Official Results Generated</strong>
                                <div style="font-size: 13px; margin-top: 4px;">Results are visible to students. You can download the report.</div>
                            </div>
                            <div style="display: flex; gap: 10px;">
                                <button onclick="downloadResultsPDF()" class="btn-action btn-blue">
                                    <i class="fa-solid fa-file-pdf"></i> Download PDF
                                </button>
                                <form action="ResetResultServlet" method="POST" style="margin:0;" onsubmit="return confirm('Resetting will hide results from students. Proceed?')">
                                    <input type="hidden" name="electionId" value="<%= selectedElectionID %>">
                                    <button type="submit" class="btn-action btn-red">
                                        <i class="fa-solid fa-rotate-left"></i> Reset
                                    </button>
                                </form>
                            </div>
                        </div>
        <%              } else { %>
                        <div class="action-banner banner-finalize">
                            <div>
                                <strong style="font-size: 16px;"><i class="fa-solid fa-lock"></i> Election Ended</strong>
                                <div style="font-size: 13px; margin-top: 4px;">Generate official results to declare winners and notify students.</div>
                            </div>
                            <form action="FinalizeResultServlet" method="POST" style="margin:0;">
                                <input type="hidden" name="electionId" value="<%= selectedElectionID %>">
                                <button type="submit" class="btn-action btn-gold">
                                    <i class="fa-solid fa-wand-magic-sparkles"></i> Generate Results
                                </button>
                            </form>
                        </div>
        <%              }
                    }
                }
                rsRes.close(); psCheck.close(); rsStatus.close(); psStatus.close();
            }
        %>

        <div id="pdfContent">
            <%
                try {
                    Connection con = DBConnection.createConnection();
                    // SQL: Counts votes for each candidate
                    String sql = "SELECT c.cand_ID, c.cand_PhotoPath, s.stu_Name, p.position_Name, p.position_ID, "
                               + "e.election_Title, e.election_ID, e.election_Status, COUNT(v.vote_ID) as voteCount "
                               + "FROM candidate c "
                               + "JOIN student s ON c.stud_ID = s.stud_ID "
                               + "JOIN election e ON c.election_ID = e.election_ID "
                               + "JOIN position p ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) "
                               + "LEFT JOIN vote v ON c.cand_ID = v.cand_ID "
                               + "WHERE 1=1 ";
                    
                    if (selectedElectionID != null && !selectedElectionID.isEmpty()) {
                        sql += "AND p.election_ID = " + selectedElectionID + " ";
                    }
                    
                    // Order by Election -> Position -> Votes (High to Low)
                    sql += "GROUP BY c.cand_ID, c.cand_PhotoPath, s.stu_Name, p.position_Name, p.position_ID, e.election_Title, e.election_ID, e.election_Status "
                         + "ORDER BY e.election_ID DESC, p.position_ID ASC, voteCount DESC";

                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    
                    int curEID = -1; 
                    int curPID = -1; 
                    boolean firstPass = true; 
                    boolean hasData = false; 
                    boolean isFirstInGroup = false; // To track the winner (Top vote getter)

                    while (rs.next()) {
                        hasData = true; 
                        int eID = rs.getInt("election_ID"); 
                        int pID = rs.getInt("position_ID");
                        
                        // New Election Section
                        if (eID != curEID) {
                            if (!firstPass) out.println("</div></div></div>"); // Close previous grids
                            String statusColor = "Active".equalsIgnoreCase(rs.getString("election_Status")) ? "#00c853" : "#8A92A6";
            %>
                <div class="election-section">
                    <div class="election-header">
                        <span class="election-title"><%= rs.getString("election_Title") %></span>
                        <span class="status-badge" style="background:<%= statusColor %>20; color:<%= statusColor %>;">
                            <%= rs.getString("election_Status") %>
                        </span>
                    </div>
            <%
                            curEID = eID; 
                            curPID = -1;
                        }

                        // New Position Group
                        if (pID != curPID) {
                            if (curPID != -1) out.println("</div></div>"); // Close previous position group
            %>
                    <div class="position-group">
                        <div class="position-title"><%= rs.getString("position_Name") %></div>
                        <div class="cards-grid">
            <%
                            curPID = pID; 
                            isFirstInGroup = true; // First one in the list is the potential winner
                        }
                        
                        int votes = rs.getInt("voteCount");
                        // Logic: Must match first in list AND have > 0 votes
                        boolean isWinner = isFirstInGroup && (votes > 0);
                        String cardClass = isWinner ? "result-card winner" : "result-card";
                        String photo = rs.getString("cand_PhotoPath");
                        if(photo == null || photo.isEmpty()) photo = "default_user.png";
            %>
                        <div class="<%= cardClass %>">
                            <% if(isWinner) { %>
                                <div class="crown-icon"><i class="fa-solid fa-crown"></i></div>
                            <% } %>
                            
                            <img src="${pageContext.request.contextPath}/images/<%= photo %>" class="cand-img" alt="Candidate">
                            <h3 class="cand-name"><%= rs.getString("stu_Name") %></h3>
                            
                            <div class="vote-stat">
                                <div class="vote-count"><%= votes %></div>
                                <div class="vote-label">Votes</div>
                            </div>
                        </div>
            <%
                        isFirstInGroup = false; // Subsequent candidates in this group are not winners
                        firstPass = false;
                    }
                    
                    if (hasData) {
                        out.println("</div></div></div>"); 
                    } else {
                        out.print("<div style='text-align:center; padding:50px; color:#8A92A6;'>No data available.</div>");
                    }
                    
                    con.close(); 
                    conDrop.close();
                } catch (Exception e) { e.printStackTrace(); }
            %>
        </div>
    </main>

    <script>
        async function downloadResultsPDF() {
            const { jsPDF } = window.jspdf;
            const doc = new jsPDF('p', 'mm', 'a4');
            const element = document.getElementById('pdfContent');

            await html2canvas(element, { scale: 2 }).then(canvas => {
                const imgData = canvas.toDataURL('image/png');
                const imgWidth = 190; // Fit A4 width with margin
                const imgHeight = (canvas.height * imgWidth) / canvas.width;
                
                doc.setFontSize(18);
                doc.setTextColor(30, 86, 160);
                doc.text("Official Election Results Report", 10, 15);
                
                doc.setFontSize(10);
                doc.setTextColor(100);
                doc.text("Generated by ElectVote System", 10, 22);

                doc.addImage(imgData, 'PNG', 10, 30, imgWidth, imgHeight);
                doc.save("Election_Report.pdf");
            });
        }
    </script>
</body>
</html>