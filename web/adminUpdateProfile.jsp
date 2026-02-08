<%-- 
    Document   : adminUpdateProfile
    Updated on : Feb 08, 2026
    Description: Update Profile Form with iVOTE Theme
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Security Check
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Default empty variables
    String name = "";
    String email = "";
    String phone = "";
    String address = "";
    String id = "";
    String image = "default.png";

    try {
        Connection con = DBConnection.createConnection();
        String sql = "SELECT * FROM admin WHERE admin_username = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, userSession);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            id = rs.getString("admin_ID");
            name = rs.getString("admin_Name");
            email = rs.getString("admin_Email");
            phone = rs.getString("admin_Phone");
            address = rs.getString("admin_Address");
            if (rs.getString("admin_Image") != null) {
                image = rs.getString("admin_Image");
            }
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Profile | ElectVote Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/adminDashboard.css">
    
    <style>
        /* --- THEME VARIABLES --- */
        :root {
            --ev-primary: #1E56A0;
            --ev-secondary: #4A90E2;
            --ev-bg: #F4F7FE;
            --ev-card: #FFFFFF;
            --ev-text: #1a1a3d;
            --ev-muted: #8A92A6;
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
            border-radius: 16px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.03);
            border: 1px solid #E8EEF3;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px;
        }

        /* Avatar Preview Section */
        .avatar-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 30px;
            border-bottom: 1px solid #F4F7FE;
        }

        .current-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #E8EEF3;
            margin-bottom: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .file-upload-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }

        .btn-upload {
            background: #F4F7FE;
            color: var(--ev-primary);
            border: 1px solid #E8EEF3;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }
        .btn-upload:hover { background: #E8EEF3; }

        /* Hide the ugly default file input */
        input[type="file"] {
            font-size: 13px;
            margin-top: 5px;
        }

        /* --- FORM GRID --- */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
        }

        .form-group { margin-bottom: 20px; }
        
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--ev-muted);
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #E8EEF3;
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: var(--ev-text);
            box-sizing: border-box;
            transition: 0.3s;
        }
        .form-control:focus {
            outline: none;
            border-color: var(--ev-primary);
            background: #F9FBFD;
        }

        /* Full width for address */
        .full-width { grid-column: span 2; }

        /* --- BUTTONS --- */
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #F4F7FE;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s;
            border: none;
        }

        .btn-save {
            background: linear-gradient(135deg, var(--ev-primary), var(--ev-secondary));
            color: white;
            box-shadow: 0 4px 15px rgba(30, 86, 160, 0.2);
        }
        .btn-save:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30, 86, 160, 0.3); }

        .btn-cancel {
            background: #F4F7FE;
            color: var(--ev-muted);
        }
        .btn-cancel:hover { background: #E8EEF3; color: var(--ev-text); }

    </style>
</head>
<body>

    <jsp:include page="adminNav.jsp" />

    <main class="main-content">
        
        <jsp:include page="adminHeader.jsp" />

        <div class="page-header">
            <h1 class="header-title">Update Profile</h1>
            <p class="header-subtitle">Edit your personal details and public profile.</p>
        </div>

        <div class="edit-card">
            <form action="AdminUpdateServlet" method="post" enctype="multipart/form-data">
                <input type="hidden" name="admin_id" value="<%= id %>">
                <input type="hidden" name="oldImage" value="<%= image %>">

                <div class="avatar-section">
                    <img src="${pageContext.request.contextPath}/images/<%= image %>" class="current-avatar" alt="Current Profile">
                    <div style="text-align: center;">
                        <label class="form-label">Change Profile Photo</label>
                        <input type="file" name="imageFile" accept="image/*">
                        <div style="font-size: 12px; color: #aaa; margin-top: 5px;">Supported formats: JPG, PNG</div>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label class="form-label">Full Name</label>
                        <input type="text" name="name" class="form-control" value="<%= name %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" value="<%= email %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="<%= phone %>">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Admin ID (Read Only)</label>
                        <input type="text" class="form-control" value="<%= id %>" disabled style="background: #F4F7FE; color: #8A92A6;">
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">Address</label>
                        <textarea name="address" class="form-control" rows="3"><%= address %></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="adminProfile.jsp" class="btn btn-cancel">Cancel</a>
                    <button type="submit" class="btn btn-save">Save Changes</button>
                </div>

            </form>
        </div>

    </main>

</body>
</html>