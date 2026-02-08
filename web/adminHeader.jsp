<%-- 
    Document   : adminHeader.jsp
    Description: Admin Header with Real Database Photo & Help Modal
--%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Get Session Data
    String sessionUserHeader = (String) session.getAttribute("userSession"); // Username
    String displayHeaderName = (String) session.getAttribute("userName");    // Full Name (optional)
    if(displayHeaderName == null) displayHeaderName = "Admin";
    
    // 2. Fetch Actual Profile Photo from DB
    String headerProfileImg = null;
    
    if(sessionUserHeader != null) {
        try {
            Connection conHeader = DBConnection.createConnection();
            PreparedStatement psHeader = conHeader.prepareStatement("SELECT admin_Image FROM admin WHERE admin_username = ?");
            psHeader.setString(1, sessionUserHeader);
            ResultSet rsHeader = psHeader.executeQuery();
            
            if(rsHeader.next()) {
                headerProfileImg = rsHeader.getString("admin_Image");
            }
            conHeader.close();
        } catch(Exception e) { e.printStackTrace(); }
    }
%>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminHeader.css">

<style>
    .help-modal-overlay {
        display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.5); z-index: 3000; justify-content: center; align-items: center;
        animation: fadeIn 0.2s ease-out;
    }
    .help-modal {
        background: white; width: 400px; padding: 30px; border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2); text-align: center; position: relative;
    }
    .help-icon { font-size: 50px; color: #1E56A0; margin-bottom: 20px; }
    .help-title { font-size: 20px; font-weight: 700; color: #333; margin-bottom: 10px; }
    .help-text { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 25px; }
    .btn-close-help {
        background: #1E56A0; color: white; border: none; padding: 10px 25px;
        border-radius: 6px; cursor: pointer; font-weight: 600;
    }
    .btn-close-help:hover { background: #154585; }
    
    /* Ensure Header Profile Pic is a perfect circle and fits */
    .header-profile-pic {
        width: 40px; height: 40px; border-radius: 50%; object-fit: cover;
        border: 2px solid #E8EEF3;
    }
</style>

<div class="top-navbar">
    <div class="search-wrapper">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input type="text" id="globalSearch" placeholder="Search elections, status..." onkeyup="filterTable()">
    </div>

    <div class="user-actions">
        
        <div class="icon-container">
            <div class="icon-btn" onclick="toggleMenu('notificationMenu')">
                <i class="fa-regular fa-bell"></i>
                <span class="badge-dot"></span>
            </div>
            <div class="dropdown-menu notifications" id="notificationMenu">
                <div class="dropdown-header">Notifications</div>
                <div class="dropdown-item unread">
                    <div class="notif-icon"><i class="fa-solid fa-check-to-slot"></i></div>
                    <div class="notif-text">New vote cast in <strong>Student Council</strong></div>
                </div>
                <div class="dropdown-item">
                    <div class="notif-icon warning"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div class="notif-text">Election <strong>E26</strong> is ending soon</div>
                </div>
            </div>
        </div>
        
        <div class="icon-btn" onclick="openHelpModal()" title="Help Center">
            <i class="fa-regular fa-circle-question"></i>
        </div>

        <div class="icon-container">
            <div class="profile-menu" onclick="toggleMenu('profileMenu')">
                
                <%-- LOGIC: Show DB Image if exists, otherwise show UI Avatar --%>
                <% if(headerProfileImg != null && !headerProfileImg.isEmpty() && !headerProfileImg.equals("default.png")) { %>
                    <img src="${pageContext.request.contextPath}/images/<%= headerProfileImg %>" class="header-profile-pic" alt="Profile">
                <% } else { %>
                    <img src="https://ui-avatars.com/api/?name=<%= displayHeaderName %>&background=E3F2FD&color=1E56A0&bold=true" class="header-profile-pic" alt="Profile">
                <% } %>

                <div class="user-info">
                    <span class="user-name"><%= displayHeaderName %></span>
                    <span class="user-role">Administrator</span>
                </div>
                <i class="fa-solid fa-chevron-down dropdown-icon"></i>
            </div>

            <div class="dropdown-menu profile" id="profileMenu">
                <a href="adminProfile.jsp" class="dropdown-item">
                    <i class="fa-regular fa-user"></i> My Profile
                </a>
                <div class="dropdown-divider"></div>
                <a href="javascript:void(0);" onclick="openLogoutModal()" class="dropdown-item logout">
                    <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                </a>
            </div>
        </div>
    </div>
</div>

<div id="helpModal" class="help-modal-overlay">
    <div class="help-modal">
        <i class="fa-solid fa-headset help-icon"></i>
        <div class="help-title">Need Assistance?</div>
        <div class="help-text">
            For technical issues or account support, please contact the IT department.<br><br>
            <strong>Email:</strong> support@electvote.edu<br>
            <strong>Hotline:</strong> +60 123-456-789
        </div>
        <button class="btn-close-help" onclick="closeHelpModal()">Close</button>
    </div>
</div>

<script>
    // 1. Search Functionality
    function filterTable() {
        var input, filter, table, tr, td, i;
        input = document.getElementById("globalSearch");
        filter = input.value.toUpperCase();
        table = document.querySelector(".election-table"); 
        if (table) {
            tr = table.getElementsByTagName("tr");
            for (i = 1; i < tr.length; i++) { 
                var tdTitle = tr[i].getElementsByTagName("td")[2]; 
                var tdStatus = tr[i].getElementsByTagName("td")[5];
                if (tdTitle || tdStatus) {
                    var titleText = tdTitle ? (tdTitle.textContent || tdTitle.innerText) : "";
                    var statusText = tdStatus ? (tdStatus.textContent || tdStatus.innerText) : "";
                    if (titleText.toUpperCase().indexOf(filter) > -1 || statusText.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    }

    // 2. Dropdown Toggle
    function toggleMenu(menuId) {
        var allMenus = document.querySelectorAll('.dropdown-menu');
        allMenus.forEach(function(menu) {
            if (menu.id !== menuId) menu.classList.remove('show');
        });
        var menu = document.getElementById(menuId);
        menu.classList.toggle('show');
    }

    // 3. Help Modal Logic
    function openHelpModal() { document.getElementById('helpModal').style.display = 'flex'; }
    function closeHelpModal() { document.getElementById('helpModal').style.display = 'none'; }

    // Close on Outside Click
    window.onclick = function(event) {
        if (!event.target.closest('.icon-container')) {
            var dropdowns = document.getElementsByClassName("dropdown-menu");
            for (var i = 0; i < dropdowns.length; i++) {
                if (dropdowns[i].classList.contains('show')) dropdowns[i].classList.remove('show');
            }
        }
        if (event.target == document.getElementById('helpModal')) closeHelpModal();
    }
</script>