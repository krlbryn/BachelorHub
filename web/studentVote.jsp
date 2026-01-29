<%-- Document : studentVote Created on : 29 Jan 2026 Author : Antigravity --%>

    <%@page import="java.text.SimpleDateFormat" %>
        <%@page import="java.util.List" %>
            <%@page import="com.mvc.bean.ElectionBean" %>
                <%@page import="com.mvc.dao.ElectionDao" %>
                    <%@page contentType="text/html" pageEncoding="UTF-8" %>
                        <% String userSession=(String) session.getAttribute("userSession"); if (userSession==null) {
                            response.sendRedirect("login.jsp"); return; } // Fetch Elections ElectionDao electionDao=new
                            ElectionDao(); // Using getAllElections to ensure data visibility during development.
                            List<ElectionBean> electionList = electionDao.getAllElections();

                            SimpleDateFormat sdf = new SimpleDateFormat("d MMMM yyyy");
                            %>
                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Vote - Student Dashboard</title>

                                <link
                                    href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&family=Roboto:wght@400;500&display=swap"
                                    rel="stylesheet">
                                <link rel="stylesheet"
                                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

                                <link rel="stylesheet" type="text/css"
                                    href="${pageContext.request.contextPath}/css/studentDashboard.css">
                            </head>

                            <body>

                                <!-- SIDEBAR -->
                                <div class="sidebar">
                                    <div class="brand">
                                        <i class="fa-solid fa-check-to-slot"></i>
                                        <span>VOTE</span>
                                    </div>

                                    <ul class="nav-links">
                                        <li>
                                            <a href="studentDashboard.jsp">
                                                <i class="fa-solid fa-border-all"></i>
                                                <span>Dashboard</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="studentVote.jsp" class="active">
                                                <i class="fa-solid fa-box-archive"></i>
                                                <span>Vote</span>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa-solid fa-square-poll-vertical"></i>
                                                <span>Voting Results</span>
                                            </a>
                                        </li>
                                    </ul>

                                    <div class="logout-section">
                                        <ul class="nav-links">
                                            <li>
                                                <a href="studentProfile.jsp">
                                                    <i class="fa-solid fa-user"></i>
                                                    <span>My Profile</span>
                                                </a>
                                            </li>
                                        </ul>
                                        <a href="#" onclick="confirmLogout()" class="logout-link">
                                            <i class="fa-solid fa-right-from-bracket"></i>
                                            <span>Sign Out</span>
                                        </a>
                                        <div
                                            style="margin-top: 20px; padding-left: 15px; color: #666; font-size: 14px; cursor: pointer;">
                                            <span>Help</span>
                                        </div>
                                    </div>
                                </div>

                                <!-- MAIN CONTENT -->
                                <div class="main-content">
                                    <div class="header">
                                        <h1 class="welcome-text">Select Election</h1>
                                        <div class="logo-circle">Logo</div>
                                    </div>

                                    <div class="content-body">
                                        <div class="section-header">
                                            <h2 class="section-title">Available Elections</h2>
                                            <div class="filter-dropdown">
                                                <span>All Elections</span>
                                                <i class="fa-solid fa-chevron-down"></i>
                                            </div>
                                        </div>

                                        <div class="elections-grid">

                                            <% if (electionList !=null && !electionList.isEmpty()) { for (ElectionBean
                                                election : electionList) { String
                                                startDate=(election.getElectionStartDate() !=null) ?
                                                sdf.format(election.getElectionStartDate()) : "TBA" ; String
                                                endDate=(election.getElectionEndDate() !=null) ?
                                                sdf.format(election.getElectionEndDate()) : "TBA" ; %>

                                                <!-- Dynamic Card -->
                                                <div class="election-card">
                                                    <div class="card-image">
                                                        <i class="fa-regular fa-image"></i>
                                                    </div>
                                                    <div class="card-dots">
                                                        <span></span><span></span><span></span>
                                                    </div>
                                                    <p class="image-label">Image/poster</p>

                                                    <h3>
                                                        <%= election.getElectionTitle() %>
                                                    </h3>

                                                    <div class="date-info">
                                                        <i class="fa-regular fa-calendar-days"></i>
                                                        <div class="date-text">
                                                            <span>Start : <%= startDate %></span>
                                                            <span>End : <%= endDate %></span>
                                                        </div>
                                                    </div>

                                                    <button class="btn-vote"
                                                        onclick="window.location.href='voteCandidate.jsp?electionId=<%= election.getElectionId() %>'">View
                                                        Candidates & Vote</button>
                                                </div>

                                                <% } } else { %>
                                                    <div
                                                        style="grid-column: 1/-1; text-align: center; color: #666; padding: 40px;">
                                                        <h3>No active elections found at the moment.</h3>
                                                    </div>
                                                    <% } %>

                                        </div>
                                    </div>
                                </div>

                                <!-- Logout Confirmation Modal -->
                                <div id="logoutModal" class="modal-overlay">
                                    <div class="modal-box">
                                        <h3 class="modal-title">Confirm Logout</h3>
                                        <p class="modal-text">Are you sure you want to sign out?</p>
                                        <div class="modal-buttons">
                                            <a href="login.jsp" class="btn-confirm">Yes, Sign Out</a>
                                            <button onclick="closeModal()" class="btn-cancel">Cancel</button>
                                        </div>
                                    </div>
                                </div>

                                <script>
                                    function confirmLogout() {
                                        document.getElementById('logoutModal').style.display = 'flex';
                                    }
                                    function closeModal() {
                                        document.getElementById('logoutModal').style.display = 'none';
                                    }
                                </script>
                            </body>

                            </html>