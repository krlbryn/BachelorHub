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

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    </head>

    <body>

        <jsp:include page="studentNav.jsp" />

        <div class="main-content">

            <div class="page-header">
                <h1 class="page-title">Student Dashboard</h1>
                <p class="page-subtitle">Overview of your voting activity and live elections.</p>
            </div>

            <div class="stats-row">
                <div class="stat-box" data-tooltip="Elections currently open for voting.">
                    <h3>Active Elections</h3>
                    <div class="stat-number">${stats.activeCount}</div>
                </div>
                <div class="stat-box" data-tooltip="Elections that have closed. View winners here.">
                    <h3>Ended Elections</h3>
                    <div class="stat-number">${stats.endedCount}</div>
                </div>
                <div class="stat-box" data-tooltip="Future elections starting soon.">
                    <h3>Upcoming</h3>
                    <div class="stat-number">${stats.upcomingCount}</div>
                </div>
                <div class="stat-box box-welcome">
                    <h3>Welcome</h3>
                    <div class="user-display-name">
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
                        <div class="election-dash-card active-card">
                            <div class="card-info">
                                <strong>${elec.electionTitle}</strong>
                                <small><i class="fa-regular fa-clock"></i> Ends: ${elec.electionEndDate}</small>
                            </div>
                            <div class="card-action">
                                <a href="voteCandidate.jsp?electionId=${elec.electionId}" class="btn-white">Vote Now</a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty activeList}">
                        <p class="empty-state-text">No active elections at the moment.</p>
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
                            <div class="card-action">
                                <a href="studentViewWinner.jsp?electionId=${elec.electionId}" class="btn-white">View Results</a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty endedList}">
                        <p class="empty-state-text">No past elections found.</p>
                    </c:if>
                </div>
            </div>
            <div class="section-container">
                <div class="section-header">
                    <i class="fa-solid fa-calendar-plus" style="color: #0d6efd; margin-right: 8px;"></i>
                    Upcoming Elections (Locked)
                </div>
                <div class="election-grid">
                    <c:forEach var="elec" items="${upcomingList}">
                        <div class="election-dash-card upcoming-card">
                            <div class="card-info">
                                <strong>${elec.electionTitle}</strong>
                                <small><i class="fa-solid fa-lock"></i> Opens: ${elec.electionStartDate}</small>
                            </div>
                            <div class="card-action">
                                <button class="btn-locked" disabled>
                                    <i class="fa-solid fa-ban"></i> Locked
                                </button>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty upcomingList}">
                        <p class="empty-state-text">No upcoming elections scheduled.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>