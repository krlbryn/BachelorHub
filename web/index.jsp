<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ElectVote | Modern Online Voting</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">
                <i class="fa-solid fa-check-to-slot"></i> ElectVote
            </div>
            <ul class="nav-links">
                <li><a href="index.jsp" class="active">Home</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp">Contact Us</a></li>
                <li><a href="faq.jsp">FAQs</a></li>
            </ul>
            <div class="nav-actions">
                <a href="login.jsp" class="btn-login-outline">Log In</a>
            </div>
        </div>
        
        <div class="header-wave">
            <svg viewBox="0 0 1440 120" preserveAspectRatio="none">
                <path fill="#ffffff" d="M0,32L120,42.7C240,53,480,75,720,74.7C960,75,1200,53,1320,42.7L1440,32L1440,120L1320,120C1200,120,960,120,720,120C480,120,240,120,120,120L0,120Z"></path>
            </svg>
        </div>
    </nav>

    <main class="hero-section">
        <div class="hero-container">
            <div class="hero-content">
                <div class="ivote-label">ElectVote Online Voting System</div>
                <h1 class="hero-title">Your Voice, Your Choice, Your Vote.</h1>
                <p class="hero-subtitle">Experience a secure, transparent, and efficient way to participate in your student council elections.</p>
                <div class="hero-btns">
                    <a href="login.jsp" class="btn-explore">Explore Elections</a>
                </div>
            </div>
            <div class="hero-visual">
                <img src="${pageContext.request.contextPath}/images/voting.jpg" alt="Student Voting Illustration">
            </div>
        </div>
    </main>

    <section class="process-footer">
        <div class="process-container">
            <div class="process-card step-one">
                <div class="step-label">Step 1:</div>
                <h3>LOG IN</h3>
                <p>Access your secure portal using your Student or Admin ID credentials.</p>
                <a href="login.jsp" class="btn-step-action">Go to Login Page</a>
            </div>
            <div class="process-card">
                <div class="step-label">Step 2:</div>
                <h3>VOTE & SUBMIT</h3>
                <p>Select your preferred candidates across different positions and cast your vote safely.</p>
            </div>
            <div class="process-card">
                <div class="step-label">Step 3:</div>
                <h3>VIEW RESULTS</h3>
                <p>Once the poll ends, view the transparent real-time election results immediately.</p>
            </div>
        </div>
    </section>

    <footer class="bottom-bar">
        <p>&copy; 2026 ElectVote Management System. Secured by ElectrVote Technology.</p>
    </footer>

</body>
</html>