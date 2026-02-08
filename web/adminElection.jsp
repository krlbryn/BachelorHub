<%-- 
    Document   : adminElection.jsp
    Created on : Jan 29, 2026, 1:24:50 PM
    Author     : Karl
--%>
<%-- 
    Updated on : Feb 08, 2026
    Description: Admin Election Management with Modular Header & Theme
--%>

<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Security Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Get Alert Messages
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Elections | ElectVote Admin</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* --- iVOTE THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-secondary: #4A90E2;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
            --ev-success: #00c853;
            --ev-danger: #ff1744;
            --ev-warning: #ffc107;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--ev-bg);
            color: var(--ev-text);
            padding-left: 260px; /* Sidebar Width */
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- PAGE HEADER (Below Navbar) --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        .header-info { color: var(--ev-muted); font-size: 14px; }

        /* --- ACTION BAR --- */
        .action-bar {
            background: var(--ev-card); padding: 20px 25px; border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03); display: flex;
            justify-content: space-between; align-items: center; margin-bottom: 25px;
        }
        .list-title { font-size: 18px; font-weight: 600; color: var(--ev-text); display: flex; align-items: center; gap: 10px; }
        
        .btn-create {
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white; padding: 12px 25px; border: none; border-radius: 12px;
            font-weight: 600; cursor: pointer; box-shadow: 0 4px 15px rgba(30, 86, 160, 0.3);
            display: flex; align-items: center; gap: 8px; transition: 0.3s;
        }
        .btn-create:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.4); }

        /* --- TABLE STYLING --- */
        .table-container { background: var(--ev-card); border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); overflow: hidden; }
        .election-table { width: 100%; border-collapse: collapse; }
        .election-table th { background: #FAFBFF; text-align: left; padding: 18px 25px; font-weight: 600; color: var(--ev-muted); font-size: 13px; text-transform: uppercase; border-bottom: 1px solid #E8EEF3; }
        .election-table td { padding: 20px 25px; border-bottom: 1px solid #E8EEF3; vertical-align: middle; color: var(--ev-text); font-size: 14px; }
        .election-table tr:hover { background-color: #F8F9FC; }
        .table-img { width: 45px; height: 45px; border-radius: 10px; object-fit: cover; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        /* --- DATE & TIME --- */
        .date-container { display: flex; flex-direction: column; }
        .date-main { font-weight: 600; font-size: 13px; color: #1a1a3d; }
        .time-sub { font-size: 11px; color: #8A92A6; margin-top: 2px; font-weight: 500; }

        /* --- STATUS BADGES --- */
        .status { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status.active { background: rgba(0, 200, 83, 0.15); color: #00c853; }
        .status.upcoming { background: rgba(255, 193, 7, 0.15); color: #f9a825; }
        .status.closed { background: rgba(255, 23, 68, 0.15); color: #ff1744; }

        /* --- ACTION BUTTONS --- */
        .action-group { display: flex; gap: 8px; }
        .action-btn { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; text-decoration: none; transition: 0.2s; font-size: 13px; }
        .btn-view { background: rgba(74, 144, 226, 0.1); color: var(--ev-secondary); }
        .btn-view:hover { background: var(--ev-secondary); color: white; }
        .btn-edit { background: rgba(255, 193, 7, 0.1); color: #f9a825; }
        .btn-edit:hover { background: #ffc107; color: white; }
        .btn-delete { background: rgba(255, 23, 68, 0.1); color: var(--ev-danger); }
        .btn-delete:hover { background: var(--ev-danger); color: white; }

        /* --- ALERTS --- */
        .alert-box { padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; }
        .alert-success { background: rgba(0, 200, 83, 0.1); color: #00c853; border-left: 4px solid #00c853; }
        .alert-danger { background: rgba(255, 23, 68, 0.1); color: #ff1744; border-left: 4px solid #ff1744; }
        .alert-warning { background: rgba(255, 193, 7, 0.1); color: #f9a825; border-left: 4px solid #ffc107; }

        /* --- MODAL --- */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(26, 26, 61, 0.6); backdrop-filter: blur(4px); z-index: 2000; justify-content: center; align-items: center; }
        .modal-content { background: white; padding: 35px; border-radius: 20px; width: 650px; box-shadow: 0 25px 50px rgba(0,0,0,0.2); animation: slideUp 0.3s ease-out; max-height: 90vh; overflow-y: auto; }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .modal-title { font-size: 22px; font-weight: 700; color: var(--ev-primary); margin: 0; }
        .close-btn { background: none; border: none; font-size: 28px; cursor: pointer; color: var(--ev-muted); }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 13px; font-weight: 600; color: var(--ev-text); }
        .form-control { width: 100%; padding: 12px; border: 2px solid #E8EEF3; border-radius: 10px; font-family: 'Poppins', sans-serif; font-size: 14px; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: var(--ev-primary); background: #F9FBFD; }
        
        .row-split { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .checkbox-container { border: 2px solid #E8EEF3; border-radius: 10px; padding: 15px; height: 120px; overflow-y: auto; background: #FAFBFF; }
        .checkbox-item { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; font-size: 13px; }
        .checkbox-item input { accent-color: var(--ev-primary); width: 16px; height: 16px; }

        .modal-footer { display: flex; gap: 15px; margin-top: 30px; justify-content: flex-end; }
        .btn-save { background: var(--ev-primary); color: white; padding: 12px 30px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }
        .btn-cancel-red { background: #F4F7FE; color: var(--ev-muted); padding: 12px 25px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }
        .file-upload-box { padding: 9px; background: white; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Manage Elections</h1>
            <div class="header-info">Create, monitor, and update election events.</div>
        </div>

        <div class="action-bar">
            <div class="list-title">
                <i class="fa-solid fa-list-check" style="color: var(--ev-primary);"></i> 
                Election Overview
            </div>
            <button onclick="openModal()" class="btn-create">
                <i class="fa-solid fa-plus"></i> New Election
            </button>
        </div>

        <% if("success".equals(msg)) { %>
            <div class="alert-box alert-success"><i class="fa-solid fa-check-circle"></i> Election created successfully!</div>
        <% } else if("deleted".equals(msg)) { %>
            <div class="alert-box alert-danger"><i class="fa-solid fa-trash-can"></i> Election has been deleted.</div>
        <% } else if("constraint".equals(msg)) { %>
            <div class="alert-box alert-warning"><i class="fa-solid fa-triangle-exclamation"></i> Cannot delete: Election has active votes.</div>
        <% } else if("error".equals(msg)) { %>
            <div class="alert-box alert-danger"><i class="fa-solid fa-circle-xmark"></i> An unexpected error occurred.</div>
        <% } %>

        <div class="table-container">
            <table class="election-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Banner</th>
                        <th>Title</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection con = DBConnection.createConnection();
                            String sql = "SELECT * FROM election ORDER BY election_ID DESC";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);
                            
                            // Formatters
                            SimpleDateFormat displayDate = new SimpleDateFormat("MMM dd, yyyy");
                            SimpleDateFormat displayTime = new SimpleDateFormat("hh:mm a");

                            while(rs.next()) {
                                String rawId = rs.getString("election_ID");
                                String displayID = String.format("E%02d", Integer.parseInt(rawId));
                                String eName = rs.getString("election_Title");
                                String eStatus = rs.getString("election_Status");
                                String eImg = rs.getString("election_Image");
                                if(eImg == null || eImg.isEmpty()) eImg = "default_election.jpg";
                                
                                // Dates
                                Timestamp startTs = rs.getTimestamp("election_StartDate");
                                Timestamp endTs = rs.getTimestamp("election_EndDate");
                                
                                String sDateStr = "N/A", sTimeStr = "";
                                String eDateStr = "N/A", eTimeStr = "";

                                if(startTs != null) {
                                    sDateStr = displayDate.format(startTs);
                                    sTimeStr = displayTime.format(startTs);
                                }
                                if(endTs != null) {
                                    eDateStr = displayDate.format(endTs);
                                    eTimeStr = displayTime.format(endTs);
                                }
                                
                                String statusClass = "closed";
                                if(eStatus != null && eStatus.equalsIgnoreCase("Active")) statusClass = "active";
                                else if(eStatus != null && eStatus.equalsIgnoreCase("Upcoming")) statusClass = "upcoming";
                    %>
                    <tr>
                        <td><strong style="color: var(--ev-primary);"><%= displayID %></strong></td>
                        <td><img src="images/<%= eImg %>" class="table-img" alt="Election Banner"></td>
                        <td><strong><%= eName %></strong></td>
                        
                        <td>
                            <div class="date-container">
                                <span class="date-main"><%= sDateStr %></span>
                                <span class="time-sub"><%= sTimeStr %></span>
                            </div>
                        </td>
                        <td>
                            <div class="date-container">
                                <span class="date-main"><%= eDateStr %></span>
                                <span class="time-sub"><%= eTimeStr %></span>
                            </div>
                        </td>
                        
                        <td><span class="status <%= statusClass %>"><%= eStatus %></span></td>
                        <td>
                            <div class="action-group">
                                <a href="adminViewCandidates.jsp?eid=<%= rawId %>" class="action-btn btn-view" title="View Candidates"><i class="fa-solid fa-users"></i></a>
                                <a href="adminEditElection.jsp?eid=<%= rawId %>" class="action-btn btn-edit" title="Edit Election"><i class="fa-solid fa-pen"></i></a>
                                <a href="AdminElectionDeleteServlet?eid=<%= rawId %>" class="action-btn btn-delete" onclick="return confirm('Delete this election? This cannot be undone.')" title="Delete"><i class="fa-solid fa-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                            con.close();
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </tbody>
            </table>
        </div>
    </main>

    <div id="createModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Create New Election</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            
            <form action="AdminElectionCreateServlet" method="post" enctype="multipart/form-data">
                
                <div class="form-group">
                    <label>Election Title</label>
                    <input type="text" name="eName" class="form-control" placeholder="e.g., Student Council 2026" required>
                </div>

                <div class="form-group">
                    <label>Description</label>
                    <input type="text" name="eDesc" class="form-control" placeholder="Short description..." required>
                </div>

                <div class="row-split">
                    <div class="form-group">
                        <label>Start Date & Time</label>
                        <input type="datetime-local" name="startDate" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label>End Date & Time</label>
                        <input type="datetime-local" name="endDate" class="form-control" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <select name="eStatus" class="form-control">
                        <option value="Upcoming">Upcoming</option>
                        <option value="Active">Active</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>

                <div class="row-split">
                    <div class="form-group">
                        <label>Positions Included</label>
                        <div class="checkbox-container">
                            <%
                                try {
                                    Connection conPos = DBConnection.createConnection();
                                    String sqlPos = "SELECT DISTINCT position_Name FROM position ORDER BY position_Name"; 
                                    Statement stPos = conPos.createStatement();
                                    ResultSet rsPos = stPos.executeQuery(sqlPos);
                                    while(rsPos.next()) {
                                        String pName = rsPos.getString("position_Name"); 
                            %>
                                <div class="checkbox-item">
                                    <input type="checkbox" name="positions" value="<%= pName %>"> 
                                    <span><%= pName %></span>
                                </div>
                            <%
                                    }
                                    conPos.close();
                                } catch (Exception e) { out.print("Error loading positions"); }
                            %>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Banner Image</label>
                        <input type="file" name="eImage" class="form-control file-upload-box">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-cancel-red" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn-save">Create Election</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { document.getElementById('createModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('createModal').style.display = 'none'; }
        
        window.onclick = function(event) {
            var modal = document.getElementById('createModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>

</body>
</html>