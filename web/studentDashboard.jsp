<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- 
    SAFETY CHECK: 
    If stats are missing (user accessed JSP directly), redirect to the Servlet.
--%>
<c:if test="${empty stats}">
    <c:redirect url="studentDashboard"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
</head>

<body>

    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        
        <div class="stats-row">
            <div class="stat-box">
                <h3>Active Elections</h3>
                <div class="stat-number">${stats.activeCount}</div>
            </div>
            <div class="stat-box">
                <h3>Ended Elections</h3>
                <div class="stat-number">${stats.endedCount}</div>
            </div>
            <div class="stat-box">
                <h3>Upcoming</h3>
                <div class="stat-number">${stats.upcomingCount}</div>
            </div>
            <div class="stat-box">
                <h3>Welcome</h3>
                <div style="font-size: 1.2rem; font-weight: bold; margin-top: 10px;">
                    ${sessionScope.userSession}
                </div>
            </div>
        </div>

        <div class="section-container">
            <div class="section-header">
                <i class="fa-solid fa-fire" style="color: #ff5722; margin-right: 8px;"></i>
                Active Elections (Vote Now)
            </div>
            <div class="election-grid">
                
                <c:forEach var="elec" items="${activeList}">
                    <div class="election-dash-card">
                        <div class="card-info">
                            <strong>${elec.electionTitle}</strong>
                            <small><i class="fa-regular fa-clock"></i> Ends: ${elec.electionEndDate}</small>
                        </div>
                        <div style="display:flex; flex-direction:column; width: 120px;">
                            <a href="voteCandidate.jsp?electionId=${elec.electionId}" class="btn-white">Vote Now</a>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty activeList}">
                    <p style="color: #999; grid-column: 1/-1; text-align: center;">No active elections at the moment.</p>
                </c:if>
            </div>
        </div>

        <div class="section-container">
            <div class="section-header">
                <i class="fa-solid fa-box-archive" style="color: #666; margin-right: 8px;"></i>
                Past Elections
            </div>
            <div class="election-grid">
                
                <c:forEach var="elec" items="${endedList}">
                    <div class="election-dash-card ended-card">
                        <div class="card-info">
                            <strong>${elec.electionTitle}</strong>
                            <small>Status: Completed</small>
                        </div>
                        <div style="display:flex; flex-direction:column; width: 120px;">
                            <a href="studentViewWinner.jsp?electionId=${elec.electionId}" class="btn-white">View Results</a>
                        </div>
                    </div>
                </c:forEach>
                
                 <c:if test="${empty endedList}">
                    <p style="color: #999; grid-column: 1/-1; text-align: center;">No past elections found.</p>
                </c:if>
            </div>
        </div>

    </div>

</body>
</html>