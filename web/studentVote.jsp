<%-- 
    Document   : studentVote.jsp
    Updated    : Larger posters and improved card layout for better visibility.
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

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
        
        <style>
            /* --- IMPROVED POSTER INTERFACE --- */
            .elections-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); /* Slightly wider cards */
                gap: 30px;
                padding: 20px 0;
            }

            .election-card {
                background: #fff;
                border-radius: 12px;
                overflow: hidden; /* Ensures image follows border radius */
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                transition: transform 0.3s ease;
                display: flex;
                flex-direction: column;
            }

            .election-card:hover {
                transform: translateY(-5px);
            }

            /* Larger Poster Container */
            .card-image {
                width: 100%;
                height: 250px; /* Increased height from original for better visibility */
                background-color: #f0f2f5;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                border-bottom: 1px solid #eee;
            }

            .card-image img {
                width: 100%;
                height: 100%;
                object-fit: contain; /* Shows full content without cropping */
                background-color: #fff; /* White background for transparent posters */
            }

            .card-image i {
                font-size: 4rem;
                color: #ccc;
            }

            .card-content {
                padding: 20px;
            }

            .card-content h3 {
                font-family: 'Montserrat', sans-serif;
                font-size: 1.25rem;
                margin-bottom: 10px;
                color: #1a1a1a;
            }

            .image-label {
                position: absolute;
                bottom: 10px;
                left: 10px;
                background: rgba(0,0,0,0.6);
                color: #fff;
                padding: 4px 10px;
                border-radius: 4px;
                font-size: 0.75rem;
                pointer-events: none;
            }

            .btn-vote {
                width: 100%;
                background-color: #007bff;
                color: white;
                border: none;
                padding: 12px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.2s;
                margin-top: 15px;
            }

            .btn-vote:hover {
                background-color: #0056b3;
            }
        </style>
    </head>

    <body>
        <jsp:include page="studentNav.jsp" />

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">Select Election</h1>
                <p class="page-subtitle">Cast your vote for the live elections listed below.</p>
            </div>

            <div class="content-body">
                <div class="section-header">
                    <h2 class="section-title">Available Elections</h2>
                </div>

                <div class="elections-grid">
                    <% 
                        boolean foundActive = false;
                        if (electionList != null && !electionList.isEmpty()) {
                            for (ElectionBean election : electionList) {
                                String status = election.getElectionStatus();
                                
                                if ("Active".equalsIgnoreCase(status) || "Ongoing".equalsIgnoreCase(status)) {
                                    foundActive = true;
                                    String startDate = (election.getElectionStartDate() != null)
                                            ? sdf.format(election.getElectionStartDate()) : "TBA";
                                    String endDate = (election.getElectionEndDate() != null)
                                            ? sdf.format(election.getElectionEndDate()) : "TBA";
                                    
                                    String posterImage = election.getElectionImage(); //
                    %>

                    <div class="election-card">
                        <div class="card-image">
                            <% if (posterImage != null && !posterImage.trim().isEmpty() && !posterImage.equals("default.png")) { %>
                                <%-- Dynamic image path using context path --%>
                                <img src="${pageContext.request.contextPath}/images/<%= posterImage %>" alt="Election Poster">
                                <span class="image-label">Election Poster</span>
                            <% } else { %>
                                <i class="fa-regular fa-image"></i>
                                <span class="image-label">No Poster Available</span>
                            <% } %>
                        </div>
                        
                        <div class="card-content">
                            <h3><%= election.getElectionTitle()%></h3>

                            <div class="date-info" style="font-size: 0.9rem; color: #666;">
                                <i class="fa-regular fa-calendar-days"></i>
                                <div class="date-text" style="display: inline-block; margin-left: 8px;">
                                    <div>Start : <%= startDate%></div>
                                    <div>End : <%= endDate%></div>
                                </div>
                            </div>

                            <button class="btn-vote"
                                    onclick="window.location.href = 'voteCandidate.jsp?electionId=<%= election.getElectionId()%>'">
                                View Candidates & Vote
                            </button>
                        </div>
                    </div>

                    <%          } 
                            }
                       } 
                       
                       if (!foundActive) { 
                    %>
                    <div class="empty-state" style="grid-column: 1/-1; text-align: center; padding: 50px;">
                        <i class="fa-solid fa-box-open" style="font-size: 3rem; color: #ccc; margin-bottom: 15px;"></i>
                        <h3 style="color: #666;">No active elections are currently available.</h3>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </body>
</html>