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

    <div class="sidebar">
        <div class="logo-area">
            <i class="fas fa-vote-yea"></i> Logo
        </div>
        
        <nav class="nav-group">
            <a href="#" class="nav-item active"><i class="fas fa-th-large"></i> Dashboard</a>
            <a href="#" class="nav-item"><i class="fas fa-envelope-open-text"></i> Vote</a>
            <a href="#" class="nav-item"><i class="fas fa-poll"></i> Voting Results</a>
        </nav>

        <div class="spacer"></div>

        <nav class="nav-group">
            <a href="#" class="nav-item"><i class="fas fa-user-circle"></i> My Profile</a>
            <a href="#" class="nav-item"><i class="fas fa-sign-out-alt"></i> Sign Out</a>
            <a href="#" class="nav-item"><i class="fas fa-question-circle"></i> Help</a>
        </nav>
    </div>

    <main class="main-content">
        <header class="header">
            <div>
                <h1 class="page-title">Student dashboard</h1>
                <p>Welcome, username!</p>
            </div>
            <div class="profile-wrapper" style="width: 60px; height: 60px; font-size: 20px;">
                <i class="fas fa-user"></i>
            </div>
        </header>

        <div class="election-grid" style="margin-bottom: 40px;">
            <div class="card" style="background: #8eb9f5; color: white;">
                <h3>Active Elections</h3>
                <div style="font-size: 40px; font-weight: bold;">2</div>
            </div>
            <div class="card" style="background: #8eb9f5; color: white;">
                <h3>Ended Elections</h3>
                <div style="font-size: 40px; font-weight: bold;">1</div>
            </div>
            <div class="card" style="background: #8eb9f5; color: white;">
                <h3>Upcoming</h3>
                <div style="font-size: 40px; font-weight: bold;">1</div>
            </div>
        </div>

        <div class="election-grid">
            <div class="election-column">
                <h3 style="margin-bottom: 15px; font-size: 14px; color: #666;">CURRENT & ACTIVE ELECTIONS ★</h3>
                
                <div class="card" style="text-align: left; margin-bottom: 20px; background: #2b65ec; color: white;">
                    <strong>Student Rep Election 2025</strong>
                    <p style="font-size: 13px; margin: 5px 0;">Status: <b>Ongoing</b></p>
                    <p style="font-size: 13px; opacity: 0.8;">10 Mar - 15 Mar 2025</p>
                    <div style="margin-top: 15px; display: flex; gap: 10px;">
                        <button class="btn-vote" style="background: white; color: #2b65ec; padding: 5px 15px;">Vote now</button>
                        <button class="btn-vote" style="background: rgba(255,255,255,0.2); border: 1px solid white;">Details</button>
                    </div>
                </div>
            </div>

            <div class="election-column">
                <h3 style="margin-bottom: 15px; font-size: 14px; color: #666;">MY VOTING STATUS <i class="fas fa-check-circle"></i></h3>
                
                <div class="card" style="text-align: left; background: #2b65ec; color: white;">
                    <strong>MPP Election 2025</strong>
                    <p style="font-size: 13px; margin: 5px 0;">Status: <b>Ended</b></p>
                    <p style="font-size: 13px; opacity: 0.8;">20 Feb - 25 Feb 2025</p>
                    <button class="btn-vote" disabled style="background: #ccc; cursor: not-allowed;">Voted</button>
                </div>
            </div>
        </div>
    </main>

</body>
</html>