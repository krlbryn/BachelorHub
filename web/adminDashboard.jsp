<%-- 
    Document   : adminDashboard
    Created on : 28 Jan 2026, 8:28:26 pm
    Author     : Karl
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Fetch Live Stats from Database
    int totalVoters = 0;
    int totalCandidates = 0;
    int activeElections = 0;

    try {
        Connection con = DBConnection.createConnection();
        
        // Count Students
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM student");
        if(rs1.next()) totalVoters = rs1.getInt(1);
        
        // Count Candidates
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM candidate");
        if(rs2.next()) totalCandidates = rs2.getInt(1);

        // Count Active Elections
        Statement st3 = con.createStatement();
        ResultSet rs3 = st3.executeQuery("SELECT COUNT(*) FROM election WHERE election_Status='Active'");
        if(rs3.next()) activeElections = rs3.getInt(1);

        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Playfair+Display:wght@500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminHeader.css">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <div class="top-header">
            <h1 class="header-title" style="font-family: 'Playfair Display', serif;">Dashboard</h1>
            <div class="header-info">Welcome, <%= userSession %>!</div>
        </div>

        <div class="dashboard-grid">
            <div class="stat-card">
                <div class="stat-title">Total Voters</div>
                <div class="stat-value"><%= totalVoters %></div>
            </div>
            
            <div class="stat-card">
                <div class="stat-title">Total Candidates</div>
                <div class="stat-value"><%= totalCandidates %></div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Active Elections</div>
                <div class="stat-value"><%= activeElections %></div>
            </div>

            <a href="adminProfile.jsp" class="stat-card profile-card" style="text-decoration:none;">
                <div class="stat-title" style="font-size:1.5rem;">Your <br>Profile</div>
                <i class="fa-regular fa-user" style="font-size:2rem; margin-top:10px;"></i>
            </a>
        </div>


        <div class="chart-container">
            <h2 class="chart-header">Vote Statistics</h2>
            
            <div class="charts-row">
                <div class="chart-box">
                    <canvas id="barChart"></canvas>
                </div>
                
                <div class="chart-box">
                    <canvas id="pieChart"></canvas>
                </div>
            </div>
        </div>


        <div class="quick-links">
            <a href="adminElection.jsp" class="btn-dashboard">Manage Elections</a>
            <a href="adminViewCandidates.jsp" class="btn-dashboard">Manage Candidates</a>
            <a href="adminVotePage.jsp" class="btn-dashboard">Voting Page</a>
            <a href="#" class="btn-dashboard">Voting Results</a>
        </div>

    </main>

    <script>
        // 1. Bar Chart Config
        const ctxBar = document.getElementById('barChart').getContext('2d');
        new Chart(ctxBar, {
            type: 'bar',
            data: {
                labels: ['CS Club', 'SRC', 'Engineering', 'Robotics'],
                datasets: [{
                    label: 'Votes Cast',
                    data: [12, 19, 8, 15], // Dummy data for now
                    backgroundColor: ['#66a6ff', '#89f7fe', '#6a11cb', '#2575fc'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } }
            }
        });

        // 2. Pie Chart Config
        const ctxPie = document.getElementById('pieChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'pie',
            data: {
                labels: ['Voted', 'Not Voted'],
                datasets: [{
                    data: [300, 150], // Dummy data
                    backgroundColor: ['#2575fc', '#89f7fe']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    </script>

</body>
</html>