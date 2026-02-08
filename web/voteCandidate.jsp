<%-- 
    Document   : voteCandidate.jsp
    Updated    : Feb 09, 2026
    Description: Candidate Selection & Voting (Floating Card & iVOTE Theme)
--%>
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
    <title>Vote Candidates | <%= election.getElectionTitle()%></title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">

    <style>
        /* Specific Enhancements for Candidate Selection */
        .position-section {
            margin-bottom: 50px;
        }
        
        .position-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.4rem;
            color: #1a1a3d;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .position-title::after {
            content: "";
            flex-grow: 1;
            height: 1px;
            background: #E8EEF3;
        }

        .candidates-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
        }

        .candidate-card {
            background: #fff;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid #E8EEF3;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s ease;
        }

        .candidate-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(30, 86, 160, 0.1);
            border-color: #1E56A0;
        }

        .cand-avatar {
            width: 110px;
            height: 110px;
            border-radius: 12px; /* Admin Standard Square-ish Avatar */
            background-color: #F4F7FE;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            overflow: hidden;
            border: 3px solid #F4F7FE;
        }

        .cand-avatar i { font-size: 3.5rem; color: #cbd5e1; }
        .cand-avatar img { width: 100%; height: 100%; object-fit: cover; }

        .cand-name {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: #1a1a3d;
            margin-bottom: 5px;
        }

        .cand-manifesto {
            margin-top: 15px;
            padding: 15px;
            background: #F9FBFD;
            border-radius: 10px;
            font-size: 0.9rem;
            color: #64748b;
            width: 100%;
            text-align: left;
            line-height: 1.5;
            flex-grow: 1;
        }

        /* Voting Action Button - Admin Gradient */
        .btn-cast-vote {
            margin-top: 25px;
            width: 100%;
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
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-cast-vote:hover {
            box-shadow: 0 8px 20px rgba(30, 86, 160, 0.3);
            transform: scale(1.02);
        }

        /* Modal Overrides for Admin Parity */
        .vote-confirm-box {
            background: white;
            padding: 40px;
            border-radius: 20px;
            text-align: center;
            max-width: 400px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.2);
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
                <p class="page-subtitle">Selection for: <strong><%= election.getElectionTitle()%></strong></p>
            </div>

            <%-- Success/Error Message Display --%>
            <%
                String msg = (String) session.getAttribute("voteMessage");
                String msgType = (String) session.getAttribute("voteMessageType");
                if (msg != null) {
            %>
            <div style="padding: 15px 25px; margin-bottom: 30px; border-radius: 12px; display: flex; align-items: center; gap: 15px; 
                 background-color: <%= "error".equals(msgType) ? "#fff5f5" : "#f0fdf4"%>; 
                 color: <%= "error".equals(msgType) ? "#c53030" : "#166534"%>;
                 border: 1px solid <%= "error".equals(msgType) ? "#feb2b2" : "#bbf7d0"%>;">
                <i class="fa-solid <%= "error".equals(msgType) ? "fa-circle-xmark" : "fa-circle-check"%>"></i>
                <span style="font-weight: 600;"><%= msg%></span>
            </div>
            <%
                    session.removeAttribute("voteMessage");
                    session.removeAttribute("voteMessageType");
                }
            %>

            <% if (candidatesByPosition.isEmpty()) { %>
                <div class="empty-state-text">
                    <i class="fa-solid fa-users-slash" style="font-size: 3rem; margin-bottom: 15px; display: block;"></i>
                    No candidates found for this election yet.
                </div>
            <% } else {
                for (Map.Entry<String, List<CandidateBean>> entry : candidatesByPosition.entrySet()) {
                    String positionName = entry.getKey();
                    List<CandidateBean> cList = entry.getValue();
            %>
            <div class="position-section">
                <h3 class="position-title">
                    <i class="fa-solid fa-medal" style="color: #ffc107;"></i>
                    <%= positionName%>
                </h3>
                
                <div class="candidates-grid">
                    <% for (CandidateBean c : cList) { %>
                    <div class="candidate-card">
                        <div class="cand-avatar">
                            <% if (c.getPhotoPath() != null && !c.getPhotoPath().isEmpty() && !c.getPhotoPath().equals("default_user.png")) {%>
                                <img src="${pageContext.request.contextPath}/images/<%= c.getPhotoPath()%>" alt="Candidate Photo">
                            <% } else { %>
                                <i class="fa-solid fa-user"></i>
                            <% }%>
                        </div>
                        
                        <div class="cand-name"><%= c.getStudName()%></div>
                        <div style="font-size: 12px; color: #8A92A6; text-transform: uppercase; font-weight: 600; letter-spacing: 0.5px;">Candidate ID: #<%= c.getCandId() %></div>
                        
                        <div class="cand-manifesto">
                            <strong style="color: #1a1a3d; display: block; margin-bottom: 5px; font-size: 11px; text-transform: uppercase;">Platform & Manifesto</strong>
                            <%= (c.getManifesto() != null && !c.getManifesto().isEmpty()) ? c.getManifesto().replace("\n", "<br>") : "<i>No manifesto provided for this election.</i>"%>
                        </div>
                        
                        <button class="btn-cast-vote" onclick="openVoteModal('<%= c.getCandId()%>', '<%= c.getStudName().replace("'", "\\'")%>')">
                            Cast Ballot <i class="fa-solid fa-check-to-slot"></i>
                        </button>
                    </div>
                    <% } %>
                </div>
            </div>
            <% }
            } %>
        </div>
    </div>

    <div id="voteModal" class="modal-overlay">
        <div class="vote-confirm-box">
            <div style="width: 70px; height: 70px; background: #f0fdf4; color: #22c55e; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 30px;">
                <i class="fa-solid fa-vote-yea"></i>
            </div>
            <h3 class="modal-title">Confirm Your Selection</h3>
            <p class="modal-text">You are about to cast your vote for:<br><strong id="modalCandidateName" style="color: #1E56A0; font-size: 1.1rem;"></strong></p>
            
            <form action="SubmitVoteServlet" method="POST">
                <input type="hidden" name="electionId" value="<%= electionId%>">
                <input type="hidden" name="candidateId" id="formCandidateId">
                <div class="modal-buttons" style="margin-top: 30px;">
                    <button type="submit" class="btn-confirm" style="background: #1E56A0; flex: 1; padding: 12px;">Yes, Confirm Vote</button>
                    <button type="button" onclick="closeVoteModal()" class="btn-cancel" style="flex: 1; padding: 12px;">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openVoteModal(candId, candName) {
            document.getElementById('modalCandidateName').innerText = candName;
            document.getElementById('formCandidateId').value = candId;
            document.getElementById('voteModal').style.display = 'flex';
        }
        function closeVoteModal() {
            document.getElementById('voteModal').style.display = 'none';
        }
        window.onclick = function (event) {
            if (event.target == document.getElementById('voteModal'))
                closeVoteModal();
        }
    </script>
</body>
</html>