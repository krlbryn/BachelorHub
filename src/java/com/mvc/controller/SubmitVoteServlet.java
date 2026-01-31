package com.mvc.controller;

import com.mvc.dao.VoteDao;
import com.mvc.util.DBConnection; // Import DB Connection
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "SubmitVoteServlet", urlPatterns = {"/SubmitVoteServlet"})
public class SubmitVoteServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userSession = (String) session.getAttribute("userSession"); // This is the Username

        // 1. Safe Retrieval of studId (Handles Integers, Strings, or Nulls)
        Integer studId = null;
        Object studIdObj = session.getAttribute("studId");

        if (studIdObj != null) {
            if (studIdObj instanceof Integer) {
                studId = (Integer) studIdObj;
            } else if (studIdObj instanceof String) {
                try {
                    studId = Integer.parseInt((String) studIdObj);
                } catch (NumberFormatException e) {
                    studId = null;
                }
            }
        }

        // 2. EMERGENCY FIX: If ID is missing, try to fetch it from DB using the Username
        if (userSession != null && studId == null) {
            System.out.println("SubmitVoteServlet: studId missing in session. Attempting recovery for user: " + userSession);
            studId = getStudentIdFromDatabase(userSession);
            if (studId != null) {
                session.setAttribute("studId", studId); // Save it back to session
            }
        }

        // 3. Final Check: If still null, THEN redirect
        if (userSession == null || studId == null) {
            System.out.println("SubmitVoteServlet: Login check failed. Redirecting to login.jsp");
            response.sendRedirect("login.jsp");
            return;
        }

        String electionIdStr = request.getParameter("electionId");
        String candidateIdStr = request.getParameter("candidateId");

        if (electionIdStr != null && candidateIdStr != null) {
            try {
                int electionId = Integer.parseInt(electionIdStr);
                int candidateId = Integer.parseInt(candidateIdStr);

                VoteDao voteDao = new VoteDao();

// UPDATED LINE: Pass 'electionId' to the check method
                if (voteDao.hasVotedForPosition(studId, candidateId, electionId)) {

                    // User already voted for this position
                    session.setAttribute("voteMessage", "You have already voted for this position!");
                    session.setAttribute("voteMessageType", "error");

                } else {
                    boolean success = voteDao.castVote(studId, candidateId, electionId);
                    if (success) {
                        session.setAttribute("voteMessage", "Vote cast successfully!");
                        session.setAttribute("voteMessageType", "success");
                    } else {
                        session.setAttribute("voteMessage", "Failed to cast vote. Try again.");
                        session.setAttribute("voteMessageType", "error");
                    }
                }
                response.sendRedirect("voteCandidate.jsp?electionId=" + electionId);
            } catch (NumberFormatException e) {
                response.sendRedirect("studentVote.jsp");
            }
        } else {
            response.sendRedirect("studentVote.jsp");
        }
    }

    // --- HELPER METHOD TO RECOVER ID ---
    private Integer getStudentIdFromDatabase(String username) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = DBConnection.createConnection();
            // NOTE: Check if your table uses 'stu_Username' or 'username'. 
            // Based on your screenshot, it is 'stu_Username'.
            String sql = "SELECT stud_ID FROM student WHERE stu_Username = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("stud_ID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources manually or use try-with-resources
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception e) {
            }
            try {
                if (pstmt != null) {
                    pstmt.close();
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
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
