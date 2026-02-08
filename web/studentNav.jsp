<%-- 
    Document   : studentNav
    Updated on : Feb 09, 2026
    Description: Student Sidebar Navigation (Synced with Admin iVOTE Theme)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    String pageName = uri.substring(uri.lastIndexOf("/") + 1);
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">

<div class="sidebar">
    <a href="studentDashboard" class="brand">
        <div class="brand-icon-box" style="background: rgba(255,255,255,0.2); padding: 8px; border-radius: 8px; display: flex; align-items: center; justify-content: center; width: 40px; height: 40px;">
            <i class="fa-solid fa-check-to-slot"></i>
        </div>
        <div class="brand-text" style="display: flex; flex-direction: column; line-height: 1.2; margin-left: 12px;">
            <span style="font-size: 20px; font-weight: 700;">ElectVote</span>
            <span style="font-size: 10px; font-weight: 400; opacity: 0.7; letter-spacing: 1px;">STUDENT PORTAL</span>
        </div>
    </a>

    <ul class="nav-links" style="list-style: none; flex-grow: 1; padding: 0; margin: 0;">
        <li>
            <a href="studentDashboard.jsp" class="<%= pageName.contains("studentDashboard") ? "active" : ""%>">
                <i class="fa-solid fa-border-all"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="studentVote.jsp" class="<%= pageName.equals("studentVote.jsp") || pageName.equals("voteCandidate.jsp") ? "active" : ""%>">
                <i class="fa-solid fa-check-to-slot"></i>
                <span>Vote Now</span>
            </a>
        </li>
        <li>
            <a href="studentResult.jsp" class="<%= (pageName.equals("studentResult.jsp") || pageName.equals("studentViewWinner.jsp")) ? "active" : ""%>">
                <i class="fa-solid fa-square-poll-vertical"></i>
                <span>Voting Results</span>
            </a>
        </li>
    </ul>

    <div class="logout-section" style="border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 20px;">
        <ul class="nav-links" style="list-style: none; padding: 0; margin-bottom: 15px;">
            <li>
                <a href="studentProfile.jsp" class="<%= pageName.contains("Profile") ? "active" : ""%>">
                    <i class="fa-regular fa-user"></i>
                    <span>My Profile</span>
                </a>
            </li>
        </ul>
        
        <a href="javascript:void(0)" onclick="confirmLogout()" class="logout-btn" style="display: flex; align-items: center; justify-content: center; gap: 10px; background: #355091; padding: 12px; color: white; text-decoration: none; font-weight: 600; font-size: 14px; border-radius: 10px; transition: 0.3s;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
            <span>Sign Out</span>
        </a>
    </div>
</div>

<div id="logoutModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; justify-content: center; align-items: center; backdrop-filter: blur(3px);">
    <div class="modal-box" style="background: white; padding: 30px; border-radius: 16px; width: 350px; text-align: center; box-shadow: 0 20px 40px rgba(0,0,0,0.2);">
        <div class="modal-icon-wrapper" style="width: 60px; height: 60px; background: #FFF5F5; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; color: #ff4757; font-size: 24px;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i>
        </div>
        <h3 class="modal-title" style="margin: 0 0 10px; color: #1a1a3d; font-family: 'Montserrat', sans-serif;">Confirm Logout</h3>
        <p class="modal-text" style="color: #888; margin-bottom: 25px; font-size: 14px;">Are you sure you want to end your current session?</p>
        <div class="modal-buttons" style="display: flex; gap: 10px; justify-content: center;">
            <button onclick="closeModal()" class="btn-cancel" style="padding: 10px 20px; border: 1px solid #ddd; background: white; border-radius: 8px; cursor: pointer; color: #555; font-weight: 600;">Cancel</button>
            <a href="LogoutServlet" class="btn-confirm" style="padding: 10px 20px; background: #ff4757; color: white; border-radius: 8px; text-decoration: none; font-weight: 600;">Yes, Log Out</a>
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
    
    // Close modal when clicking outside of the white box
    window.onclick = function(event) {
        var modal = document.getElementById('logoutModal');
        if (event.target == modal) { 
            closeModal(); 
        }
    }
</script>