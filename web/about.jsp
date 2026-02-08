<%-- 
    Document   : about
    Created on : Feb 7, 2026, 6:41:49 PM
    Author     : Karl
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Us | ElectVote</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo"><i class="fa-solid fa-check-to-slot"></i> ElectVote</div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.jsp" class="active">About</a></li>
                <li><a href="contact.jsp">Contact Us</a></li>
                <li><a href="faq.jsp">FAQs</a></li>
            </ul>
            <div class="nav-actions"><a href="login.jsp" class="btn-login-outline">Log In</a></div>
        </div>
        <div class="header-wave">
            <svg viewBox="0 0 1440 120" preserveAspectRatio="none">
                <path fill="#ffffff" d="M0,32L120,42.7C240,53,480,75,720,74.7C960,75,1200,53,1320,42.7L1440,32L1440,120L1320,120C1200,120,960,120,720,120C480,120,240,120,120,120L0,120Z"></path>
            </svg>
        </div>
    </nav>

    <main class="hero-section">
        <div class="container text-center" style="width:85%; margin: 0 auto;">
            <h1 class="hero-title" style="font-size: 36px;">ABOUT US</h1>
            <p class="hero-subtitle" style="margin: 0 auto 40px;">
                ElectVote is an <strong>Online Voting System</strong> used to gather instant and trustworthy results. 
                We aim to make the voting and elections easy, seamless, and fair.
            </p>

            <h2 style="color: var(--ivote-blue); margin-bottom: 30px;">Management Team</h2>
            <div class="team-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 60px;">
                <div class="team-card ev-card" style="padding: 30px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05);">
                    <img src="images/team1.jpg" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; margin-bottom: 15px;" onerror="this.src='https://ui-avatars.com/api/?name=Roderick+Pastor&background=random';">
                    <h4 style="margin: 10px 0 5px;">Roderick Pastor</h4>
                    <p style="color: var(--ivote-muted); font-size: 14px;">President</p>
                </div>
                </div>

            <div style="text-align: left; background: #f8faff; padding: 40px; border-radius: 20px; border-left: 5px solid var(--ivote-blue);">
                <h3 style="color: var(--ivote-blue);">Our Mission:</h3>
                <p>To provide a secure and convenient way for citizens to cast their ballots in public elections. The system will enable citizens to cast their votes without having to leave their homes.</p>
                <h3 style="color: var(--ivote-blue); margin-top: 30px;">Our Strengths:</h3>
                <ul style="line-height: 1.8; color: #5F6D7E;">
                    <li><strong>Increased Voter Turnout:</strong> Making it easier for voters to cast ballots from any location.</li>
                    <li><strong>Accurate Results:</strong> Results are instantly tallied and can be verified more quickly.</li>
                    <li><strong>Secure:</strong> The system is highly secure and uses encryption measures.</li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>