<%-- 
    Document   : adminDeleteElection
    Created on : Jan 29, 2026, 10:45:12?PM
    Author     : user
--%>

<%@page import="java.sql.*"%>
<%@page import="com.mvc.util.DBConnection"%>
<%
    String userSession = (String) session.getAttribute("userSession");
    if (userSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("eid"); // Election ID

    if(id != null) {
        Connection con = null;
        try {
            con = DBConnection.createConnection();
            con.setAutoCommit(false); // Safety Lock

            // 1. DELETE VOTES
            // Logic: Delete votes for candidates who hold a position in this election
            String sqlVotes = "DELETE FROM vote WHERE cand_ID IN " +
                              "(SELECT cand_ID FROM candidate WHERE position_ID IN " +
                              "(SELECT position_ID FROM position WHERE election_ID = ?))";
            PreparedStatement psVotes = con.prepareStatement(sqlVotes);
            psVotes.setString(1, id);
            psVotes.executeUpdate();
            psVotes.close();
            
            // 2. DELETE CANDIDATES
            // Logic: Delete candidates who hold a position in this election
            String sqlCand = "DELETE FROM candidate WHERE position_ID IN " +
                             "(SELECT position_ID FROM position WHERE election_ID = ?)";
            PreparedStatement psCand = con.prepareStatement(sqlCand);
            psCand.setString(1, id);
            psCand.executeUpdate();
            psCand.close();

            // 3. DELETE POSITIONS
            String sqlPos = "DELETE FROM position WHERE election_ID = ?";
            PreparedStatement psPos = con.prepareStatement(sqlPos);
            psPos.setString(1, id);
            psPos.executeUpdate();
            psPos.close();

            // 4. DELETE ELECTION
            String sqlElec = "DELETE FROM election WHERE election_ID = ?";
            PreparedStatement psElec = con.prepareStatement(sqlElec);
            psElec.setString(1, id);
            int i = psElec.executeUpdate();
            psElec.close();
            
            if(i > 0) {
                con.commit(); // Save Changes
                response.sendRedirect("adminElection.jsp?msg=deleted");
            } else {
                con.rollback(); // Undo if failed
                response.sendRedirect("adminElection.jsp?msg=error");
            }
            
        } catch(Exception e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            response.sendRedirect("adminElection.jsp?msg=Error: " + e.getMessage());
        } finally {
            try { if(con != null) con.close(); } catch(Exception ex){}
        }
    } else {
        response.sendRedirect("adminElection.jsp");
    }
%>