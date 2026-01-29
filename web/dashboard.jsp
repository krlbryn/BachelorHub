<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; background: #f4f4f4; min-height: 100vh; }
        .sidebar { width: 220px; background: #fff; border-right: 2px solid #ddd; position: fixed; height: 100vh; display: flex; flex-direction: column; padding: 20px 0; }
        .nav-link { text-decoration: none; color: #555; padding: 15px 25px; display: flex; align-items: center; gap: 12px; font-weight: 500; }
        .nav-link.active { color: #2b65ec; background: #f0f7ff; border-left: 4px solid #2b65ec; font-weight: bold; }
        .main-content { margin-left: 220px; flex: 1; padding: 40px; }
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-box { background: #8eb9f5; color: white; padding: 25px; border-radius: 12px; text-align: center; }
        .white-section { background: #fff; border-radius: 20px; padding: 30px; display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .election-card { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); border-radius: 15px; padding: 20px; color: white; margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; }
        .btn-white { background: #fff; border: none; padding: 8px 15px; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 12px; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div style="padding: 0 25px 40px;"><i class="fas fa-vote-yea fa-3x"></i></div>
        <a href="dashboard" class="nav-link active"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="results" class="nav-link"><i class="fas fa-poll"></i> Voting Results</a>
    </aside>
    <main class="main-content">
        <header style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
            <div><h1>Student dashboard</h1><p>Welcome, username!</p></div>
            <div style="border:1px solid #ccc; border-radius:50%; padding:15px;">Logo</div>
        </header>
        <div class="stats-row">
            <div class="stat-box"><h3>Active Elections</h3><div style="font-size:2.5rem; font-weight:bold;">${stats.activeCount}</div></div>
            <div class="stat-box"><h3>Ended Elections</h3><div style="font-size:2.5rem; font-weight:bold;">${stats.endedCount}</div></div>
            <div class="stat-box"><h3>Upcoming</h3><div style="font-size:2.5rem; font-weight:bold;">${stats.upcomingCount}</div></div>
            <div class="stat-box" style="background:#a3c1f3; border:2px solid #7048e8;"><h2>Your Profile</h2></div>
        </div>
        <div class="white-section">
            <div>
                <p style="font-weight:bold; margin-bottom:15px;">CURRENT & ACTIVE ELECTIONS ?</p>
                <c:forEach var="elec" items="${activeElections}">
                    <c:if test="${elec.election_Status == 'Ongoing'}">
                        <div class="election-card">
                            <div><strong>${elec.election_Title}</strong><br><small>Period: ${elec.startDate} - ${elec.endDate}</small></div>
                            <div style="display:flex; flex-direction:column; gap:5px;">
                                <c:choose>
                                    <c:when test="${votedIds.contains(elec.election_ID)}">
                                        <button class="btn-white" style="background:#ddd;" disabled>Voted</button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-white">Vote now</button>
                                    </c:otherwise>
                                </c:choose>
                                <button class="btn-white">View Details</button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
            <div>
                <p style="font-weight:bold; margin-bottom:15px;">MY VOTING STATUS <i class="fas fa-user-circle"></i></p>
                <c:forEach var="elec" items="${activeElections}">
                    <c:if test="${votedIds.contains(elec.election_ID)}">
                        <div class="election-card" style="background:#6fa1f2;">
                            <div><strong>${elec.election_Title}</strong><br><small>Status: Completed</small></div>
                            <span style="background:rgba(0,0,0,0.2); padding:5px 10px; border-radius:5px; font-size:10px;">Voted</span>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </main>
</body>
</html>