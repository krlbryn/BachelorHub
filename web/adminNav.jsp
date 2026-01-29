<%-- 
    Document   : adminNav
    Created on : 29 Jan 2026, 8:15:27 am
    Author     : Karl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Helper logic to highlight the active menu item automatically
    String currentPage = request.getRequestURI();
    boolean isDashboard = currentPage.contains("adminDashboard.jsp");
    boolean isElection = currentPage.contains("adminElection.jsp");
    boolean isCandidates = currentPage.contains("adminViewCandidates.jsp"); // Highlights for Candidate page
    boolean isVotePage = currentPage.contains("adminVotePage.jsp");
    boolean isProfile = currentPage.contains("adminProfile.jsp");
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminNav.css">

<nav class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-check-to-slot"></i>
        <span>Election Admin</span>
    </div>

    <ul class="nav-links">
        <li>
            <a href="adminDashboard.jsp" class="<%= isDashboard ? "active" : "" %>">
                <i class="fa-solid fa-table-columns"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="adminElection.jsp" class="<%= isElection ? "active" : "" %>">
                <i class="fa-solid fa-square-poll-vertical"></i>
                <span>Manage Elections</span>
            </a>
        </li>
        <li>
            <a href="adminViewCandidates.jsp" class="<%= isCandidates ? "active" : "" %>">
                <i class="fa-solid fa-users-gear"></i>
                <span>Manage Candidates</span>
            </a>
        </li>
        <li>
            <a href="adminVotePage.jsp" class="<%= isVotePage ? "active" : "" %>">
                <i class="fa-solid fa-person-booth"></i>
                <span>Voting Page</span>
            </a>
        </li>
        <li>
            <a href="#"> 
                <i class="fa-solid fa-chart-pie"></i>
                <span>Voting Results</span>
            </a>
        </li>
        <li>
            <a href="adminProfile.jsp" class="<%= isProfile ? "active" : "" %>">
                <i class="fa-solid fa-user-tie"></i>
                <span>My Profile</span>
            </a>
        </li>
    </ul>

    <div class="logout-section">
        <a href="#" class="logout-link" onclick="openLogoutModal()">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</nav>

<div id="logoutModal" class="modal-overlay">
    <div class="modal-box">
        <i class="fa-solid fa-triangle-exclamation" style="color: #d9534f; font-size: 40px; margin-bottom: 15px;"></i>
        <h3 class="modal-title">Confirm Logout</h3>
        <p class="modal-text">Are you sure you want to end your session?</p>

        <div class="modal-buttons">
            <div class="btn-cancel" onclick="closeLogoutModal()">Cancel</div>
            <a href="login.jsp" class="btn-confirm">Yes, Log Out</a>
        </div>
    </div>
</div>

<script>
    function openLogoutModal() {
        document.getElementById('logoutModal').style.display = 'flex';
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    window.onclick = function (event) {
        var modal = document.getElementById('logoutModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>