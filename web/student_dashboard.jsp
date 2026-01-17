<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

    <div class="container">
        <nav class="sidebar">
            <div class="logo-section">
                <img src="voting-icon.png" alt="Logo" class="main-logo">
            </div>
            
            <ul class="nav-links">
                <li class="active"><a href="#"><i class="fas fa-th-large"></i> Dashboard</a></li>
                <li><a href="#"><i class="fas fa-envelope-open-text"></i> Vote</a></li>
                <li><a href="#"><i class="fas fa-bookmark"></i> Voting Results</a></li>
            </ul>

            <ul class="nav-links bottom-links">
                <li><a href="#"><i class="fas fa-user"></i> My Profile</a></li>
                <li><a href="#"><i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
                <li class="help"><a href="#"><i class="fas fa-question-circle"></i> Help</a></li>
            </ul>
        </nav>

        <main class="main-content">
            <header class="header">
                <div>
                    <h1>Student dashboard</h1>
                    <p>Welcome, username!</p>
                </div>
                <div class="profile-circle">Logo</div>
            </header>

            <section class="stats-grid">
                <div class="stat-card">
                    <h3>Active Elections</h3>
                    <div class="stat-number">2</div>
                </div>
                <div class="stat-card">
                    <h3>Ended Elections</h3>
                    <div class="stat-number">1</div>
                </div>
                <div class="stat-card">
                    <h3>Upcoming</h3>
                    <div class="stat-number">1</div>
                </div>
                <div class="stat-card profile-card">
                    <div class="stat-number">Your Profile</div>
                </div>
            </section>

            <div class="election-tables">
                <div class="election-section">
                    <h2 class="section-title">CURRENT & ACTIVE ELECTIONS <span class="star">★</span></h2>
                    
                    <div class="election-item active-blue">
                        <div class="info">
                            <strong>Student Rep Election 2025</strong>
                            <p>Status: <b>Ongoing</b></p>
                            <p>Voting period: 10 Mar - 15 Mar 2025</p>
                        </div>
                        <div class="actions">
                            <button class="btn-vote">Vote now</button>
                            <button class="btn-detail">View Details</button>
                        </div>
                    </div>

                    <div class="election-item active-blue">
                        <div class="info">
                            <strong>ICT Club Election 2025</strong>
                            <p>Status: <b>Ongoing</b></p>
                            <p>Voting period: 20 Mar - 25 Mar 2025</p>
                        </div>
                        <div class="actions">
                            <button class="btn-vote">Vote now</button>
                            <button class="btn-detail">View Details</button>
                        </div>
                    </div>
                </div>

                <div class="election-section">
                    <h2 class="section-title">MY VOTING STATUS <i class="fas fa-user-check"></i></h2>
                    
                    <div class="election-item active-blue">
                        <div class="info">
                            <strong>MPP Election 2025</strong>
                            <p>Status: <b>Ended</b></p>
                            <p>Voting period: 20 Feb - 25 Feb 2025</p>
                        </div>
                        <div class="actions">
                            <button class="btn-voted" disabled>Voted</button>
                            <button class="btn-detail">View Details</button>
                        </div>
                    </div>

                    <div class="election-item active-blue">
                        <div class="info">
                            <strong>Student Rep Election 2025</strong>
                            <p>Status: <b>Upcoming</b></p>
                            <p>Voting period: 10 Mar - 15 Mar 2025</p>
                        </div>
                        <div class="actions">
                            <button class="btn-detail">View Details</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

</body>
</html>