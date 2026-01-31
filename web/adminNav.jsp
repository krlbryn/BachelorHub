<%-- 
    Document   : adminNav
    Created on : 29 Jan 2026, 8:15:27 am
    Author     : ParaNon
--%>

<%-- Document : adminNav --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. GET CURRENT PAGE NAME
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>

<div class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-check-to-slot"></i>
        <span>Election Admin</span>
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

    <div class="logout-section">
        
        <ul class="nav-links" style="margin-bottom: 10px;">
            <li>
                <a href="adminProfile.jsp" class="<%= (pageName.equals("adminProfile.jsp") || pageName.equals("adminUpdateProfile.jsp") || pageName.equals("adminChangePassword.jsp")) ? "active" : "" %>">
                    <i class="fa-solid fa-user-tie"></i>
                    <span>My Profile</span>
                </a>
            </li>
        </ul>

        <a href="#" onclick="confirmLogout()" class="logout-link">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</div>

<div id="logoutModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-icon-wrapper">
            <i class="fa-solid fa-right-from-bracket"></i>
        </div>
        
        <h3 class="modal-title">Confirm Logout</h3>
        <p class="modal-text">Are you sure you want to end your session?</p>
        
        <div class="modal-buttons">
            <button onclick="closeModal()" class="btn-cancel">Cancel</button>
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