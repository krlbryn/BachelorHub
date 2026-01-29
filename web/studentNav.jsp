<%-- 
    Document   : studentNav
    Created on : 30 Jan 2026, 12:15:59 am
    Author     : ParaNon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. GET CURRENT PAGE NAME
    // This grabs "studentDashboard.jsp" or "studentProfile.jsp" from the URL
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>

<div class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-check-to-slot"></i>
        <span>VOTE</span>
    </div>

    <ul class="nav-links">
        <li>
            <a href="studentDashboard.jsp" class="<%= pageName.equals("studentDashboard.jsp") ? "active" : ""%>">
                <i class="fa-solid fa-border-all"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="studentVote.jsp" class="<%= pageName.equals("studentVote.jsp") ? "active" : ""%>">
                <i class="fa-solid fa-box-archive"></i>
                <span>Vote</span>
            </a>
        </li>
        <li>
            <a href="#" class="<%= pageName.equals("studentResults.jsp") ? "active" : ""%>">
                <i class="fa-solid fa-square-poll-vertical"></i>
                <span>Voting Results</span>
            </a>
        </li>
    </ul>

    <div class="logout-section">
        <ul class="nav-links">
            <li>
                <a href="studentProfile.jsp" class="<%= (pageName.equals("studentProfile.jsp") || pageName.equals("studentUpdateProfile.jsp") || pageName.equals("studentChangePassword.jsp")) ? "active" : ""%>">
                    <i class="fa-solid fa-user"></i>
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
            <i class="fa-solid fa-triangle-exclamation"></i>
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
    function confirmLogout() {
        document.getElementById('logoutModal').style.display = 'flex';
    }
    function closeModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }
</script>