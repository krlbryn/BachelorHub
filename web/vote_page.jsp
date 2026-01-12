<%-- 
    Document   : vote_page
    Created on : 12 Jan 2026, 9:21:44 am
    Author     : abgmn
--%>

<%@page import="java.sql.*, com.election.utils.DBConnection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Vote Candidates</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="sidebar">
        <div class="logo-area">🗳️ E-Voting</div>
        <div class="nav-group">
            <a href="dashboard.jsp" class="nav-item">▣ Dashboard</a>
            <a href="#" class="nav-item active">📄 Vote</a>
        </div>
        <div class="spacer"></div>
        <div class="nav-group"><a href="#" class="nav-item">🚪 Sign Out</a></div>
    </div>

    <div class="main-content">
        <div class="header">
            <h1 class="page-title">Candidates</h1>
            <a href="dashboard.jsp" style="text-decoration:none; color:blue;">← Back</a>
        </div>

        <div class="candidate-grid">
            <% 
                String eID = request.getParameter("id");
                if(eID == null) eID = "1"; 
                Connection con = DBConnection.getConnection();
                PreparedStatement pst = con.prepareStatement("SELECT * FROM candidates WHERE election_id=?");
                pst.setString(1, eID);
                ResultSet rs = pst.executeQuery();
                while(rs.next()) {
            %>
            <div class="candidate-card">
                <div class="profile-wrapper">👤</div>
                <h3><%= rs.getString("name") %></h3>
                <p style="color:#2b65ec"><%= rs.getString("role") %></p>
                <p style="font-size:13px; font-style:italic;">"<%= rs.getString("slogan") %>"</p>
                <button class="btn-vote" onclick="openModal('<%= rs.getString("name") %>', '<%= rs.getString("id") %>')">Vote</button>
            </div>
            <% } con.close(); %>
        </div>

        <div class="modal-overlay" id="voteModal">
            <div class="modal-box">
                <h3>Confirm Your Vote</h3>
                <p>Vote for <span id="cName" style="color:#2b65ec"></span>?</p>
                <form action="SubmitVoteServlet" method="POST">
                    <input type="hidden" name="candidate_id" id="cID">
                    <input type="hidden" name="student_id" value="STUDENT_001">
                    <div class="modal-actions">
                        <button type="submit" class="btn-confirm">Confirm</button>
                        <button type="button" class="btn-cancel" onclick="document.getElementById('voteModal').style.display='none'">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function openModal(name, id) {
                document.getElementById('cName').innerText = name;
                document.getElementById('cID').value = id;
                document.getElementById('voteModal').style.display = 'flex';
            }
        </script>
    </div>
</body>
</html>
