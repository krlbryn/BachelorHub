<%-- 
    Document   : faq
    Updated on : Feb 09, 2026
    Description: FAQ Page with Expandable Questions
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FAQs | ElectVote</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">

    <style>
        /* Accordion Style for FAQs */
        .faq-item {
            background: white;
            border-radius: 12px;
            margin-bottom: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03);
            overflow: hidden;
            transition: 0.3s;
            border: 1px solid #E8EEF3;
        }
        
        .faq-question {
            padding: 20px 25px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 600;
            color: #1E56A0;
            font-size: 16px;
        }

        .faq-question:hover {
            background-color: #F8FAFF;
        }

        .faq-answer {
            padding: 0 25px 20px 25px;
            display: none; /* Hidden by default */
            color: #5F6D7E;
            font-size: 14px;
            line-height: 1.6;
            border-top: 1px solid #E8EEF3;
            margin-top: 10px;
            padding-top: 15px;
        }

        .faq-item.active .faq-answer {
            display: block; /* Show when active */
        }
        
        .faq-item.active .icon-toggle {
            transform: rotate(180deg);
        }

        .icon-toggle {
            transition: transform 0.3s ease;
            color: #8A92A6;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="nav-container">
            <div class="logo"><i class="fa-solid fa-check-to-slot"></i> ElectVote</div>
            <ul class="nav-links">
                <li><a href="index.jsp">Home</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="contact.jsp">Contact Us</a></li>
                <li><a href="faq.jsp" class="active">FAQs</a></li>
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
        <div class="container" style="width:65%; margin: 0 auto; max-width: 900px;">
            <div style="text-align: center; margin-bottom: 50px;">
                <h1 class="hero-title">Frequently Asked Questions</h1>
                <p class="hero-subtitle">Answers regarding ElectVote security, voting process, and account management.</p>
            </div>
            
            <div class="faq-list">
                
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Is the system secure for voters?
                        <i class="fa-solid fa-chevron-down icon-toggle"></i>
                    </div>
                    <div class="faq-answer">
                        Yes, we use advanced 256-bit encryption and secure session management to ensure that every vote cast is private, anonymous, and tamper-proof. Your vote data is encrypted before being stored in the database.
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        How do I reset my password if I forget it?
                        <i class="fa-solid fa-chevron-down icon-toggle"></i>
                    </div>
                    <div class="faq-answer">
                        If you are a student, please contact the system administrator or IT support at the main office. For security reasons, password resets are handled manually by verifying your student ID.
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Can I change my vote after submitting?
                        <i class="fa-solid fa-chevron-down icon-toggle"></i>
                    </div>
                    <div class="faq-answer">
                        No. Once a vote is confirmed and submitted, it is final. This rule ensures the integrity of the election results and prevents manipulation. Please review your choices carefully before confirming.
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        Who can see who I voted for?
                        <i class="fa-solid fa-chevron-down icon-toggle"></i>
                    </div>
                    <div class="faq-answer">
                        Nobody. The voting system is designed to be anonymous. While the system records <em>that</em> you voted (to prevent double voting), it does not link your identity to the specific candidate you selected.
                    </div>
                </div>

                 <div class="faq-item">
                    <div class="faq-question" onclick="toggleFaq(this)">
                        When will the election results be announced?
                        <i class="fa-solid fa-chevron-down icon-toggle"></i>
                    </div>
                    <div class="faq-answer">
                        Election results are typically published immediately after the election closes. You can view the results on the "Results" page of your student dashboard once the administrator finalizes the count.
                    </div>
                </div>

            </div>
        </div>
    </main>

    <script>
        function toggleFaq(element) {
            const parent = element.parentElement;
            
            // Close all other FAQs
            const allFaqs = document.querySelectorAll('.faq-item');
            allFaqs.forEach(item => {
                if (item !== parent) {
                    item.classList.remove('active');
                }
            });

            // Toggle current FAQ
            parent.classList.toggle('active');
        }
    </script>

</body>
</html>