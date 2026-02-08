<%-- 
    Document   : studentViewWinner
    Created on : 1 Feb 2026, 1:08:14 am
    Author     : ParaNon
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
        <title>Election Winners - Final Results</title>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentDashboard.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/studentResult.css">
    </head>

    <body>
        <jsp:include page="studentNav.jsp" />

        <div class="main-content">

            <div style="margin-bottom: 25px;">
                <a href="studentResult.jsp" style="text-decoration: none; color: #0d6efd; font-weight: 600; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-arrow-left"></i> Back to Result List
                </a>
            </div>

            <div class="result-container">
                <%
                    Connection con = null;
                    PreparedStatement pst = null;
                    ResultSet rs = null;

                    try {
                        con = DBConnection.createConnection();

                        // 1. Fetch Election Title from the election table
                        String titleSQL = "SELECT election_Title FROM election WHERE election_ID = ?";
                        pst = con.prepareStatement(titleSQL);
                        pst.setInt(1, electionId);
                        rs = pst.executeQuery();
                        String electionTitle = "Election Results";
                        if (rs.next()) {
                            electionTitle = rs.getString("election_Title");
                        }
                        rs.close();
                        pst.close();
                %>

                <div class="winner-header-block" style="text-align: center; margin-bottom: 40px; padding: 20px; background: #fff; border-radius: 15px; box-shadow: 0 4px 10px rgba(0,0,0,0.05);">
                    <h1 style="margin:0; color:#1a1a1a; font-family: 'Montserrat';"><i class="fa-solid fa-trophy" style="color:#ffc107;"></i> Official Results</h1>
                    <h2 style="margin: 10px 0 0 0; color:#6c757d; font-size: 1.3rem; font-weight: 500;"><%= electionTitle%></h2>
                </div>

                <div class="winner-grid">
                    <%
                        /* 2. Fetch Winners from electionresult table
                               Joining with candidate and student tables to get display details */
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
                    <div class="winner-card-large">
                        <div class="winner-position-badge"><%= posName%></div>
                        <div class="crown-icon"><i class="fa-solid fa-crown" style="color: #ffc107;"></i></div>

                        <div class="winner-img-container" style="width: 150px; height: 150px; margin: 0 auto 20px; border-radius: 50%; overflow: hidden; border: 5px solid #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                            <%-- Persistent Path Logic --%>
                            <% if (photo != null && !photo.trim().isEmpty() && !photo.equals("default_user.png")) {%>
                            <img src="${pageContext.request.contextPath}/images/<%= photo%>" 
                                 class="winner-img" 
                                 alt="Winner" 
                                 style="width: 100%; height: 100%; object-fit: cover;">
                            <% } else { %>
                            <div style="width: 100%; height: 100%; background: #f0f2f5; display: flex; align-items: center; justify-content: center;">
                                <i class="fa-solid fa-user" style="font-size: 5rem; color: #adb5bd;"></i>
                            </div>
                            <% }%>
                        </div>

                        <h3 class="winner-name" style="font-family: 'Montserrat'; font-size: 1.4rem; color: #333; margin-bottom: 10px;"><%= sName%></h3>
                        <div class="winner-votes" style="background: #e3f2fd; padding: 8px 20px; border-radius: 20px; display: inline-block; color: #0d47a1; font-weight: 700;">
                            <span style="font-size: 1.2rem;"><%= votes%></span> Total Votes
                        </div>
                    </div>
                    <%
                        }

                        if (!hasResults) {
                    %>
                    <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                        <i class="fa-solid fa-hourglass-half" style="font-size: 4rem; color: #ccc; margin-bottom: 15px;"></i>
                        <h3 style="color: #888;">Results for this election have not been finalized yet.</h3>
                    </div>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<p style='color:red;'>Error loading results: " + e.getMessage() + "</p>");
                        } finally {
                            try {
                                if (rs != null) {
                                    rs.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (pst != null) {
                                    pst.close();
                                }
                            } catch (Exception e) {
                            }
                            try {
                                if (con != null) {
                                    con.close();
                                }
                            } catch (Exception e) {
                            }
                        }
                    %>
                </div>
            </div>
        </div>
    </body>
</html>