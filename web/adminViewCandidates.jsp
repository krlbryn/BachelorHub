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
    String msg = request.getParameter("msg"); // Messages (success/error)
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
    <title>Manage Candidates</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* Local overrides for specific layout needs */
        .action-bar { margin-top: 25px; margin-bottom: 20px; }
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; padding: 30px; border-radius: 8px; width: 500px; animation: fadeIn 0.3s; }
        @keyframes fadeIn { from {opacity:0; transform:translateY(-20px);} to {opacity:1; transform:translateY(0);} }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">

        <div class="top-header">
            <h1 class="header-title">Manage Candidates</h1>
            <div class="header-info">
                <a href="adminElection.jsp" style="text-decoration:none; color:#007bff;">Elections</a> 
                <span style="color:#ccc; margin:0 5px;">/</span> 
                Candidate Registry
            </div>
        </div>

        <div class="action-bar">
            <div style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center;">
                
                <div style="flex-grow: 1; margin-right: 20px;">
                    <label style="display:block; font-weight:bold; color:#555; margin-bottom:5px;">Select Election:</label>
                    <select class="election-select form-control" onchange="window.location.href='adminViewCandidates.jsp?eid='+this.value">
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
                    <button onclick="openModal()" class="btn-create" style="height: 45px; margin-top: 20px;">
                        <i class="fa-solid fa-user-plus"></i> Add Candidate
                    </button>
                <% } %>
            </div>
        </div>

       <% if("success".equals(msg)) { %>
        <div style="padding:15px; background:#d4edda; color:#155724; border-radius:5px; margin-bottom:20px;">
            <i class="fa-solid fa-check-circle"></i> Candidate registered successfully!
        </div>

    <% } else if("deleted".equals(msg)) { %>
        <div style="padding:15px; background:#f8d7da; color:#721c24; border-radius:5px; margin-bottom:20px;">
            <i class="fa-solid fa-trash-can"></i> Candidate removed successfully.
        </div>
    <% } else if("duplicate".equals(msg)) { %>
        <div style="padding:15px; background:#fff3cd; color:#856404; border-radius:5px; margin-bottom:20px;">
            Error: This student is already a candidate.
        </div>
    <% } else if("notfound".equals(msg)) { %>
        <div style="padding:15px; background:#f8d7da; color:#721c24; border-radius:5px; margin-bottom:20px;">
            Error: Student ID not found.
        </div>
    <% } else if("error".equals(msg)) { %>
        <div style="padding:15px; background:#f8d7da; color:#721c24; border-radius:5px; margin-bottom:20px;">
            Error: Database operation failed.
        </div>
    <% } %>

        <% if(eid != null && !eid.isEmpty()) { %>
            <h3 style="margin-bottom:15px; color:#444;">List for: <span style="color:#0056b3;"><%= currentElectionName %></span></h3>
            
            <table class="election-table">
                <thead>
                    <tr>
                        <th style="width: 10%;">Photo</th>
                        <th style="width: 25%;">Student Info</th>
                        <th style="width: 20%;">Position</th>
                        <th style="width: 35%;">Manifesto</th>
                        <th style="width: 10%;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection con = DBConnection.createConnection();
                            // QUERY: Join Candidate and Student tables. Filter by election_ID.
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
                            <strong><%= rs.getString("stu_Name") %></strong><br>
                            <span style="color:#666; font-size:0.85rem;"><%= rs.getString("stud_ID") %></span>
                        </td>
                        <td><span class="status active" style="background:#e2e6ea; color:#333;"><%= rs.getString("candidate_Position") %></span></td>
                        <td><em style="color:#555;"><%= rs.getString("cand_ManifestoDesc") %></em></td>
                        <td>
                            <a href="AdminCandidateDeleteServlet?cid=<%= rs.getString("cand_ID") %>&eid=<%= eid %>" 
                               class="btn-delete" style="color:#dc3545;" 
                               onclick="return confirm('Are you sure you want to remove this candidate?')"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr>
                    <%
                            }
                            if(!hasData) { out.print("<tr><td colspan='5' style='text-align:center; padding:30px; color:#999;'>No candidates found for this election.</td></tr>"); }
                            con.close();
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </tbody>
            </table>
        <% } else { %>
            <div style="text-align:center; padding:60px; background:#fff; border-radius:8px; color:#aaa;">
                <i class="fa-solid fa-arrow-up" style="font-size:2rem; margin-bottom:15px;"></i>
                <p>Please select an election from the list above.</p>
            </div>
        <% } %>

    </main>

    <div id="addModal" class="modal-overlay">
        <div class="modal-content">
            <h2 class="modal-title" style="margin-bottom:20px; text-align:center;">Register Candidate</h2>
            
            <form action="AdminCandidateAddServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="eid" value="<%= eid %>">
                
                <div class="form-group">
                    <label>Student ID (Matric No)</label>
                    <input type="text" name="studID" class="form-control" placeholder="Ex: 2025164721" required>
                </div>

              <div class="form-group">
    <label>Position</label>
    <select name="positionName" class="form-control" required>
        <option value="" disabled selected>-- Select Position --</option>
        <%
            // 1. Get the current Election ID (eid) being viewed
            String currentEid = request.getParameter("eid");

            if(currentEid != null && !currentEid.isEmpty()) {
                Connection conPos = null;
                try {
                    conPos = DBConnection.createConnection();
                    
                    // 2. QUERY: Fetch positions ONLY for this specific election
                    String sqlPos = "SELECT position_Name FROM position WHERE election_ID = ?";
                    PreparedStatement psPos = conPos.prepareStatement(sqlPos);
                    psPos.setString(1, currentEid);
                    
                    ResultSet rsPos = psPos.executeQuery();
                    
                    boolean found = false;
                    while(rsPos.next()) {
                        found = true;
                        String pName = rsPos.getString("position_Name");
        %>
                        <option value="<%= pName %>"><%= pName %></option>
        <%
                    }
                    
                    // 3. Fallback: If no positions found in DB, show a default (Safety Net)
                    if(!found) {
        %>
                        <option value="" disabled>No positions found for Election ID <%= currentEid %></option>
        <%
                    }
                    
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    if(conPos != null) conPos.close();
                }
            }
        %>
    </select>
</div>

                <div class="form-group">
                    <label>Manifesto</label>
                    <textarea name="cManifesto" class="form-control" rows="3" placeholder="Campaign slogan..."></textarea>
                </div>
                
                <div class="form-group">
                    <label>Photo</label>
                    <input type="file" name="cImage" class="form-control">
                </div>

                <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                    <button type="submit" class="btn-create">Register</button>
                    <button type="button" onclick="closeModal()" class="btn-create" style="background:#dc3545;">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { document.getElementById('addModal').style.display = 'flex'; }
        function closeModal() { document.getElementById('addModal').style.display = 'none'; }
        window.onclick = function(e) { if(e.target == document.getElementById('addModal')) closeModal(); }
    </script>
</body>
</html>