<%-- 
    Document   : adminDashboard
    Updated on : Feb 08, 2026
    Description: Admin Dashboard with Activity Widgets & Live Data
--%>

<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Variables for Stats & Widgets
    int totalVoters = 0;
    int totalCandidates = 0;
    int activeElections = 0;
    
    // Chart Data
    String electionLabels = "";
    String voteCounts = "";
    int hasVotedCount = 0;
    int totalStudents = 0;

    // Widget Data
    String featuredTitle = "No Active Election";
    String featuredID = "";
    boolean hasFeatured = false;

    try {
        Connection con = DBConnection.createConnection();
        Statement st = con.createStatement();
        
        // --- BASIC STATS ---
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM student");
        if(rs1.next()) { totalVoters = rs1.getInt(1); totalStudents = totalVoters; }
        
        ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM candidate");
        if(rs2.next()) totalCandidates = rs2.getInt(1);

        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM election WHERE election_Status='Active'");
        if(rs3.next()) activeElections = rs3.getInt(1);
        
        // --- CHART 1: Votes per Election ---
        String sqlChart = "SELECT e.election_Title, COUNT(v.vote_ID) as total FROM election e LEFT JOIN vote v ON e.election_ID = v.election_ID GROUP BY e.election_ID, e.election_Title ORDER BY e.election_ID DESC LIMIT 5";
        ResultSet rsChart = con.createStatement().executeQuery(sqlChart);
        StringBuilder labels = new StringBuilder();
        StringBuilder data = new StringBuilder();
        while(rsChart.next()) {
            if(labels.length() > 0) { labels.append(","); data.append(","); }
            labels.append("'").append(rsChart.getString("election_Title")).append("'");
            data.append(rsChart.getInt("total"));
        }
        electionLabels = labels.toString();
        voteCounts = data.toString();
        
        // --- CHART 2: Voted Count ---
        ResultSet rsPie = con.createStatement().executeQuery("SELECT COUNT(DISTINCT stud_ID) FROM vote");
        if(rsPie.next()) hasVotedCount = rsPie.getInt(1);
        
        // --- WIDGET 1: Featured Active Election ---
        // Get the latest 'Active' election
        ResultSet rsFeat = con.createStatement().executeQuery("SELECT election_Title, election_ID FROM election WHERE election_Status='Active' ORDER BY election_ID DESC LIMIT 1");
        if(rsFeat.next()) {
            featuredTitle = rsFeat.getString("election_Title");
            featuredID = rsFeat.getString("election_ID");
            hasFeatured = true;
        }
        
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
    
    int notVotedCount = totalStudents - hasVotedCount;
    if(notVotedCount < 0) notVotedCount = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | ElectVote Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminHeader.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        /* --- THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--ev-bg);
            color: var(--ev-text);
            padding-left: 260px;
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- STAT CARDS --- */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: var(--ev-card);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            position: relative;
            transition: transform 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-5px); }

        .stat-title { font-size: 13px; color: var(--ev-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .stat-value { font-size: 32px; font-weight: 700; color: var(--ev-primary); }
        .card-icon { position: absolute; right: 20px; top: 25px; font-size: 40px; color: rgba(30, 86, 160, 0.1); }

        /* --- CHARTS ROW --- */
        .charts-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }
        .chart-box {
            background: var(--ev-card);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            height: 320px;
        }
        .chart-title { font-size: 16px; font-weight: 700; color: var(--ev-text); margin-bottom: 15px; }

        /* --- WIDGETS SECTION (NEW) --- */
        .widgets-grid {
            display: grid;
            grid-template-columns: 1.2fr 1.8fr;
            gap: 25px;
        }

        /* Widget 1: Featured Election */
        .featured-card {
            background: var(--ev-card);
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
        }
        
        .featured-content { z-index: 2; max-width: 60%; }
        .featured-label { font-size: 14px; font-weight: 600; color: var(--ev-muted); margin-bottom: 10px; }
        .featured-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 25px; line-height: 1.2; }
        
        .btn-vote-now {
            background: var(--ev-primary);
            color: white;
            text-decoration: none;
            padding: 12px 25px;
            border-radius: 30px; /* Pill shape button */
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(30, 86, 160, 0.3);
            transition: 0.3s;
            display: inline-block;
        }
        .btn-vote-now:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.4); }

        .featured-illustration {
            font-size: 120px;
            color: rgba(30, 86, 160, 0.08); /* Watermark effect */
            position: absolute;
            right: -20px;
            bottom: -20px;
            z-index: 1;
        }

        /* Widget 2: Election Activities List */
        .activity-card {
            background: var(--ev-card);
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
        }
        
        .activity-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
        }
        .activity-legend { display: flex; gap: 15px; font-size: 12px; color: var(--ev-muted); font-weight: 500; }
        .legend-item { display: flex; align-items: center; gap: 6px; }
        
        .dot { width: 10px; height: 10px; border-radius: 50%; }
        .dot.active { background: #4A90E2; } /* Blue for Active */
        .dot.pending { background: #FFC107; } /* Yellow for Upcoming */
        .dot.closed { background: #1E56A0; } /* Dark Blue for Closed */

        .activity-list { list-style: none; padding: 0; margin: 0; }
        .activity-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #F4F7FE;
        }
        .activity-item:last-child { border-bottom: none; }
        
        .activity-name { font-weight: 600; color: #1a1a3d; font-size: 14px; }
        
        .activity-status-wrapper { display: flex; align-items: center; gap: 40px; }
        .activity-date { font-size: 13px; color: var(--ev-muted); font-weight: 500; width: 100px; text-align: right; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />
        
        <div class="top-header" style="margin-bottom: 25px;">
            <h1 style="font-size: 26px; font-weight: 700; color: #1E56A0; margin: 0;">Dashboard Overview</h1>
            <div style="color: #8A92A6; font-size: 14px;">Welcome back, <%= userSession %>!</div>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-title">Total Voters</div>
                <div class="stat-value"><%= totalVoters %></div>
                <i class="fa-solid fa-users card-icon"></i>
            </div>
            <div class="stat-card">
                <div class="stat-title">Candidates</div>
                <div class="stat-value"><%= totalCandidates %></div>
                <i class="fa-solid fa-user-tie card-icon"></i>
            </div>
            <div class="stat-card">
                <div class="stat-title">Active Elections</div>
                <div class="stat-value"><%= activeElections %></div>
                <i class="fa-solid fa-check-to-slot card-icon"></i>
            </div>
        </div>

        <div class="charts-row">
            <div class="chart-box">
                <div class="chart-title">Votes per Election</div>
                <canvas id="barChart"></canvas>
            </div>
            <div class="chart-box">
                <div class="chart-title">Student Turnout</div>
                <canvas id="pieChart"></canvas>
            </div>
        </div>

        <div class="widgets-grid">
            
            <div class="featured-card">
                <div class="featured-content">
                    <div class="featured-label">Ongoing Election</div>
                    <div class="featured-title"><%= featuredTitle %></div>
                    
                    <% if(hasFeatured) { %>
                        <a href="adminElection.jsp" class="btn-vote-now">Manage Election</a>
                    <% } else { %>
                        <a href="adminElection.jsp" class="btn-vote-now">Create New</a>
                    <% } %>
                </div>
                <i class="fa-solid fa-check-to-slot featured-illustration"></i>
            </div>

            <div class="activity-card">
                <div class="activity-header">
                    <div class="chart-title" style="margin:0;">Election Activities</div>
                    <div class="activity-legend">
                        <div class="legend-item"><span class="dot active"></span> Active</div>
                        <div class="legend-item"><span class="dot pending"></span> Upcoming</div>
                        <div class="legend-item"><span class="dot closed"></span> Closed</div>
                    </div>
                </div>
                
                <ul class="activity-list">
                    <%
                        try {
                            Connection conList = DBConnection.createConnection();
                            String sqlList = "SELECT election_Title, election_Status, election_EndDate FROM election ORDER BY election_ID DESC LIMIT 4";
                            ResultSet rsList = conList.createStatement().executeQuery(sqlList);
                            
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            
                            while(rsList.next()) {
                                String title = rsList.getString("election_Title");
                                String status = rsList.getString("election_Status");
                                Date date = rsList.getDate("election_EndDate");
                                String dateStr = (date != null) ? sdf.format(date) : "N/A";
                                
                                String dotClass = "closed";
                                if("Active".equalsIgnoreCase(status)) dotClass = "active";
                                else if("Upcoming".equalsIgnoreCase(status)) dotClass = "pending";
                    %>
                    <li class="activity-item">
                        <span class="activity-name"><%= title %></span>
                        <div class="activity-status-wrapper">
                            <span class="dot <%= dotClass %>"></span>
                            <span class="activity-date"><%= dateStr %></span>
                        </div>
                    </li>
                    <%
                            }
                            conList.close();
                        } catch(Exception e) {}
                    %>
                </ul>
            </div>
        </div>

    </main>

    <script>
        // Bar Chart
        const ctxBar = document.getElementById('barChart').getContext('2d');
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: [<%= electionLabels %>],
                datasets: [{
                    label: 'Votes',
                    data: [<%= voteCounts %>],
                    backgroundColor: '#4A90E2',
                    borderRadius: 5,
                    barThickness: 30
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#F4F7FE' } },
                    x: { grid: { display: false } }
                }
            }
        });

        // Pie Chart
        const ctxPie = document.getElementById('pieChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'doughnut',
            data: {
                labels: ['Voted', 'Not Voted'],
                datasets: [{
                    data: [<%= hasVotedCount %>, <%= notVotedCount %>],
                    backgroundColor: ['#1E56A0', '#E8EEF3'],
                    borderWidth: 0
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '75%',
                plugins: { legend: { position: 'right' } }
            }
        });
    </script>

</body>
</html>