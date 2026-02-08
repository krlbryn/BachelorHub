<%-- 
    Document   : studentViewWinner
    Updated on : Feb 09, 2026
    Description: Detailed Final Results with Winner Profiles (iVOTE Theme)
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. Session Validation
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Parameter Validation
    String eIdParam = request.getParameter("electionId");
    if (eIdParam == null || eIdParam.isEmpty()) {
        response.sendRedirect("studentResult.jsp");
        return;
    }
    int electionId = Integer.parseInt(eIdParam);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Official Results | ElectVote</title>
        
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">

        <style>
            /* Winners Podium Aesthetics */
            .winner-header-block {
                background: white;
                padding: 35px;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.04);
                border: 1px solid #E8EEF3;
                text-align: center;
                margin-bottom: 40px;
            }

            .back-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                color: #1E56A0;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                margin-bottom: 20px;
                transition: 0.2s;
            }
            .back-btn:hover { transform: translateX(-5px); color: #154585; }

            .winner-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 30px;
                padding-bottom: 50px;
            }

            .winner-card-premium {
                background: #fff;
                border-radius: 16px;
                padding: 40px 30px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.04);
                border: 1px solid #E8EEF3;
                text-align: center;
                position: relative;
                transition: 0.3s ease;
                overflow: hidden;
            }

            .winner-card-premium:hover {
                transform: translateY(-8px);
                box-shadow: 0 12px 30px rgba(30, 86, 160, 0.12);
                border-color: #ffc107;
            }

            /* Golden Crown Indicator */
            .crown-badge {
                position: absolute;
                top: 20px;
                right: 20px;
                font-size: 24px;
                color: #ffc107;
                filter: drop-shadow(0 2px 4px rgba(255, 193, 7, 0.3));
            }

            .winner-pos-tag {
                background: #F4F7FE;
                color: #1E56A0;
                padding: 6px 16px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                display: inline-block;
                margin-bottom: 25px;
                letter-spacing: 0.5px;
            }

            .winner-avatar-frame {
                width: 130px;
                height: 130px;
                border-radius: 12px; /* Standard Rounded Square */
                margin: 0 auto 20px;
                overflow: hidden;
                border: 4px solid #fff;
                box-shadow: 0 8px 20px rgba(0,0,0,0.1);
                background: #F8F9FC;
            }

            .winner-avatar-frame img { width: 100%; height: 100%; object-fit: cover; }
            .winner-avatar-frame i { font-size: 4rem; color: #cbd5e1; margin-top: 25px; }

            .winner-name-text {
                font-family: 'Montserrat', sans-serif;
                font-size: 1.3rem;
                font-weight: 700;
                color: #1a1a3d;
                margin-bottom: 12px;
            }

            .vote-pill {
                background: linear-gradient(135deg, #1E56A0 0%, #4A90E2 100%);
                color: white;
                padding: 10px 25px;
                border-radius: 30px;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                font-weight: 700;
                box-shadow: 0 4px 15px rgba(30, 86, 160, 0.2);
            }
        </style>
    </head>

    <body>
        <jsp:include page="studentNav.jsp" />

        <div class="main-content">
            
            <jsp:include page="studentHeader.jsp" />

            <div class="dashboard-container">
                
                <a href="studentResult.jsp" class="back-btn">
                    <i class="fa-solid fa-chevron-left"></i> Back to Results
                </a>

                <%
                    Connection con = null;
                    PreparedStatement pst = null;
                    ResultSet rs = null;

                    try {
                        con = DBConnection.createConnection();

                        // Fetch Election Title
                        String titleSQL = "SELECT election_Title FROM election WHERE election_ID = ?";
                        pst = con.prepareStatement(titleSQL);
                        pst.setInt(1, electionId);
                        rs = pst.executeQuery();
                        String electionTitle = "Final Results";
                        if (rs.next()) { electionTitle = rs.getString("election_Title"); }
                        rs.close();
                        pst.close();
                %>

                <div class="winner-header-block">
                    <h1 style="font-family: 'Montserrat'; font-weight: 700; color: #1E56A0; margin-bottom: 5px;">
                        <i class="fa-solid fa-trophy" style="color:#ffc107; margin-right: 10px;"></i> Official Proclamation
                    </h1>
                    <p style="color: #8A92A6; font-size: 16px; font-weight: 500;"><%= electionTitle %></p>
                </div>

                <div class="winner-grid">
                    <%
                        // Fetch Winners joined with candidate, student, and position tables
                        String sql = "SELECT er.totalVotes, c.cand_PhotoPath, s.stu_Name, p.position_Name "
                                   + "FROM electionresult er "
                                   + "JOIN candidate c ON er.cand_ID = c.cand_ID "
                                   + "JOIN student s ON c.stud_ID = s.stud_ID "
                                   + "JOIN position p ON er.position_ID = p.position_ID "
                                   + "WHERE er.election_ID = ? "
                                   + "AND er.totalVotes = (SELECT MAX(totalVotes) FROM electionresult WHERE position_ID = er.position_ID AND election_ID = ?) "
                                   + "ORDER BY p.position_ID ASC";

                        pst = con.prepareStatement(sql);
                        pst.setInt(1, electionId);
                        pst.setInt(2, electionId);
                        rs = pst.executeQuery();

                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                            String posName = rs.getString("position_Name");
                            String sName = rs.getString("stu_Name");
                            int votes = rs.getInt("totalVotes");
                            String photo = rs.getString("cand_PhotoPath");
                    %>
                    <div class="winner-card-premium">
                        <div class="crown-badge"><i class="fa-solid fa-crown"></i></div>
                        <div class="winner-pos-tag"><%= posName %></div>

                        <div class="winner-avatar-frame">
                            <% if (photo != null && !photo.trim().isEmpty() && !photo.equals("default_user.png")) { %>
                                <img src="${pageContext.request.contextPath}/images/<%= photo %>" alt="Winner Photo">
                            <% } else { %>
                                <i class="fa-solid fa-user"></i>
                            <% } %>
                        </div>

                        <h3 class="winner-name-text"><%= sName %></h3>
                        
                        <div class="vote-pill">
                            <i class="fa-solid fa-check-to-slot"></i>
                            <span><%= votes %> <small style="font-weight: 400; opacity: 0.8; margin-left: 2px;">Total Votes</small></span>
                        </div>
                    </div>
                    <%
                        }

                        if (!hasResults) {
                    %>
                    <div class="empty-state-text">
                        <i class="fa-solid fa-hourglass-start" style="font-size: 3.5rem; color: #E8EEF3; margin-bottom: 20px; display: block;"></i>
                        <h3 style="color: #1a1a3d; margin-bottom: 10px;">Results Pending</h3>
                        <p>The official results for this election are still being verified by the administration.</p>
                    </div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            try { if(rs!=null) rs.close(); } catch(Exception e){}
                            try { if(pst!=null) pst.close(); } catch(Exception e){}
                            try { if(con!=null) con.close(); } catch(Exception e){}
                        }
                    %>
                </div>
            </div>
        </div>
    </body>
</html>