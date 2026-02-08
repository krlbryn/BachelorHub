<%-- 
    Document   : about
    Updated on : Feb 08, 2026
    Description: About Us Page with Management Team
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
    
    <style>
        :root {
            --ivote-blue: #1E56A0;
            --ivote-light: #F4F7FE;
            --ivote-text: #1a1a3d;
        }
        
        .team-card {
            background: white;
            padding: 30px 20px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            text-align: center;
            border: 1px solid #eee;
            transition: transform 0.3s ease;
        }
        .team-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(30, 86, 160, 0.15);
            border-color: #dbeafe;
        }
        
        .member-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 4px solid var(--ivote-light);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .member-name {
            font-size: 16px;
            font-weight: 700;
            color: var(--ivote-blue);
            margin: 0 0 5px;
            text-transform: uppercase;
        }
        
        .member-role {
            font-size: 13px;
            color: #8A92A6;
            font-weight: 500;
        }
    </style>
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
        <div class="container text-center" style="width:85%; margin: 0 auto; max-width: 1200px;">
            <h1 class="hero-title" style="font-size: 42px; color: #1E56A0; margin-bottom: 10px;">About Us</h1>
            <p class="hero-subtitle" style="margin: 0 auto 60px; max-width: 700px; color: #5F6D7E; line-height: 1.6;">
                ElectVote is an <strong>Online Voting System</strong> used to gather instant and trustworthy results. 
                We aim to make elections easy, seamless, and fair for everyone.
            </p>

            <h2 style="color: #1a1a3d; margin-bottom: 40px; position: relative; display: inline-block;">
                Meet Our Team
                <div style="width: 50px; height: 3px; background: #1E56A0; margin: 10px auto 0;"></div>
            </h2>
            
        <div class="team-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 30px; margin-bottom: 80px;">
    
    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/nadzim.jpeg" class="member-img" alt="Abang Muhammad Nadzim">
        <h4 class="member-name">Abang Muhammad Nadzim</h4>
        <p class="member-role">Team Lead</p>
    </div>

    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/allen.jpeg" class="member-img" alt="Allen Daryl Anak Stephen">
        <h4 class="member-name">Allen Daryl Anak Stephen</h4>
        <p class="member-role">Developer</p>
    </div>

    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/najib.jpeg" class="member-img" alt="Awang Najib Farhan">
        <h4 class="member-name">Awang Najib Farhan</h4>
        <p class="member-role">System Administrator</p>
    </div>

    <div class="team-card">
        <img src="${pageContext.request.contextPath}/images/karl.jpeg" class="member-img" alt="Karl Bryan Anak Sabang">
        <h4 class="member-name">Karl Bryan Anak Sabang</h4>
        <p class="member-role">UI/UX Designer</p>
    </div>

</div>

            <div style="text-align: left; background: #F8FAFF; padding: 50px; border-radius: 20px; border: 1px solid #E8EEF3; position: relative; overflow: hidden;">
                <div style="position: absolute; top: 0; left: 0; width: 5px; height: 100%; background: #1E56A0;"></div>
                
                <h3 style="color: #1E56A0; margin-bottom: 15px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-bullseye"></i> Our Mission
                </h3>
                <p style="color: #5F6D7E; margin-bottom: 40px; line-height: 1.8;">
                    To provide a secure and convenient way for citizens to cast their ballots in public elections. 
                    The system will enable citizens to cast their votes without having to leave their homes, ensuring safety and accessibility for all.
                </p>
                
                <h3 style="color: #1E56A0; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-layer-group"></i> Our Strengths
                </h3>
                <ul style="line-height: 2; color: #5F6D7E; list-style: none; padding: 0;">
                    <li style="margin-bottom: 10px;"><i class="fa-solid fa-check" style="color: #00c853; margin-right: 10px;"></i> <strong>Increased Voter Turnout:</strong> Making it easier for voters to cast ballots from any location.</li>
                    <li style="margin-bottom: 10px;"><i class="fa-solid fa-check" style="color: #00c853; margin-right: 10px;"></i> <strong>Accurate Results:</strong> Results are instantly tallied and can be verified more quickly.</li>
                    <li><i class="fa-solid fa-check" style="color: #00c853; margin-right: 10px;"></i> <strong>Secure:</strong> The system is highly secure and uses advanced encryption measures.</li>
                </ul>
            </div>
        </div>
    </main>
</body>
</html>