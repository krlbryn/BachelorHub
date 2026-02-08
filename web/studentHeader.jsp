<%-- 
    Document   : studentHeader.jsp
    Description: Top Header for Student Portal (Notifications & Voting Guidelines Modal)
--%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String sessionUserHeader = (String) session.getAttribute("userSession"); 
    String displayHeaderName = "Student";
    String headerProfileImg = null;
    
    if(sessionUserHeader != null) {
        try {
            Connection conHeader = DBConnection.createConnection();
            String sqlHeader = "SELECT stu_Name, stu_Username, stu_Image FROM student WHERE stud_ID = ?";
            PreparedStatement psHeader = conHeader.prepareStatement(sqlHeader); 
            psHeader.setString(1, sessionUserHeader);
            
            ResultSet rsHeader = psHeader.executeQuery();
            if(rsHeader.next()) {
                String actualName = rsHeader.getString("stu_Name");
                String username = rsHeader.getString("stu_Username");
                displayHeaderName = (actualName != null && !actualName.isEmpty()) ? actualName : username;
                headerProfileImg = rsHeader.getString("stu_Image");
            }
            conHeader.close();
        } catch(Exception e) { e.printStackTrace(); }
    }
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">

<div class="top-navbar">
    <div class="search-wrapper">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input type="text" id="globalSearch" placeholder="Search elections, status..." onkeyup="filterContent()">
    </div>

    <div class="user-actions">
        <div class="header-icon-group">
            <div class="icon-container">
                <div class="icon-btn" onclick="toggleMenu('notifDropdown')">
                    <i class="fa-regular fa-bell"></i>
                    <span class="badge-dot"></span>
                </div>
                <div id="notifDropdown" class="dropdown-menu notifications">
                    <div class="dropdown-header">System Notifications</div>
                    <div class="dropdown-item notif-item">
                        <div class="notif-icon"><i class="fa-solid fa-bullhorn"></i></div>
                        <div class="notif-text">Official: "Student Council 2026" polls are now open.</div>
                    </div>
                    <div class="dropdown-item notif-item">
                        <div class="notif-icon warning"><i class="fa-solid fa-clock"></i></div>
                        <div class="notif-text">Reminder: Your vote for "MPP Selection" is still pending.</div>
                    </div>
                </div>
            </div>

            <div class="icon-container">
                <div class="icon-btn" onclick="toggleMenu('helpDropdown')">
                    <i class="fa-regular fa-circle-question"></i>
                </div>
                <div id="helpDropdown" class="dropdown-menu help-center">
                    <div class="dropdown-header">Help & Support</div>
                    <a href="javascript:void(0)" class="dropdown-item" onclick="openPopup('guidelinesModal')">
                        <i class="fa-solid fa-book"></i> Voting Guidelines
                    </a>
                </div>
            </div>
        </div>

        <div class="header-divider"></div>

        <div class="profile-container" onclick="toggleMenu('studentProfileMenu')">
            <div class="avatar-wrapper">
                <% if(headerProfileImg != null && !headerProfileImg.trim().isEmpty() && !headerProfileImg.equals("default.png")) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= headerProfileImg %>" class="header-avatar" alt="Profile">
                <% } else { %>
                    <div class="avatar-fallback"><%= displayHeaderName.substring(0,1).toUpperCase() %></div>
                <% } %>
            </div>
            <div class="user-meta">
                <span class="user-name"><%= displayHeaderName %></span>
                <span class="user-role">Student Voter</span>
            </div>
            <i class="fa-solid fa-chevron-down dropdown-arrow"></i>

            <div class="dropdown-menu" id="studentProfileMenu">
                <a href="studentProfile.jsp" class="dropdown-item">
                    <i class="fa-regular fa-user"></i> My Profile
                </a>
                <div class="dropdown-line"></div>
                <a href="javascript:void(0);" onclick="confirmLogout()" class="dropdown-item logout-text">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                </a>
            </div>
        </div>
    </div>
</div>

<div id="guidelinesModal" class="modal-overlay">
    <div class="modal-box large">
        <div class="modal-header-main">
            <h3><i class="fa-solid fa-book-open-reader"></i> Voting Guidelines</h3>
            <span class="close-modal" onclick="closePopup('guidelinesModal')">&times;</span>
        </div>
        <div class="modal-body-scroll">
            <p>Please read the following guidelines before casting your vote:</p>
            <div class="guideline-card">
                <div class="guide-item">
                    <i class="fa-solid fa-1"></i>
                    <span>Each student is entitled to only <strong>one vote</strong> per election category.</span>
                </div>
                <div class="guide-item">
                    <i class="fa-solid fa-2"></i>
                    <span>Once a vote is submitted, it <strong>cannot be modified</strong> or retracted.</span>
                </div>
                <div class="guide-item">
                    <i class="fa-solid fa-3"></i>
                    <span>All votes are encrypted and anonymous to ensure election integrity.</span>
                </div>
                <div class="guide-item">
                    <i class="fa-solid fa-4"></i>
                    <span>System session will expire after 15 minutes of inactivity.</span>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn-confirm" onclick="closePopup('guidelinesModal')">I Understand</button>
        </div>
    </div>
</div>

<script>
/**
 * Toggles a specific menu while closing others
 */
function toggleMenu(id) {
    document.querySelectorAll('.dropdown-menu').forEach(menu => {
        if(menu.id !== id) menu.classList.remove('show');
    });
    const menu = document.getElementById(id);
    menu.classList.toggle('show');
}

/**
 * Modal Control Functions
 */
function openPopup(id) {
    document.querySelectorAll('.dropdown-menu').forEach(m => m.classList.remove('show'));
    document.getElementById(id).style.display = "flex";
}

function closePopup(id) {
    document.getElementById(id).style.display = "none";
}

window.addEventListener('click', function(event) {
    if (!event.target.closest('.icon-container') && !event.target.closest('.profile-container')) {
        document.querySelectorAll('.dropdown-menu').forEach(m => m.classList.remove('show'));
    }
    if (event.target.classList.contains('modal-overlay')) {
        event.target.style.display = 'none';
    }
});
</script>