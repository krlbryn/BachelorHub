<%-- 
    Document   : studentNav
    Created on : 30 Jan 2026, 12:15:59 am
    Author     : ParaNon
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">

<div class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-check-to-slot"></i>
        <span>VOTE</span>
    </div>

    <ul class="nav-links">
        <li>
            <a href="studentDashboard" class="<%= pageName.contains("studentDashboard") ? "active" : ""%>">
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
            <a href="studentResult.jsp" class="<%= (pageName.equals("studentResult.jsp") || pageName.equals("studentViewWinner.jsp")) ? "active" : ""%>">
                <i class="fa-solid fa-square-poll-vertical"></i>
                <span>Voting Results</span>
            </a>
        </li>
    </ul>

    <div class="logout-section">
        <ul class="nav-links">
            <li>
                <a href="studentProfile.jsp" class="<%= pageName.contains("Profile") ? "active" : ""%>">
                    <i class="fa-solid fa-user"></i>
                    <span>My Profile</span>
                </a>
            </li>
        </ul>
        <a href="javascript:void(0)" onclick="confirmLogout()" class="logout-link">
            <i class="fa-solid fa-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</div>

<div id="logoutModal" class="modal-overlay" style="display: none;">
    <div class="modal-box">
        <div class="modal-icon-wrapper"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <h3 class="modal-title">Confirm Logout</h3>
        <p class="modal-text">Are you sure you want to end your session?</p>
        <div class="modal-buttons">
            <button onclick="closeModal()" class="btn-cancel">Cancel</button>
            <a href="LogoutServlet" class="btn-confirm">Yes, Log Out</a>
        </div>
    </div>
</div>

<script>
    function confirmLogout() { document.getElementById('logoutModal').style.display = 'flex'; }
    function closeModal() { document.getElementById('logoutModal').style.display = 'none'; }
    window.onclick = function(event) {
        var modal = document.getElementById('logoutModal');
        if (event.target == modal) { closeModal(); }
    }
</script>