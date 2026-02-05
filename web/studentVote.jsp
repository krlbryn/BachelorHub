<%-- 
    Document   : studentVote.jsp
    Refactored : Uses studentNav.jsp & studentVote.css
--%>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.text.SimpleDateFormat, java.util.List, com.mvc.bean.ElectionBean, com.mvc.dao.ElectionDao" %>
<% 
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    com.mvc.dao.ElectionDao electionDao = new com.mvc.dao.ElectionDao();
    // Recommendation: Use getActiveElections() if you only want students to see active ones
    List<ElectionBean> electionList = electionDao.getAllElections(); 
    SimpleDateFormat sdf = new SimpleDateFormat("d MMMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vote - Student Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
        
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentVote.css">
    </head>

    <body>

        <jsp:include page="studentNav.jsp" />

        <div class="main-content">
            <div class="header">
                <h1 class="welcome-text">Select Election</h1>
            </div>

            <div class="content-body">
                <div class="section-header">
                    <h2 class="section-title">Available Elections</h2>
                    <div class="filter-dropdown">
                        <span>All Elections</span>
                        <i class="fa-solid fa-chevron-down"></i>
                    </div>
                </div>

                <div class="elections-grid">

                    <% if (electionList != null && !electionList.isEmpty()) {
                            for (ElectionBean election : electionList) {
                                String startDate = (election.getElectionStartDate() != null)
                                        ? sdf.format(election.getElectionStartDate()) : "TBA";
                                String endDate = (election.getElectionEndDate() != null)
                                        ? sdf.format(election.getElectionEndDate()) : "TBA";
                    %>

                    <div class="election-card">
                        <div class="card-image">
                            <i class="fa-regular fa-image"></i>
                        </div>
                        <div class="card-dots">
                            <span></span><span></span><span></span>
                        </div>
                        <p class="image-label">Image/poster</p>

                        <h3><%= election.getElectionTitle()%></h3>

                        <div class="date-info">
                            <i class="fa-regular fa-calendar-days"></i>
                            <div class="date-text">
                                <span>Start : <%= startDate%></span>
                                <span>End : <%= endDate%></span>
                            </div>
                        </div>

                        <button class="btn-vote"
                                onclick="window.location.href = 'voteCandidate.jsp?electionId=<%= election.getElectionId()%>'">
                            View Candidates & Vote
                        </button>
                    </div>

                    <%      }
                       } else { %>
                    <div style="grid-column: 1/-1; text-align: center; color: #666; padding: 40px;">
                        <i class="fa-solid fa-box-open" style="font-size: 3rem; margin-bottom: 15px; opacity: 0.5;"></i>
                        <h3>No active elections found at the moment.</h3>
                    </div>
                    <% }%>

                </div>
            </div>
        </div>
        
        </body>
</html>