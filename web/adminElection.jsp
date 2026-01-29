<%-- 
    Document   : adminElection
    Created on : Jan 29, 2026, 1:24:50 PM
    Author     : Karl
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Check (Security)
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Get Messages (for alerts)
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Elections</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminHeader.css">
    
    <style>
        /* --- DASHBOARD SPECIFIC STYLES --- */
        .top-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .btn-create { background-color: #007bff; color: white; padding: 12px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; transition: 0.3s; }
        .btn-create:hover { background-color: #0056b3; }
        
        /* Table Styling */
        .election-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .election-table th { background-color: #f8f9fa; text-align: left; padding: 15px; border-bottom: 2px solid #dee2e6; color: #495057; }
        .election-table td { padding: 15px; border-bottom: 1px solid #dee2e6; vertical-align: middle; }
        
        /* Image Thumbnail in Table */
        .table-img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; }
        
        /* Status Badges */
        .status { padding: 5px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: bold; }
        .status.active { background-color: #d4edda; color: #155724; }
        .status.upcoming { background-color: #fff3cd; color: #856404; }
        .status.closed { background-color: #f8d7da; color: #721c24; }

        /* Action Buttons */
        .action-btn { padding: 6px 12px; border-radius: 4px; text-decoration: none; color: white; font-size: 0.9rem; margin-right: 5px; transition: 0.2s; }
        .btn-view { background-color: #17a2b8; }
        .btn-edit { background-color: #ffc107; color: black; }
        .btn-delete { background-color: #dc3545; }
        .action-btn:hover { opacity: 0.8; }

        /* --- MODAL (POP-UP) STYLES --- */
        .modal-overlay {
            display: none; /* Hidden by default */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); z-index: 1000;
            justify-content: center; align-items: center;
        }

        .modal-content { 
            background-color: white; padding: 30px; border-radius: 8px; 
            width: 700px; /* Wide enough for split columns */
            box-shadow: 0 4px 15px rgba(0,0,0,0.2); position: relative;
            animation: slideDown 0.3s ease-out; font-family: 'serif';
        }
        
        @keyframes slideDown { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header { display: flex; justify-content: center; position: relative; margin-bottom: 20px; }
        .modal-title { font-family: 'Times New Roman', serif; font-size: 2rem; font-weight: bold; margin: 0; }
        .close-btn { position: absolute; right: 0; top: 0; background: none; border: none; font-size: 2rem; cursor: pointer; color: #333; line-height: 1; }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; font-family: sans-serif; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #aaa; border-radius: 4px; }
        
        /* Grid for Split Rows (Dates & Positions) */
        .row-split { display: flex; gap: 30px; }
        .col-half { flex: 1; }

        /* Checkbox Area */
        .checkbox-group { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 5px; height: 100px; overflow-y: auto; border: 1px solid #eee; padding: 5px; }
        .checkbox-item { display: flex; align-items: center; gap: 8px; font-size: 0.95rem; font-family: sans-serif; }

        /* Footer Buttons */
        .modal-footer { display: flex; gap: 15px; margin-top: 25px; }
        .btn-save { background-color: #00c853; color: white; padding: 10px 35px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 1rem; }
        .btn-cancel-red { background-color: #ff1744; color: white; padding: 10px 35px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; font-size: 1rem; }
        
        .file-upload-box { background: #eee; padding: 5px; border: 1px solid #ccc; width: 100%; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">

    <div class="top-header">
        <h1 class="header-title">Manage Elections</h1>
        <div class="header-info">Create, monitor, and update election events</div>
    </div>


    <div class="action-bar" style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; background:#fff; padding:15px 20px; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.05);">
        
        <div style="font-weight:600; color:#555; font-size:1.1rem;">
            <i class="fa-solid fa-list-ul" style="margin-right:8px; color:#007bff;"></i> Elections List
        </div>

        <button onclick="openModal()" class="btn-create">
            <i class="fa-solid fa-plus"></i> New Election
        </button>
    </div>


    <% if("success".equals(msg)) { %>
        <div style="background:#d4edda; color:#155724; padding:15px; border-radius:5px; margin-bottom:20px; border: 1px solid #c3e6cb;">
            <i class="fa-solid fa-check-circle"></i> Action completed successfully!
        </div>
    <% } %>

    <table class="election-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Image</th>
                <th>Election Title</th>
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

                    while(rs.next()) {
                        String rawId = rs.getString("election_ID");
                        int idNum = Integer.parseInt(rawId);
                        String displayID = String.format("E%02d", idNum);
                        
                        // ... (Rest of your existing loop code) ...
                        String eName = rs.getString("election_Title");
                        String eStatus = rs.getString("election_Status");
                        String sDate = rs.getString("election_StartDate");
                        String eDate = rs.getString("election_EndDate");
                        String eImg = rs.getString("election_Image");
                        if(eImg == null || eImg.isEmpty()) eImg = "default_election.jpg";
                        
                        String statusClass = "closed";
                        if(eStatus != null && eStatus.equalsIgnoreCase("Active")) statusClass = "active";
                        else if(eStatus != null && eStatus.equalsIgnoreCase("Upcoming")) statusClass = "upcoming";
            %>
            <tr>
                <td><strong><%= displayID %></strong></td>
                <td><img src="images/<%= eImg %>" class="table-img" alt="Icon"></td>
                <td><strong><%= eName %></strong></td>
                <td><%= sDate %></td>
                <td><%= eDate %></td>
                <td><span class="status <%= statusClass %>"><%= eStatus %></span></td>
                <td>
                    <a href="adminViewCandidates.jsp?eid=<%= rawId %>" class="action-btn btn-view"><i class="fa-solid fa-users"></i></a>
                    <a href="adminEditElection.jsp?eid=<%= rawId %>" class="action-btn btn-edit"><i class="fa-solid fa-pen"></i></a>
                    <a href="adminDeleteElection.jsp?eid=<%= rawId %>" class="action-btn btn-delete" onclick="return confirm('Delete?')"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
            <%
                    }
                    con.close();
                } catch (Exception e) { e.printStackTrace(); }
            %>
        </tbody>
    </table>

</main>

    <div id="createModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Create New Election</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            
            <form action="AdminElectionCreateServlet" method="post" enctype="multipart/form-data">
                
                <div class="form-group">
                    <label>Election Name :</label>
                    <input type="text" name="eName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Description :</label>
                    <input type="text" name="eDesc" class="form-control" required>
                </div>

                <div class="row-split">
                    <div class="col-half form-group">
                        <label>Start Date :</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-half form-group">
                        <label>End Date :</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                </div>

                <div class="form-group" style="width: 50%;">
                    <label>Status :</label>
                    <select name="eStatus" class="form-control">
                        <option value="Upcoming">Upcoming</option>
                        <option value="Active">Active</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>

                <div class="row-split">
                    <div class="col-half form-group">
                        <label>Position Included :</label>
                        <div class="checkbox-group">
                            <%
                                // Fetch Positions from Database for Checkboxes
                                try {
                                    Connection conPos = DBConnection.createConnection();
                                    String sqlPos = "SELECT * FROM position"; 
                                    Statement stPos = conPos.createStatement();
                                    ResultSet rsPos = stPos.executeQuery(sqlPos);
                                    while(rsPos.next()) {
                                        String pName = rsPos.getString("position_Name"); 
                            %>
                                        <div class="checkbox-item">
                                            <input type="checkbox" name="positions" value="<%= pName %>"> 
                                            <%= pName %>
                                        </div>
                            <%
                                    }
                                    conPos.close();
                                } catch (Exception e) { out.print("Error loading positions"); }
                            %>
                        </div>
                    </div>
                    
                    <div class="col-half form-group">
                        <label>Upload Photo :</label>
                        <input type="file" name="eImage" class="file-upload-box">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="submit" class="btn-save">SAVE</button>
                    <button type="button" class="btn-cancel-red" onclick="closeModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { document.getElementById('createModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('createModal').style.display = 'none'; }
        
        // Close modal if user clicks outside the white box
        window.onclick = function(event) {
            var modal = document.getElementById('createModal');
            if (event.target == modal) modal.style.display = "none";
        }
    </script>

</body>
</html>