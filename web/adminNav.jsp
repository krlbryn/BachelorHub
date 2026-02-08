<%-- 
    Document   : adminNav
    Created on : 29 Jan 2026, 8:15:27 am
    Author     : Karl
    Updated    : Matches Royal Blue Theme
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. GET CURRENT PAGE NAME (Logic Preserved)
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminNav.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="sidebar">
    <div class="brand">
        <div class="brand-icon">
            <i class="fa-solid fa-check-to-slot"></i>
        </div>
        <div class="brand-text">
            <span>ElectVote</span>
            <span class="brand-sub">Admin Portal</span>
        </div>
    </div>

    <ul class="nav-links">
        <li>
            <a href="adminDashboard.jsp" class="<%= pageName.equals("adminDashboard.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-columns"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="adminElection.jsp" class="<%= (pageName.equals("adminElection.jsp") || pageName.equals("adminCreateElection.jsp")) ? "active" : "" %>">
                <i class="fa-solid fa-calendar-check"></i>
                <span>Manage Elections</span>
            </a>
        </li>
        <li>
            <a href="adminViewCandidates.jsp" class="<%= (pageName.equals("adminCandidate.jsp") || pageName.equals("adminAddCandidate.jsp")) ? "active" : "" %>">
                <i class="fa-solid fa-users-gear"></i>
                <span>Manage Candidates</span>
            </a>
        </li>
        <li>
            <a href="adminVotePage.jsp" class="<%= pageName.equals("adminVotePage.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-person-booth"></i>
                <span>Voting Page</span>
            </a>
        </li>
        <li>
            <a href="adminResult.jsp" class="<%= pageName.equals("adminResult.jsp") ? "active" : "" %>">
                <i class="fa-solid fa-chart-pie"></i>
                <span>Voting Results</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <ul class="nav-links profile-link">
            <li>
                <a href="adminProfile.jsp" class="<%= (pageName.equals("adminProfile.jsp") || pageName.equals("adminUpdateProfile.jsp") || pageName.equals("adminChangePassword.jsp")) ? "active" : "" %>">
                    <i class="fa-solid fa-user-tie"></i>
                    <span>My Profile</span>
                </a>
            </li>
        </ul>

        <div class="logout-wrapper">
            <button onclick="openLogoutModal()" class="btn-logout-trigger">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Sign Out</span>
            </button>
        </div>
    </div>
</div>

<div id="logoutModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-icon-wrapper">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
        </div>
        
        <h3 class="modal-title">Signing Out?</h3>
        <p class="modal-text">You will need to log in again to access the admin portal.</p>
        
        <div class="modal-buttons">
            <button onclick="closeLogoutModal()" class="btn-cancel">Cancel</button>
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

    // Close modal if clicking outside the box
    window.onclick = function (event) {
        var modal = document.getElementById('logoutModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>