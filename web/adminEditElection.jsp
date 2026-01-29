<%-- 
    Document   : adminEditElection
    Created on : Jan 29, 2026, 11:28:17?PM
    Author     : Karl
--%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String id = request.getParameter("eid"); // Get ID from the URL link
    
    // Variables to hold the current data
    String title="", desc="", start="", end="", status="", positions="", img="";
    List<String> positionList = new ArrayList<>();

    // 1. FETCH EXISTING DATA FROM DB
    if(id != null) {
        try {
            Connection con = DBConnection.createConnection();
            String sql = "SELECT * FROM election WHERE election_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                title = rs.getString("election_Title");
                desc = rs.getString("election_Desc");
                
                // Fix Dates: Database has "2026-02-01 00:00:00", HTML needs "2026-02-01"
                String sDate = rs.getString("election_StartDate"); 
                String eDate = rs.getString("election_EndDate");
                if(sDate != null && sDate.length() >= 10) start = sDate.substring(0, 10);
                if(eDate != null && eDate.length() >= 10) end = eDate.substring(0, 10);
                
                status = rs.getString("election_Status");
                positions = rs.getString("election_Positions"); // e.g., "President,Treasurer"
                img = rs.getString("election_Image");
                
                // Convert string "President,VP" into a List for easy checking
                if(positions != null && !positions.isEmpty()) {
                    positionList = Arrays.asList(positions.split(","));
                }
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Election</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* Reuse styles for consistency */
        body { background-color: #f4f7f6; }
        .edit-container { max-width: 800px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .edit-header { text-align: center; margin-bottom: 30px; border-bottom: 1px solid #eee; padding-bottom: 15px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; }
        
        .row-split { display: flex; gap: 20px; }
        .col-half { flex: 1; }
        
        .checkbox-group { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 10px; background: #f9f9f9; padding: 15px; border-radius: 5px; border: 1px solid #eee; }
        
        .btn-update { background-color: #ffc107; color: black; padding: 12px 30px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; }
        .btn-update:hover { background-color: #e0a800; }
        .btn-cancel { background-color: #6c757d; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        <div class="edit-container">
            <div class="edit-header">
                <h2>Edit Election Details</h2>
                <p>Update ID: #<%= id %></p>
            </div>
            
            <form action="AdminElectionUpdateServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="eId" value="<%= id %>">
                <input type="hidden" name="oldImage" value="<%= img %>">

                <div class="form-group">
                    <label>Election Name</label>
                    <input type="text" name="eName" class="form-control" value="<%= title %>" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="eDesc" class="form-control" rows="2" required><%= desc %></textarea>
                </div>

                <div class="row-split">
                    <div class="col-half form-group">
                        <label>Start Date</label>
                        <input type="date" name="startDate" class="form-control" value="<%= start %>" required>
                    </div>
                    <div class="col-half form-group">
                        <label>End Date</label>
                        <input type="date" name="endDate" class="form-control" value="<%= end %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <select name="eStatus" class="form-control">
                        <option value="Upcoming" <%= status.equals("Upcoming") ? "selected" : "" %>>Upcoming</option>
                        <option value="Active" <%= status.equals("Active") ? "selected" : "" %>>Active</option>
                        <option value="Closed" <%= status.equals("Closed") ? "selected" : "" %>>Closed</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Positions Included:</label>
                    <div class="checkbox-group">
                        <%
                            // Fetch all possible positions to display
                            try {
                                Connection conPos = DBConnection.createConnection();
                                String sqlPos = "SELECT * FROM position"; 
                                Statement stPos = conPos.createStatement();
                                ResultSet rsPos = stPos.executeQuery(sqlPos);

                                while(rsPos.next()) {
                                    String pName = rsPos.getString("position_Name");
                                    // Check if this position was previously saved
                                    String checked = positionList.contains(pName) ? "checked" : "";
                        %>
                                    <div>
                                        <input type="checkbox" name="positions" value="<%= pName %>" <%= checked %>> 
                                        <%= pName %>
                                    </div>
                        <%
                                }
                                conPos.close();
                            } catch (Exception e) {}
                        %>
                    </div>
                </div>
                
                <div class="row-split">
                    <div class="col-half form-group">
                        <label>Update Image (Optional)</label>
                        <input type="file" name="eImage" class="form-control">
                        <small>Current file: <%= img %></small>
                    </div>
                    <div class="col-half" style="display:flex; justify-content:flex-end; align-items:flex-end; gap:10px;">
                        <a href="adminElection.jsp" class="btn-cancel">Cancel</a>
                        <button type="submit" class="btn-update">Update Election</button>
                    </div>
                </div>

            </form>
        </div>
    </main>
</body>
</html>
