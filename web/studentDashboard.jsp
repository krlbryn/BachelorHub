<%-- 
    Document   : studentDashboard.jsp
    Updated on : Feb 09, 2026
    Description: Beautiful Combined Student Dashboard (Floating Header & iVOTE Theme)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mvc.bean.ElectionBean, com.mvc.dao.ElectionDao, com.mvc.util.DBConnection, java.sql.*, java.util.*"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // 1. SESSION & AUTH CHECK
    HttpSession userSession = request.getSession();
    // Use stud_ID from session to fetch the username
    String studentID = (String) userSession.getAttribute("userSession");

    if (studentID == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. FETCH STUDENT USERNAME FOR THE WELCOME BOX
    String studentUserDisplay = "Student";
    try {
        Connection con = DBConnection.createConnection();
        // Query targets 'stu_Username' from the database schema
        PreparedStatement ps = con.prepareStatement("SELECT stu_Username FROM student WHERE stud_ID = ?");
        ps.setString(1, studentID);
        ResultSet rs = ps.executeQuery();
        if(rs.next()) {
            studentUserDisplay = rs.getString("stu_Username"); // Successfully fetching Username
        }
        con.close();
    } catch(Exception e) { 
        e.printStackTrace(); 
    }

    // 3. FETCH ELECTION DATA
    ElectionDao electionDao = new ElectionDao();
    List<ElectionBean> allElections = electionDao.getAllElections();
    
    List<ElectionBean> activeList = new ArrayList<>();
    List<ElectionBean> endedList = new ArrayList<>();
    List<ElectionBean> upcomingList = new ArrayList<>();

    for (ElectionBean e : allElections) {
        String status = e.getElectionStatus();
        if (status != null) {
            if (status.equalsIgnoreCase("Active") || status.equalsIgnoreCase("Ongoing")) {
                activeList.add(e);
            } else if (status.equalsIgnoreCase("Ended") || status.equalsIgnoreCase("Closed")) {
                endedList.add(e);
            } else if (status.equalsIgnoreCase("Upcoming")) {
                upcomingList.add(e);
            }
        }
    }

    // 4. PREPARE ATTRIBUTES FOR JSP
    Map<String, Integer> stats = new HashMap<>();
    stats.put("activeCount", activeList.size());
    stats.put("endedCount", endedList.size());
    stats.put("upcomingCount", upcomingList.size());

    pageContext.setAttribute("studentUserDisplay", studentUserDisplay);
    pageContext.setAttribute("activeList", activeList);
    pageContext.setAttribute("endedList", endedList);
    pageContext.setAttribute("upcomingList", upcomingList);
    pageContext.setAttribute("stats", stats);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Overview | ElectVote</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
</head>

<body>

    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        
        <jsp:include page="studentHeader.jsp" />

        <div class="dashboard-container">
            
            <div class="page-header">
                <h1 class="page-title">Dashboard Overview</h1>
                <p class="page-subtitle">Welcome back, ${studentUserDisplay}! Here is a summary of your voting activity.</p>
            </div>

            <div class="stats-row">
                <div class="stat-box box-welcome">
                    <h3>WELCOME BACK</h3>
                    <div class="stat-number" style="font-size: 24px; color: white;">
                        ${studentUserDisplay}
                    </div>
                </div>
                
                <div class="stat-box">
                    <div class="stat-info">
                        <h3>ACTIVE ELECTIONS</h3>
                        <div class="stat-number" style="color: #00c853;">${stats.activeCount}</div>
                    </div>
                    <div class="stat-icon-wrapper"><i class="fa-solid fa-check-to-slot"></i></div>
                </div>
                
                <div class="stat-box">
                    <div class="stat-info">
                        <h3>UPCOMING</h3>
                        <div class="stat-number" style="color: #ffc107;">${stats.upcomingCount}</div>
                    </div>
                    <div class="stat-icon-wrapper"><i class="fa-solid fa-calendar-days"></i></div>
                </div>
                
                <div class="stat-box">
                    <div class="stat-info">
                        <h3>ENDED</h3>
                        <div class="stat-number" style="color: #8A92A6;">${stats.endedCount}</div>
                    </div>
                    <div class="stat-icon-wrapper"><i class="fa-solid fa-box-archive"></i></div>
                </div>
            </div>

            <div class="section-container">
                <div class="section-header">
                    <i class="fa-solid fa-fire" style="color: #00c853;"></i>
                    <span>Live Elections (Vote Now)</span>
                </div>
                <div class="election-grid">
                    <c:forEach var="elec" items="${activeList}">
                        <div class="election-card card-active">
                            <div class="card-info">
                                <span class="card-title">${elec.electionTitle}</span>
                                <div class="card-meta">
                                    <i class="fa-regular fa-clock"></i> Ends: ${elec.electionEndDate}
                                </div>
                            </div>
                            <div class="card-action">
                                <a href="voteCandidate.jsp?electionId=${elec.electionId}" class="btn-vote-main">
                                    Cast Vote <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty activeList}">
                        <div class="empty-state-text">No active elections at the moment.</div>
                    </c:if>
                </div>
            </div>

            <div class="section-container">
                <div class="section-header">
                    <i class="fa-solid fa-calendar-check" style="color: #ffc107;"></i>
                    <span>Scheduled Soon</span>
                </div>
                <div class="election-grid">
                    <c:forEach var="elec" items="${upcomingList}">
                        <div class="election-card card-upcoming">
                            <div class="card-info">
                                <span class="card-title">${elec.electionTitle}</span>
                                <div class="card-meta">
                                    <i class="fa-solid fa-lock"></i> Opens: ${elec.electionStartDate}
                                </div>
                            </div>
                            <div class="card-action">
                                <button class="btn-locked-main" disabled>
                                    <i class="fa-solid fa-lock"></i> Locked
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty upcomingList}">
                        <div class="empty-state-text">No upcoming elections found.</div>
                    </c:if>
                </div>
            </div>

        </div> 
    </div>

</body>
</html>