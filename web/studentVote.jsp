<%-- 
    Document    : studentVote.jsp
    Updated     : Feb 09, 2026
    Description : Student Election Selection Page (iVOTE Royal Blue Theme)
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
    <title>Vote | Student Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
    
    <style>
        /* --- ELECTION POSTER UI ENHANCEMENTS --- */
        .elections-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            padding-bottom: 50px;
        }

        .election-poster-card {
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            border: 1px solid #E8EEF3;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .election-poster-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(30, 86, 160, 0.15);
            border-color: #1E56A0;
        }

        .poster-wrapper {
            width: 100%;
            height: 240px;
            background-color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            border-bottom: 1px solid #f1f5f9;
        }

        .poster-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .no-poster {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #cbd5e1;
        }

        .no-poster i { font-size: 4rem; margin-bottom: 12px; }

        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #00c853;
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            box-shadow: 0 4px 10px rgba(0, 200, 83, 0.3);
            letter-spacing: 0.5px;
        }

        .poster-content {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .poster-content h3 {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.25rem;
            margin-bottom: 18px;
            color: #1a1a3d;
            font-weight: 700;
            line-height: 1.3;
        }

        .info-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 10px;
            color: #64748b;
            font-size: 14px;
        }

        .info-row i { color: #1E56A0; font-size: 16px; width: 20px; text-align: center; }

        /* Action Button matched to Admin Primary Gradient */
        .btn-action-vote {
            margin-top: auto;
            background: linear-gradient(135deg, #1E56A0 0%, #4A90E2 100%);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 700;
            font-family: 'Montserrat', sans-serif;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: block;
            font-size: 13px;
        }

        .btn-action-vote:hover {
            box-shadow: 0 8px 20px rgba(30, 86, 160, 0.35);
            transform: translateY(-2px);
            filter: brightness(1.1);
        }
    </style>
</head>

<body>
    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        <jsp:include page="studentHeader.jsp" />

        <div class="dashboard-container">
            <div class="page-header">
                <h1 class="page-title">Digital Ballot</h1>
                <p class="page-subtitle">Select an active election below to view candidates and cast your vote.</p>
            </div>

            <div class="elections-grid">
                <% 
                    boolean foundActive = false;
                    if (electionList != null && !electionList.isEmpty()) {
                        for (ElectionBean election : electionList) {
                            String status = election.getElectionStatus();
                            
                            // Checking for Active/Ongoing status
                            if ("Active".equalsIgnoreCase(status) || "Ongoing".equalsIgnoreCase(status)) {
                                foundActive = true;
                                String startDate = (election.getElectionStartDate() != null)
                                        ? sdf.format(election.getElectionStartDate()) : "TBA";
                                String endDate = (election.getElectionEndDate() != null)
                                        ? sdf.format(election.getElectionEndDate()) : "TBA";
                                
                                String posterImage = election.getElectionImage();
                %>

                <div class="election-poster-card">
                    <div class="poster-wrapper">
                        <span class="status-badge">Live Now</span>
                        <% if (posterImage != null && !posterImage.trim().isEmpty() && !posterImage.equals("default.png")) { %>
                            <img src="${pageContext.request.contextPath}/images/<%= posterImage %>" alt="<%= election.getElectionTitle() %>">
                        <% } else { %>
                            <div class="no-poster">
                                <i class="fa-solid fa-image-polaroid"></i>
                                <span style="font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">No Poster</span>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="poster-content">
                        <h3><%= election.getElectionTitle() %></h3>

                        <div class="info-row">
                            <i class="fa-regular fa-calendar-check"></i>
                            <span>Starts: <strong><%= startDate %></strong></span>
                        </div>
                        <div class="info-row">
                            <i class="fa-regular fa-clock"></i>
                            <span>Ends: <strong><%= endDate %></strong></span>
                        </div>

                        <a href="voteCandidate.jsp?electionId=<%= election.getElectionId() %>" class="btn-action-vote">
                            Proceed to Vote <i class="fa-solid fa-chevron-right" style="margin-left: 8px;"></i>
                        </a>
                    </div>
                </div>

                <%          } 
                        }
                   } 
                   
                   if (!foundActive) { 
                %>
                <div class="empty-state-text">
                    <i class="fa-solid fa-box-archive" style="font-size: 4rem; color: #E8EEF3; margin-bottom: 20px; display: block;"></i>
                    <h2 style="color: #1a1a3d; margin-bottom: 10px; font-family: 'Montserrat', sans-serif;">Polls are currently closed</h2>
                    <p style="max-width: 500px; margin: 0 auto;">There are no active elections at this time. Please monitor your notifications for upcoming voting sessions.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>