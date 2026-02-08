<%-- 
    Document   : adminEditElection
    Updated on : Feb 08, 2026
    Description: Edit Election Details with iVOTE Theme
--%>

<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String id = request.getParameter("eid"); // Get ID from URL
    
    // Variables to hold current data
    String title="", desc="", start="", end="", status="", positions="", img="";
    List<String> positionList = new ArrayList<>();

    // 1. FETCH EXISTING DATA
    if(id != null) {
        try {
            Connection con = DBConnection.createConnection();
            String sql = "SELECT * FROM election WHERE election_ID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            
            if(rs.next()) {
                title = rs.getString("election_Title");
                desc = rs.getString("election_Description"); // Ensure matches DB column name
                if(desc == null) desc = rs.getString("election_Desc"); // Fallback check

                // Fix Dates for datetime-local input (needs "yyyy-MM-ddTHH:mm")
                // DB usually stores "2026-02-08 14:30:00.0"
                String sDate = rs.getString("election_StartDate"); 
                String eDate = rs.getString("election_EndDate");
                
                if(sDate != null && sDate.length() >= 16) {
                    start = sDate.substring(0, 16).replace(" ", "T");
                }
                if(eDate != null && eDate.length() >= 16) {
                    end = eDate.substring(0, 16).replace(" ", "T");
                }
                
                status = rs.getString("election_Status");
                positions = rs.getString("election_Positions"); 
                img = rs.getString("election_Image");
                
                // Convert CSV positions to List for checking checkboxes
                if(positions != null && !positions.isEmpty()) {
                    String[] posArray = positions.split(",");
                    for(int i=0; i<posArray.length; i++) posArray[i] = posArray[i].trim();
                    positionList = Arrays.asList(posArray);
                }
            }
            con.close();
        } catch(Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Election | ElectVote Admin</title>
    
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

        /* --- HEADER --- */
        .page-header { margin-bottom: 25px; }
        .header-title { font-size: 24px; font-weight: 700; color: var(--ev-primary); margin: 0 0 5px; }
        .header-subtitle { color: var(--ev-muted); font-size: 14px; margin: 0; }

        /* --- EDIT CARD --- */
        .edit-card {
            background: var(--ev-card);
            padding: 35px;
            border-radius: 16px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            max-width: 800px;
            margin: 0 auto;
        }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-size: 13px; font-weight: 600; color: var(--ev-text); }
        
        .form-control { 
            width: 100%; padding: 12px; 
            border: 2px solid #E8EEF3; border-radius: 10px; 
            font-family: 'Poppins', sans-serif; font-size: 14px; color: #1a1a3d;
            box-sizing: border-box; transition: 0.3s;
        }
        .form-control:focus { outline: none; border-color: var(--ev-primary); background: #F9FBFD; }

        .row-split { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        /* Checkbox Group */
        .checkbox-container {
            border: 2px solid #E8EEF3;
            border-radius: 10px;
            padding: 15px;
            background: #FAFBFF;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); /* Responsive grid */
            gap: 10px;
        }
        
        .checkbox-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #1a1a3d; }
        .checkbox-item input { accent-color: var(--ev-primary); width: 16px; height: 16px; cursor: pointer; }

        /* Footer Actions */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #E8EEF3;
        }

        .btn-update {
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white; padding: 12px 30px; border: none; border-radius: 10px;
            font-weight: 600; cursor: pointer; transition: 0.3s;
            box-shadow: 0 4px 15px rgba(30, 86, 160, 0.2);
        }
        .btn-update:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.3); }

        .btn-cancel {
            background: #F4F7FE; color: var(--ev-muted); padding: 12px 25px; 
            border: none; border-radius: 10px; font-weight: 600; 
            text-decoration: none; display: flex; align-items: center; justify-content: center;
            transition: 0.2s;
        }
        .btn-cancel:hover { background: #E8EEF3; color: var(--ev-text); }
        
        .current-img-preview {
            display: flex; align-items: center; gap: 10px; margin-top: 10px;
            padding: 10px; background: #F9FBFD; border-radius: 8px; border: 1px dashed #E8EEF3;
        }
        .preview-thumb { width: 40px; height: 40px; border-radius: 6px; object-fit: cover; }
        .preview-text { font-size: 12px; color: #8A92A6; }
    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Edit Election</h1>
            <p class="header-subtitle">Update details for election ID: <strong>#<%= id %></strong></p>
        </div>

        <div class="edit-card">
            <form action="AdminElectionUpdateServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="eId" value="<%= id %>">
                <input type="hidden" name="oldImage" value="<%= img %>">

                <div class="form-group">
                    <label>Election Title</label>
                    <input type="text" name="eName" class="form-control" value="<%= title %>" required>
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea name="eDesc" class="form-control" rows="3" required><%= desc %></textarea>
                </div>

                <div class="row-split">
                    <div class="form-group">
                        <label>Start Date & Time</label>
                        <input type="datetime-local" name="startDate" class="form-control" value="<%= start %>" required>
                    </div>
                    <div class="form-group">
                        <label>End Date & Time</label>
                        <input type="datetime-local" name="endDate" class="form-control" value="<%= end %>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <select name="eStatus" class="form-control">
                        <option value="Upcoming" <%= "Upcoming".equals(status) ? "selected" : "" %>>Upcoming</option>
                        <option value="Active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
                        <option value="Closed" <%= "Closed".equals(status) ? "selected" : "" %>>Closed</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Positions Included</label>
                    <div class="checkbox-container">
                        <%
                            try {
                                Connection conPos = DBConnection.createConnection();
                                // DISTINCT prevents duplicate positions from appearing
                                String sqlPos = "SELECT DISTINCT position_Name FROM position ORDER BY position_Name"; 
                                Statement stPos = conPos.createStatement();
                                ResultSet rsPos = stPos.executeQuery(sqlPos);

                                while(rsPos.next()) {
                                    String pName = rsPos.getString("position_Name");
                                    // Check if this position matches one in the existing list
                                    String checked = positionList.contains(pName) ? "checked" : "";
                        %>
                                    <div class="checkbox-item">
                                        <input type="checkbox" name="positions" value="<%= pName %>" <%= checked %>> 
                                        <span><%= pName %></span>
                                    </div>
                        <%
                                }
                                conPos.close();
                            } catch (Exception e) { out.print("Error loading positions."); }
                        %>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Update Banner Image (Optional)</label>
                    <input type="file" name="eImage" class="form-control" style="padding: 9px;">
                    
                    <% if(img != null && !img.isEmpty()) { %>
                        <div class="current-img-preview">
                            <img src="images/<%= img %>" class="preview-thumb">
                            <span class="preview-text">Current file: <strong><%= img %></strong> (Leave blank to keep)</span>
                        </div>
                    <% } %>
                </div>

                <div class="form-actions">
                    <a href="adminElection.jsp" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-update">Save Changes</button>
                </div>

            </form>
        </div>
    </main>

</body>
</html>