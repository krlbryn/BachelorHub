<%-- 
    Document   : adminResult
    Created on : 30 Jan 2026, 10:10:34 am
    Author     : ParaNon
--%>

<%-- 
    Document   : adminResult
    Description: Comprehensive voting results with PDF export and data management.
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
    <title>Voting Results | Admin Control</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminResult.css">
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <style>
        @keyframes fadeInSlide {
            0% { opacity: 0; transform: translateY(-15px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .finalize-box {
            margin-bottom: 30px; padding: 25px; background: #fff3cd; border-radius: 12px;
            border: 1px solid #ffeeba; display: flex; justify-content: space-between;
            align-items: center; box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            animation: fadeInSlide 0.6s ease-out forwards;
        }
        .btn-finalize {
            background: #ffc107; color: #000; border: none; padding: 12px 25px;
            border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 10px;
        }
        .success-msg {
            background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb;
            padding: 15px; margin-bottom: 20px; border-radius: 8px; display: flex; align-items: center; gap: 10px;
            animation: fadeInSlide 0.5s ease-out;
        }
        .info-banner {
            background-color: #e2e3e5; color: #383d41; border: 1px solid #d6d8db;
            padding: 15px; margin-bottom: 20px; border-radius: 8px; display: flex;
            justify-content: space-between; align-items: center; animation: fadeInSlide 0.5s ease-out;
        }
    </style>
</head>
<body>
    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <h1 class="header-title">Voting Results</h1>
        <p class="header-subtitle">Manage official outcomes and export reports.</p>

        <div style="background: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; border: 1px solid #eee;">
            <form action="adminResult.jsp" method="get" style="display: flex; gap: 15px; align-items: center;">
                <label style="font-weight: 600; color: #555;">Select Election:</label>
                <select name="electionId" style="padding: 10px; border-radius: 5px; border: 1px solid #ddd; min-width: 280px;" onchange="this.form.submit()">
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
                        if (resultsExist > 0) { %>
                            <div class="info-banner" id="resultToolbar">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <i class="fa-solid fa-circle-check" style="color: #198754;"></i> 
                                    <span>Results are finalized. You can download the report or reset data.</span>
                                </div>
                                <div style="display: flex; gap: 10px;">
                                    <button onclick="downloadResultsPDF()" style="background: #0d6efd; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-weight: 600;">
                                        <i class="fa-solid fa-file-pdf"></i> Download PDF
                                    </button>
                                    <form action="ResetResultServlet" method="POST" onsubmit="return confirm('Resetting will hide results from students. Proceed?')">
                                        <input type="hidden" name="electionId" value="<%= selectedElectionID %>">
                                        <button type="submit" style="background: #dc3545; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-weight: 600;">
                                            <i class="fa-solid fa-rotate-left"></i> Reset
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="finalize-box">
                                <div>
                                    <strong style="color: #856404; font-size: 1.1rem;"><i class="fa-solid fa-lock"></i> Election Ended</strong>
                                    <p style="margin: 5px 0 0 0; color: #856404;">Generate official data for the student winner page.</p>
                                </div>
                                <form action="FinalizeResultServlet" method="POST">
                                    <input type="hidden" name="electionId" value="<%= selectedElectionID %>">
                                    <button type="submit" class="btn-finalize">
                                        <i class="fa-solid fa-wand-magic-sparkles"></i> Generate Results
                                    </button>
                                </form>
                            </div>
                        <% }
                    }
                }
                rsRes.close(); psCheck.close(); rsStatus.close(); psStatus.close();
            }
        %>

        <%-- Notification Feedback --%>
        <% if ("finalized".equals(request.getParameter("status"))) { %>
            <div class="success-msg"><i class="fa-solid fa-circle-check"></i> Results generated successfully!</div>
        <% } else if ("reset".equals(request.getParameter("status"))) { %>
            <div class="success-msg" style="background:#f8d7da; color:#842029; border-color:#f5c2c7;"><i class="fa-solid fa-trash-can"></i> Results reset successfully.</div>
        <% } %>

        <div class="content-wrapper" id="pdfContent">
            <%
                try {
                    Connection con = DBConnection.createConnection();
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
                    sql += "GROUP BY c.cand_ID, c.cand_PhotoPath, s.stu_Name, p.position_Name, p.position_ID, e.election_Title, e.election_ID, e.election_Status "
                         + "ORDER BY e.election_ID DESC, p.position_ID ASC, voteCount DESC";

                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    int curEID = -1; int curPID = -1; boolean first = true; boolean hasData = false; boolean isWinner = false;

                    while (rs.next()) {
                        hasData = true; int eID = rs.getInt("election_ID"); int pID = rs.getInt("position_ID");
                        if (eID != curEID) {
                            if (!first) out.println("</div></div></div>");
                            String bColor = "Active".equalsIgnoreCase(rs.getString("election_Status")) ? "#198754" : "#6c757d";
            %>
                <div class="election-section">
                    <div class="election-header">
                        <span class="election-title"><%= rs.getString("election_Title") %></span>
                        <span class="election-status-badge" style="background-color: <%= bColor %>20; color: <%= bColor %>;"><%= rs.getString("election_Status") %></span>
                    </div>
            <%
                            curEID = eID; curPID = -1;
                        }
                        if (pID != curPID) {
                            if (curPID != -1) out.println("</div></div>");
            %>
                    <div class="position-group">
                        <div class="position-header"><%= rs.getString("position_Name") %></div>
                        <div class="group-grid">
            <%
                            curPID = pID; isWinner = true;
                        }
                        String cardStyle = (isWinner && rs.getInt("voteCount") > 0) ? "result-card winner" : "result-card";
                        String crown = (isWinner && rs.getInt("voteCount") > 0) ? "<div style='color:#ffc107;'><i class='fa-solid fa-crown'></i></div>" : "";
                        isWinner = false;
            %>
                        <div class="<%= cardStyle %>">
                            <%= crown %>
                            <div class="card-img-wrapper">
                                <img src="${pageContext.request.contextPath}/images/<%= rs.getString("cand_PhotoPath") %>" alt="Candidate">
                            </div>
                            <h3 class="cand-name"><%= rs.getString("stu_Name") %></h3>
                            <div class="vote-stat">
                                <span class="vote-number text-primary"><%= rs.getInt("voteCount") %></span>
                                <span class="vote-label">Votes</span>
                            </div>
                        </div>
            <%
                        first = false;
                    }
                    if (hasData) out.println("</div></div></div>");
                    con.close(); conDrop.close();
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
                const imgWidth = 210;
                const imgHeight = (canvas.height * imgWidth) / canvas.width;
                
                doc.setFontSize(16);
                doc.text("Official Election Results Report", 15, 15);
                doc.addImage(imgData, 'PNG', 0, 25, imgWidth, imgHeight);
                doc.save("Election_Report.pdf");
            });
        }
    </script>
</body>
</html>