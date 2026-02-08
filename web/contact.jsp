<%-- 
    Document   : contact
    Updated on : Feb 08, 2026
    Description: Contact Us Page with Success Message Logic
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us | ElectVote</title>
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
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp" class="active">Contact Us</a></li>
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
        <div class="container" style="width:85%; margin: 0 auto; display: grid; grid-template-columns: 1fr 1fr; gap: 50px; align-items: start;">
            
            <div>
                <h1 class="hero-title">Get in Touch</h1>
                <p class="hero-subtitle">Have questions? Our support team is here to help you navigate your voting experience.</p>
                
                <div style="margin-top: 40px;">
                    <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
                        <i class="fa-solid fa-location-dot" style="color: #1E56A0; font-size: 20px;"></i>
                        <span>Address: Kuching City, Sarawak</span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 15px; margin-bottom: 20px;">
                        <i class="fa-solid fa-envelope" style="color: #1E56A0; font-size: 20px;"></i>
                        <span>Email: electvote@gmail.com</span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 15px;">
                        <i class="fa-solid fa-phone" style="color: #1E56A0; font-size: 20px;"></i>
                        <span>Phone No.: +60 123-456-789</span>
                    </div>
                </div>
            </div>
            
            <div class="ev-card" style="padding: 40px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.05); background: white;">
                <h3 style="margin-bottom: 25px;">Send a Message</h3>
                
                <form id="contactForm" onsubmit="return handleMessage(event)">
                    
                    <input type="text" id="msgName" placeholder="Full Name" required 
                           style="width:100%; padding: 12px; margin-bottom: 15px; border-radius: 8px; border: 1px solid #E8EEF3; box-sizing: border-box;">
                    
                    <input type="email" id="msgEmail" placeholder="Email Address" required 
                           style="width:100%; padding: 12px; margin-bottom: 15px; border-radius: 8px; border: 1px solid #E8EEF3; box-sizing: border-box;">
                    
                    <textarea id="msgText" placeholder="How can we help?" rows="5" required 
                              style="width:100%; padding: 12px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #E8EEF3; box-sizing: border-box;"></textarea>
                    
                    <button type="submit" class="btn-explore" style="width:100%; border:none; cursor:pointer; background: #1E56A0; color: white; padding: 12px; border-radius: 8px;">Submit Request</button>
                </form>
            </div>

        </div>
    </main>

    <script>
        function handleMessage(event) {
            event.preventDefault(); // Prevents page reload
            
            // Simulating a successful submission
            alert("Thank you! Your message has been sent to our support team.");
            
            // Clear the form inputs
            document.getElementById("contactForm").reset();
        }
    </script>
</body>
</html>