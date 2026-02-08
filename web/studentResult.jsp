<%-- 
    Document   : studentResult.jsp
    Updated on : Feb 09, 2026
    Description: Lists all elections with status-based result tracking (iVOTE Theme)
--%>
<%@page import="java.sql.*, java.text.SimpleDateFormat"%>
<%@page import="com.mvc.util.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("d MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Election Results | ElectVote</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentNav.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentHeader.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">

    <style>
        /* Specific Result Page Styling matched to Admin Fidelity */
        .results-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            padding-bottom: 50px;
        }

        .result-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid #E8EEF3;
            display: flex;
            flex-direction: column;
            position: relative;
            transition: 0.3s ease;
        }

        .result-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(30, 86, 160, 0.12);
        }

        .status-tag {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }

        .tag-active { background: #e8fcf0; color: #00c853; }
        .tag-ended { background: #f4f7fe; color: #8A92A6; }
        .tag-upcoming { background: #fff9e6; color: #ffc107; }

        .res-icon-box {
            width: 55px;
            height: 55px;
            background: #F4F7FE;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1E56A0;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .res-title {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.15rem;
            color: #1a1a3d;
            font-weight: 700;
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .res-meta {
            font-size: 13px;
            color: #8A92A6;
            margin-bottom: 25px;
        }

        /* Result Action Button */
        .btn-view-results {
            background: linear-gradient(135deg, #1E56A0 0%, #4A90E2 100%);
            color: white;
            text-decoration: none;
            padding: 12px;
            border-radius: 10px;
            text-align: center;
            font-weight: 700;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: 0.3s;
        }

        .btn-view-results:hover {
            box-shadow: 0 6px 15px rgba(30, 86, 160, 0.3);
            filter: brightness(1.1);
        }

        .btn-waiting {
            background: #F4F7FE;
            color: #8A92A6;
            padding: 12px;
            border-radius: 10px;
            text-align: center;
            font-weight: 600;
            font-size: 13px;
            pointer-events: none;
        }
    </style>
</head>

<body>
    <jsp:include page="studentNav.jsp" />

    <div class="main-content">
        <jsp:include page="studentHeader.jsp" />

        <div class="dashboard-container">
            <div class="page-header">
                <h1 class="page-title">Voting Results</h1>
                <p class="page-subtitle">Monitor election statuses and view official winners once polls close.</p>
            </div>

            <div class="results-grid">
            <%
                Connection con = null;
                Statement st = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.createConnection();
                    st = con.createStatement();
                    
                    // FETCH ALL ELECTIONS ordered by status
                    String sql = "SELECT * FROM election ORDER BY election_Status = 'Ended' DESC, election_ID DESC";
                    rs = st.executeQuery(sql);

                    boolean hasData = false;
                    while (rs.next()) {
                        hasData = true;
                        int eID = rs.getInt("election_ID");
                        String title = rs.getString("election_Title");
                        String status = rs.getString("election_Status"); 
                        Timestamp endObj = rs.getTimestamp("election_EndDate");
                        String endDate = (endObj != null) ? sdf.format(endObj) : "TBA";
                        
                        // Logic for Button and Tags
                        boolean isEnded = "Ended".equalsIgnoreCase(status) || "Closed".equalsIgnoreCase(status);
                        boolean isActive = "Active".equalsIgnoreCase(status) || "Ongoing".equalsIgnoreCase(status);
                        
                        String tagClass = isEnded ? "tag-ended" : (isActive ? "tag-active" : "tag-upcoming");
            %>
                    <div class="result-card">
                        <div class="status-tag <%= tagClass %>"><%= status %></div>
                        
                        <div class="res-icon-box">
                            <i class="fa-solid <%= isEnded ? "fa-trophy" : "fa-square-poll-vertical" %>"></i>
                        </div>
                        
                        <h3 class="res-title"><%= title %></h3>
                        <div class="res-meta">
                            <i class="fa-regular fa-calendar-xmark" style="margin-right: 5px;"></i> 
                            Ended: <strong><%= endDate %></strong>
                        </div>
                        
                        <% if (isEnded) { %>
                            <a href="studentViewWinner.jsp?electionId=<%= eID %>" class="btn-view-results">
                                View Official Winner <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        <% } else { %>
                            <div class="btn-waiting">
                                <i class="fa-solid fa-lock" style="margin-right: 8px;"></i> 
                                Results Locked
                            </div>
                        <% } %>
                    </div>
            <%
                    }
                    if (!hasData) {
            %>
                    <div class="empty-state-text">
                        <i class="fa-solid fa-folder-open" style="font-size: 3rem; color: #E8EEF3; margin-bottom: 15px; display: block;"></i>
                        No elections found in the record.
                    </div>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if(rs!=null) rs.close(); } catch(Exception e){}
                    try { if(st!=null) st.close(); } catch(Exception e){}
                    try { if(con!=null) con.close(); } catch(Exception e){}
                }
            %>
            </div>
        </div>
    </div>
</body>
</html>