<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="java.util.LinkedHashMap, java.util.ArrayList, java.util.Map, java.util.List, com.mvc.bean.CandidateBean, com.mvc.bean.ElectionBean, com.mvc.dao.CandidateDao, com.mvc.dao.ElectionDao" %>

<%
    // 1. Session and Parameter Validation
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String electionIdStr = request.getParameter("electionId");
    if (electionIdStr == null || electionIdStr.isEmpty()) {
        response.sendRedirect("studentVote.jsp");
        return;
    }

    int electionId = 0;
    try {
        electionId = Integer.parseInt(electionIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("studentVote.jsp");
        return;
    }

    // 2. Fetch Election Details
    ElectionDao electionDao = new ElectionDao();
    ElectionBean election = null;
    List<ElectionBean> allElections = electionDao.getAllElections();
    for (ElectionBean e : allElections) {
        if (e.getElectionId() == electionId) {
            election = e;
            break;
        }
    }

    if (election == null) {
        response.sendRedirect("studentVote.jsp");
        return;
    }

    // 3. Fetch and Group Candidates
    CandidateDao candidateDao = new CandidateDao();
    List<CandidateBean> candidateList = candidateDao.getCandidatesByElectionId(electionId);
    Map<String, List<CandidateBean>> candidatesByPosition = new LinkedHashMap<>();

    for (CandidateBean c : candidateList) {
        String posName = c.getPositionName();
        if (!candidatesByPosition.containsKey(posName)) {
            candidatesByPosition.put(posName, new ArrayList<CandidateBean>());
        }
        candidatesByPosition.get(posName).add(c);
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Vote Candidates - <%= election.getElectionTitle()%></title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">

        <style>
            .election-header {
                margin-bottom: 30px;
            }
            .election-subtitle {
                font-family: 'Montserrat', sans-serif;
                font-size: 2em;
                color: #333;
                margin-top: 5px;
            }
            .position-section {
                margin-bottom: 40px;
            }
            .position-title {
                font-family: 'Montserrat', sans-serif;
                font-size: 1.8em;
                margin-bottom: 20px;
                color: #000;
                border-bottom: 2px solid #eee;
                padding-bottom: 10px;
            }
            .candidates-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
            }
            .candidate-card {
                background: #fff;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                text-align: center;
                display: flex;
                flex-direction: column;
                align-items: center;
                transition: transform 0.2s;
            }
            .candidate-card:hover {
                transform: translateY(-5px);
            }
            .candidate-img-container {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                background-color: #3498db;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-bottom: 15px;
                overflow: hidden;
            }
            .candidate-img-container i {
                font-size: 3em;
                color: #fff;
            }
            .candidate-img-container img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
            .candidate-name {
                font-size: 1.2em;
                font-weight: bold;
                color: #000;
                margin-bottom: 5px;
            }
            .running-for {
                color: #555;
                font-size: 0.9em;
                margin-bottom: 15px;
            }
            .running-for span {
                color: #4481eb;
                font-weight: 500;
            }
            .candidate-details {
                text-align: left;
                width: 100%;
                font-size: 0.9em;
                color: #444;
                margin-bottom: 20px;
                background: #f9f9f9;
                padding: 10px;
                border-radius: 5px;
                min-height: 60px;
            }
            .btn-vote-candidate {
                background-color: #0d1b2a;
                color: white;
                border: none;
                padding: 10px 30px;
                border-radius: 25px;
                cursor: pointer;
                font-size: 1em;
                text-decoration: none;
                transition: background 0.3s;
                margin-top: auto;
            }
            .btn-vote-candidate:hover {
                background-color: #1b263b;
            }
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }
            .vote-confirm-box {
                background: white;
                padding: 30px;
                border-radius: 10px;
                text-align: center;
                max-width: 400px;
                width: 90%;
                color: #333;
            }
            .vote-confirm-title {
                font-size: 1.5em;
                margin-bottom: 10px;
                color: #000;
                font-weight: bold;
            }
            .vote-confirm-text {
                margin-bottom: 25px;
                color: #666;
                font-size: 1.1em;
            }
            .vote-confirm-buttons {
                display: flex;
                justify-content: center;
                gap: 15px;
            }
            .btn-confirm-vote {
                background-color: #00b894;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
                font-size: 1em;
            }
            .btn-cancel-vote {
                background-color: #e74c3c;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-weight: bold;
                font-size: 1em;
            }
        </style>
    </head>

    <body>
        <div class="sidebar">
            <div class="brand"><i class="fa-solid fa-check-to-slot"></i><span>VOTE</span></div>
            <ul class="nav-links">
                <li><a href="studentDashboard.jsp"><i class="fa-solid fa-border-all"></i><span>Dashboard</span></a></li>
                <li><a href="studentVote.jsp" class="active"><i class="fa-solid fa-box-archive"></i><span>Vote</span></a></li>
                <li><a href="#"><i class="fa-solid fa-square-poll-vertical"></i><span>Voting Results</span></a></li>
            </ul>
            <div class="logout-section">
                <ul class="nav-links">
                    <li><a href="studentProfile.jsp"><i class="fa-solid fa-user"></i><span>My Profile</span></a></li>
                </ul>
                <a href="#" onclick="confirmLogout()" class="logout-link">
                    <i class="fa-solid fa-right-from-bracket"></i><span>Sign Out</span>
                </a>
            </div>
        </div>

        <div class="main-content">
            <div class="header">
                <h1 class="welcome-text">Vote for Candidates</h1>
            </div>

            <div class="content-body" style="background: transparent; box-shadow: none;">
                <%-- Message Display --%>
                <%
                    String msg = (String) session.getAttribute("voteMessage");
                    String msgType = (String) session.getAttribute("voteMessageType");
                    if (msg != null) {
                %>
                <div style="padding: 15px; margin-bottom: 20px; border-radius: 5px; text-align: center; font-weight: bold;
                     background-color: <%= "error".equals(msgType) ? "#ffdce0" : "#d4edda"%>;
                     color: <%= "error".equals(msgType) ? "#721c24" : "#155724"%>;
                     border: 1px solid <%= "error".equals(msgType) ? "#f5c6cb" : "#c3e6cb"%>;">
                    <%= msg%>
                </div>
                <%
                        session.removeAttribute("voteMessage");
                        session.removeAttribute("voteMessageType");
                    }
                %>

                <div class="election-header">
                    <center><h2 class="election-subtitle"><%= election.getElectionTitle()%></h2></center>
                    <center><p style="color: #666;"><%= (election.getElectionDesc() != null) ? election.getElectionDesc() : ""%></p></center>
                </div>

                <% if (candidatesByPosition.isEmpty()) { %>
                <div style="text-align: center; padding: 40px; color: #666;">
                    <h3>No candidates found for this election yet.</h3>
                </div>
                <% } else {
                    for (Map.Entry<String, List<CandidateBean>> entry : candidatesByPosition.entrySet()) {
                        String positionName = entry.getKey();
                        List<CandidateBean> cList = entry.getValue();
                %>
                <div class="position-section">
                    <h3 class="position-title"><%= positionName%></h3>
                    <div class="candidates-grid">
                        <% for (CandidateBean c : cList) { %>
                        <div class="candidate-card">
                            <div class="candidate-img-container">
                                <%-- FIXED: construction of path on one line to avoid string literal errors --%>
                                <% if (c.getPhotoPath() != null && !c.getPhotoPath().isEmpty()) {%>
                                <img src="<%= request.getContextPath()%>/<%= c.getPhotoPath()%>" alt="Candidate">
                                <% } else { %>
                                <i class="fa-solid fa-user"></i>
                                <% }%>
                            </div>
                            <div class="candidate-name"><%= c.getStudName()%></div>
                            <div class="running-for">Running for: <span><%= c.getPositionName()%></span></div>
                            <div class="candidate-details">
                                <small><strong>Manifesto:</strong></small><br>
                                <%= (c.getManifesto() != null && !c.getManifesto().isEmpty()) ? c.getManifesto().replace("\n", "<br>") : "<i>No manifesto provided.</i>"%>
                            </div>
                            <button class="btn-vote-candidate" onclick="openVoteModal('<%= c.getCandId()%>', '<%= c.getStudName().replace("'", "\\'")%>', '<%= c.getPositionName()%>')">Vote</button>
                        </div>
                        <% } %>
                    </div>
                </div>
                <% }
                }%>
            </div>
        </div>

        <%-- Modals --%>
        <div id="voteModal" class="modal-overlay">
            <div class="vote-confirm-box">
                <h3 class="vote-confirm-title">Confirm Your Vote</h3>
                <p class="vote-confirm-text">Are you sure you want to vote for <br><strong><span id="modalCandidateName" style="color: #000;"></span></strong>?</p>
                <form action="SubmitVoteServlet" method="POST">
                    <input type="hidden" name="electionId" value="<%= electionId%>">
                    <input type="hidden" name="candidateId" id="formCandidateId">
                    <div class="vote-confirm-buttons">
                        <button type="submit" class="btn-confirm-vote">Yes, Vote</button>
                        <button type="button" onclick="closeVoteModal()" class="btn-cancel-vote">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="logoutModal" class="modal-overlay">
            <div class="vote-confirm-box">
                <h3 class="vote-confirm-title">Sign Out</h3>
                <p class="vote-confirm-text">Are you sure you want to sign out?</p>
                <div class="vote-confirm-buttons">
                    <a href="login.jsp" class="btn-confirm-vote" style="text-decoration: none; padding-top: 12px;">Yes</a>
                    <button onclick="closeLogoutModal()" class="btn-cancel-vote">Cancel</button>
                </div>
            </div>
        </div>

        <script>
            function openVoteModal(candId, candName, positionName) {
                document.getElementById('modalCandidateName').innerText = candName;
                document.getElementById('formCandidateId').value = candId;
                document.getElementById('voteModal').style.display = 'flex';
            }
            function closeVoteModal() {
                document.getElementById('voteModal').style.display = 'none';
            }
            function confirmLogout() {
                document.getElementById('logoutModal').style.display = 'flex';
            }
            function closeLogoutModal() {
                document.getElementById('logoutModal').style.display = 'none';
            }

            window.onclick = function (event) {
                if (event.target == document.getElementById('voteModal'))
                    closeVoteModal();
                if (event.target == document.getElementById('logoutModal'))
                    closeLogoutModal();
            }
        </script>
    </body>
</html>