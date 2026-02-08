<%-- 
    Document   : adminViewCandidates
    Created on : Jan 30, 2026, 12:00:08 AM
    Author     : Karl
--%>


<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 2. Get Parameters
    String eid = request.getParameter("eid"); // Election ID
    String msg = request.getParameter("msg"); // Messages
    String currentElectionName = "Select an Election";
    
    // 3. Fetch Election Name for display
    if(eid != null && !eid.isEmpty()) {
        try {
            Connection con = DBConnection.createConnection();
            PreparedStatement ps = con.prepareStatement("SELECT election_Title FROM election WHERE election_ID = ?");
            ps.setString(1, eid);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) currentElectionName = rs.getString("election_Title");
            con.close();
        } catch(Exception e) {}
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Candidates | ElectVote Admin</title>
    
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
            padding-left: 260px; 
            margin: 0;
        }

        .main-content { padding: 30px 40px; }

        /* --- HEADER & FILTER BAR --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        
        /* Filter Card */
        .filter-card {
            background: var(--ev-card);
            padding: 20px 25px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            border: 1px solid #E8EEF3;
        }

        .filter-group { display: flex; align-items: center; gap: 15px; flex-grow: 1; }
        .filter-label { font-weight: 600; color: var(--ev-text); font-size: 14px; }
        
        .election-select {
            padding: 10px 15px;
            border-radius: 10px;
            border: 2px solid #E8EEF3;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: #1a1a3d;
            width: 300px;
            background-color: #F9FBFD;
            cursor: pointer;
            transition: 0.3s;
        }
        .election-select:focus { outline: none; border-color: var(--ev-primary); background: white; }

        .btn-create {
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white; padding: 10px 25px; border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer; box-shadow: 0 4px 15px rgba(30, 86, 160, 0.3);
            display: flex; align-items: center; gap: 8px; transition: 0.3s; font-size: 14px;
        }
        .btn-create:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.4); }

        /* --- TABLE STYLING --- */
        .table-container { background: var(--ev-card); border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.03); overflow: hidden; }
        .election-table { width: 100%; border-collapse: collapse; }
        .election-table th { background: #FAFBFF; text-align: left; padding: 18px 25px; font-weight: 600; color: var(--ev-muted); font-size: 13px; text-transform: uppercase; border-bottom: 1px solid #E8EEF3; }
        .election-table td { padding: 20px 25px; border-bottom: 1px solid #E8EEF3; vertical-align: middle; color: var(--ev-text); font-size: 14px; }
        .election-table tr:hover { background-color: #F8F9FC; }
        
        .candidate-img { width: 50px; height: 50px; border-radius: 50%; object-fit: cover; border: 2px solid #E8EEF3; }
        .candidate-info { display: flex; flex-direction: column; }
        .cand-name { font-weight: 600; color: #1a1a3d; }
        .cand-id { font-size: 12px; color: #8A92A6; }

        /* Badges */
        .position-badge { 
            background: rgba(74, 144, 226, 0.1); color: var(--ev-secondary); 
            padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; 
        }

        /* Buttons */
        .btn-delete { 
            width: 35px; height: 35px; border-radius: 8px; 
            display: flex; align-items: center; justify-content: center; 
            background: rgba(255, 23, 68, 0.1); color: var(--ev-danger); 
            text-decoration: none; transition: 0.2s; 
        }
        .btn-delete:hover { background: var(--ev-danger); color: white; }

        /* Alerts */
        .alert-box { padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; }
        .alert-success { background: rgba(0, 200, 83, 0.1); color: #00c853; border-left: 4px solid #00c853; }
        .alert-danger { background: rgba(255, 23, 68, 0.1); color: #ff1744; border-left: 4px solid #ff1744; }
        .alert-warning { background: rgba(255, 193, 7, 0.1); color: #f9a825; border-left: 4px solid #ffc107; }

        /* --- MODAL --- */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(26, 26, 61, 0.6); backdrop-filter: blur(4px); z-index: 2000; justify-content: center; align-items: center; }
        .modal-content { background: white; padding: 35px; border-radius: 20px; width: 500px; box-shadow: 0 25px 50px rgba(0,0,0,0.2); animation: slideUp 0.3s ease-out; }
        @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .modal-title { font-size: 20px; font-weight: 700; color: var(--ev-primary); margin: 0; }
        .close-btn { background: none; border: none; font-size: 24px; cursor: pointer; color: var(--ev-muted); }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 13px; font-weight: 600; color: var(--ev-text); }
        .form-control { width: 100%; padding: 12px; border: 2px solid #E8EEF3; border-radius: 10px; font-family: 'Poppins', sans-serif; font-size: 14px; box-sizing: border-box; }
        .form-control:focus { outline: none; border-color: var(--ev-primary); background: #F9FBFD; }

        .modal-footer { display: flex; gap: 15px; margin-top: 30px; justify-content: flex-end; }
        .btn-save { background: var(--ev-primary); color: white; padding: 12px 30px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }
        .btn-cancel-red { background: #F4F7FE; color: var(--ev-muted); padding: 12px 25px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; }
        .file-upload-box { padding: 9px; background: white; }
        
        /* Empty State */
        .empty-state { text-align: center; padding: 60px; color: var(--ev-muted); }
        .empty-icon { font-size: 40px; margin-bottom: 15px; opacity: 0.5; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">

        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Manage Candidates</h1>
            <div style="color: #8A92A6; font-size: 14px;">Register and manage candidates for: <strong style="color: var(--ev-primary);"><%= currentElectionName %></strong></div>
        </div>

        <div class="filter-card">
            <div class="filter-group">
                <span class="filter-label">Select Election:</span>
                <select class="election-select" onchange="window.location.href='adminViewCandidates.jsp?eid='+this.value">
                    <option value="" disabled <%= (eid == null) ? "selected" : "" %>>-- Choose Election --</option>
                    <%
                        try {
                            Connection conH = DBConnection.createConnection();
                            String sqlH = "SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC";
                            ResultSet rsH = conH.createStatement().executeQuery(sqlH);
                            while(rsH.next()) {
                                String id = rsH.getString("election_ID");
                                String title = rsH.getString("election_Title");
                                String sel = (id.equals(eid)) ? "selected" : "";
                    %>
                        <option value="<%= id %>" <%= sel %>><%= title %></option>
                    <%
                            }
                            conH.close();
                        } catch(Exception e) {}
                    %>
                </select>
            </div>

            <% if(eid != null && !eid.isEmpty()) { %>
                <button onclick="openModal()" class="btn-create">
                    <i class="fa-solid fa-user-plus"></i> Add Candidate
                </button>
            <% } %>
        </div>

        <% if("success".equals(msg)) { %>
            <div class="alert-box alert-success"><i class="fa-solid fa-check-circle"></i> Candidate registered successfully!</div>
        <% } else if("deleted".equals(msg)) { %>
            <div class="alert-box alert-danger"><i class="fa-solid fa-trash-can"></i> Candidate removed successfully.</div>
        <% } else if("duplicate".equals(msg)) { %>
            <div class="alert-box alert-warning"><i class="fa-solid fa-triangle-exclamation"></i> Error: This student is already a candidate.</div>
        <% } else if("notfound".equals(msg)) { %>
            <div class="alert-box alert-danger"><i class="fa-solid fa-circle-xmark"></i> Error: Student ID not found in database.</div>
        <% } else if("error".equals(msg)) { %>
            <div class="alert-box alert-danger"><i class="fa-solid fa-circle-xmark"></i> Error: Database operation failed.</div>
        <% } %>

        <% if(eid != null && !eid.isEmpty()) { %>
            <div class="table-container">
                <table class="election-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">Photo</th>
                            <th style="width: 25%;">Candidate Info</th>
                            <th style="width: 20%;">Position</th>
                            <th style="width: 35%;">Manifesto</th>
                            <th style="width: 10%;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                Connection con = DBConnection.createConnection();
                                String sql = "SELECT c.cand_ID, c.cand_ManifestoDesc, c.cand_PhotoPath, c.candidate_Position, s.stu_Name, s.stud_ID " +
                                             "FROM candidate c " +
                                             "JOIN student s ON c.stud_ID = s.stud_ID " +
                                             "WHERE c.election_ID = ? " + 
                                             "ORDER BY c.candidate_Position";
                                             
                                PreparedStatement ps = con.prepareStatement(sql);
                                ps.setString(1, eid);
                                ResultSet rs = ps.executeQuery();
                                
                                boolean hasData = false;
                                while(rs.next()) {
                                    hasData = true;
                                    String cImg = rs.getString("cand_PhotoPath");
                                    if(cImg == null || cImg.isEmpty()) cImg = "default_user.png";
                        %>
                        <tr>
                            <td><img src="images/<%= cImg %>" class="candidate-img"></td>
                            <td>
                                <div class="candidate-info">
                                    <span class="cand-name"><%= rs.getString("stu_Name") %></span>
                                    <span class="cand-id"><%= rs.getString("stud_ID") %></span>
                                </div>
                            </td>
                            <td><span class="position-badge"><%= rs.getString("candidate_Position") %></span></td>
                            <td><div style="font-size: 13px; color: #5F6D7E; font-style: italic;">"<%= rs.getString("cand_ManifestoDesc") %>"</div></td>
                            <td>
                                <a href="AdminCandidateDeleteServlet?cid=<%= rs.getString("cand_ID") %>&eid=<%= eid %>" 
                                   class="btn-delete" 
                                   onclick="return confirm('Are you sure you want to remove this candidate?')" 
                                   title="Remove Candidate">
                                   <i class="fa-solid fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                                if(!hasData) {
                        %>
                            <tr><td colspan="5" style="text-align:center; padding:40px; color:#8A92A6;">No candidates registered yet.</td></tr>
                        <%
                                }
                                con.close();
                            } catch (Exception e) { e.printStackTrace(); }
                        %>
                    </tbody>
                </table>
            </div>
        <% } else { %>
            <div class="table-container empty-state">
                <i class="fa-solid fa-check-to-slot empty-icon"></i>
                <h3>Select an election to view candidates</h3>
                <p>Use the dropdown menu above to choose an election.</p>
            </div>
        <% } %>

    </main>

    <div id="addModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Register Candidate</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            
            <form action="AdminCandidateAddServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="eid" value="<%= eid %>">
                
                <div class="form-group">
                    <label>Student Matric No</label>
                    <input type="text" name="studID" class="form-control" placeholder="e.g., 2025123456" required>
                </div>

                <div class="form-group">
                    <label>Running For</label>
                    <select name="positionName" class="form-control" required>
                        <option value="" disabled selected>-- Select Position --</option>
                        <%
                            if(eid != null && !eid.isEmpty()) {
                                try {
                                    Connection conPos = DBConnection.createConnection();
                                    String sqlPos = "SELECT position_Name FROM position WHERE election_ID = ?";
                                    PreparedStatement psPos = conPos.prepareStatement(sqlPos);
                                    psPos.setString(1, eid);
                                    ResultSet rsPos = psPos.executeQuery();
                                    boolean found = false;
                                    while(rsPos.next()) {
                                        found = true;
                                        String pName = rsPos.getString("position_Name");
                        %>
                                <option value="<%= pName %>"><%= pName %></option>
                        <%
                                    }
                                    if(!found) { out.print("<option disabled>No positions found for this election</option>"); }
                                    conPos.close();
                                } catch(Exception e) {}
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label>Manifesto / Slogan</label>
                    <textarea name="cManifesto" class="form-control" rows="3" placeholder="Campaign promise..."></textarea>
                </div>
                
                <div class="form-group">
                    <label>Candidate Photo</label>
                    <input type="file" name="cImage" class="form-control file-upload-box">
                </div>

                <div class="modal-footer">
                    <button type="button" onclick="closeModal()" class="btn-cancel-red">Cancel</button>
                    <button type="submit" class="btn-save">Register Candidate</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { document.getElementById('addModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('addModal').style.display = 'none'; }
        
        window.onclick = function(e) { 
            if(e.target == document.getElementById('addModal')) closeModal(); 
        }
    </script>
</body>
</html>