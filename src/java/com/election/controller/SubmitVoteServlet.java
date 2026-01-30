

import com.mvc.dao.VoteDao;
import java.io.IOException;
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
        String userSession = (String) session.getAttribute("userSession"); 
        
        Integer studId = (Integer) session.getAttribute("studId");
        
        if (userSession == null || studId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String electionIdStr = request.getParameter("electionId");
        String candidateIdStr = request.getParameter("candidateId");

        if (electionIdStr != null && candidateIdStr != null) {
            int electionId = Integer.parseInt(electionIdStr);
            int candidateId = Integer.parseInt(candidateIdStr);
            
            VoteDao voteDao = new VoteDao();
            
            if (voteDao.hasVotedForPosition(studId, candidateId)) {
                // User already voted for this position
                // Redirect with error message
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
        } else {
            response.sendRedirect("studentVote.jsp");
        }
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
