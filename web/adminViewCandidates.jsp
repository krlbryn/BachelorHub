<%-- 
    Document   : adminViewCandidates
    Created on : Jan 30, 2026, 12:00:08 AM
    Author     : Karl
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // 1. Get the current Election ID (if any)
    String eid = request.getParameter("eid");
    String msg = request.getParameter("msg");
    String currentElectionName = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Candidates</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminHeader.css">
    
    <style>
        /* Header Layout */
        .header-nav { display: flex; align-items: center; justify-content: space-between; margin-bottom: 25px; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        
        /* The Dropdown Styling */
        .election-select { padding: 10px; font-size: 1rem; border: 2px solid #007bff; border-radius: 5px; color: #333; outline: none; cursor: pointer; min-width: 250px; }
        .election-select:hover { background-color: #f0f7ff; }

        .back-btn { background: #6c757d; color: white; padding: 10px 15px; border-radius: 5px; text-decoration: none; font-weight: bold; font-size: 0.9rem; }
        
        /* Candidate Table */
        .candidate-img { width: 50px; height: 50px; object-fit: cover; border-radius: 50%; border: 2px solid #ddd; }
        .election-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.05); table-layout: fixed; }
        .election-table th, .election-table td { padding: 15px; text-align: left; border-bottom: 1px solid #dee2e6; word-wrap: break-word; }
        .election-table th { background-color: #f8f9fa; color: #495057; }
        
        /* Empty State (No Election Selected) */
        .empty-state { text-align: center; padding: 50px; color: #666; background: white; border-radius: 8px; margin-top: 20px; }
        .empty-state i { font-size: 3rem; color: #ccc; margin-bottom: 15px; }
        
        /* Buttons */
        .btn-create { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 1rem; }
        .btn-delete { color: #dc3545; background: none; border: none; cursor: pointer; font-size: 1.1rem; }
        
        /* Modal */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; padding: 30px; border-radius: 8px; width: 500px; font-family: 'serif'; animation: slideDown 0.3s ease-out; }
        @keyframes slideDown { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .form-group { margin-bottom: 15px; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
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
    <div class="action-bar" style="margin-top: 25px; margin-bottom: 20px;">
        
        <div style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; justify-content: space-between; align-items: center;">
            
            <div style="flex-grow: 1; margin-right: 20px;">
                <label style="display:block; font-weight:bold; color:#555; margin-bottom:5px;">Select Election to Manage:</label>
                <select class="election-select" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px;" onchange="window.location.href='adminViewCandidates.jsp?eid='+this.value">
                    <option value="" disabled <%= (eid == null) ? "selected" : "" %>>-- Choose Election --</option>
                    <%
                        try {
                            Connection conH = DBConnection.createConnection();
                            String sqlH = "SELECT election_ID, election_Title FROM election ORDER BY election_ID DESC";
                            Statement stH = conH.createStatement();
                            ResultSet rsH = stH.executeQuery(sqlH);
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


    <% if(eid != null && !eid.isEmpty()) { %>
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
                        String sql = "SELECT c.cand_ID, c.cand_ManifestoDesc, c.cand_PhotoPath, s.stu_Name, s.stud_ID, p.election_Positions FROM candidate c JOIN student s ON c.stud_ID = s.stud_ID JOIN position p ON c.position_ID = p.position_ID WHERE p.election_ID = ? ORDER BY p.election_Positions";
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
                    <td><strong><%= rs.getString("stu_Name") %></strong><br><span style="color:#666; font-size:0.85rem;"><%= rs.getString("stud_ID") %></span></td>
                    <td><span class="status active" style="background:#e2e6ea; color:#333;"><%= rs.getString("election_Positions") %></span></td>
                    <td><em style="color:#555;"><%= rs.getString("cand_ManifestoDesc") %></em></td>
                    <td><a href="#" class="btn-delete" style="color:#dc3545;"><i class="fa-solid fa-trash"></i></a></td>
                </tr>
                <%
                        }
                        if(!hasData) { out.print("<tr><td colspan='5' style='text-align:center; padding:40px; color:#999;'>No candidates yet.</td></tr>"); }
                        con.close();
                    } catch (Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
    <% } %>

</main>

   <div id="addModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
        <div class="modal-content" style="background: white; padding: 30px; border-radius: 8px; width: 500px; font-family: 'serif'; animation: slideDown 0.3s ease-out;">
            <h2 style="text-align:center; margin-bottom:20px;">Register Candidate</h2>
            
            <form action="AdminCandidateAddServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="eid" value="<%= eid %>">
                
                <div class="form-group" style="margin-bottom:15px;">
                    <label style="display:block; font-weight:bold; margin-bottom:5px;">Student ID (Matric No)</label>
                    <input type="text" name="studID" class="form-control" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px;" placeholder="Ex: 2022667112" required>
                    <small style="color:#666;">Must match an existing Student ID</small>
                </div>

                <div class="form-group" style="margin-bottom:15px;">
                    <label style="display:block; font-weight:bold; margin-bottom:5px;">Position</label>
                    <select name="posId" class="form-control" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px;" required>
                        <%
                            // Fetch positions specific to this election
                            if(eid != null) {
                                try {
                                    Connection conPos = DBConnection.createConnection();
                                    String sqlPos = "SELECT * FROM position WHERE election_ID = ?";
                                    PreparedStatement psPos = conPos.prepareStatement(sqlPos);
                                    psPos.setString(1, eid);
                                    ResultSet rsPos = psPos.executeQuery();
                                    while(rsPos.next()) {
                        %>
                                <option value="<%= rsPos.getString("position_ID") %>">
                                    <%= rsPos.getString("election_Positions") %>
                                </option>
                        <%
                                    }
                                    conPos.close();
                                } catch(Exception e) {}
                            }
                        %>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom:15px;">
                    <label style="display:block; font-weight:bold; margin-bottom:5px;">Manifesto</label>
                    <textarea name="cManifesto" class="form-control" rows="3" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px;" placeholder="Campaign slogan..."></textarea>
                </div>
                
                <div class="form-group" style="margin-bottom:15px;">
                    <label style="display:block; font-weight:bold; margin-bottom:5px;">Candidate Photo</label>
                    <input type="file" name="cImage" class="form-control" style="width:100%; border:1px solid #ccc; padding:5px;">
                </div>

                <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:20px;">
                    <button type="submit" class="btn-create" style="background:#28a745; color:white; border:none; padding:10px 20px; border-radius:5px; cursor:pointer;">Register</button>
                    <button type="button" onclick="closeModal()" style="background:#dc3545; color:white; border:none; padding:10px 20px; border-radius:5px; cursor:pointer;">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() { 
            // This finds the div with id="addModal" and shows it
            document.getElementById('addModal').style.display = 'flex'; 
        }
        
        function closeModal() { 
            document.getElementById('addModal').style.display = 'none'; 
        }
        
        // Close if user clicks the dark background outside the box
        window.onclick = function(e) { 
            if(e.target == document.getElementById('addModal')) {
                closeModal(); 
            }
        }
    </script>
</body>
</html>