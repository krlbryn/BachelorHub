package com.mvc.dao;

import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class VoteDao {

    // 1. CHECK LOGIC: Ensures one vote per position per election
    public boolean hasVotedForPosition(int studId, int candidateId, int electionId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean hasVoted = false;

        try {
            con = DBConnection.createConnection();
            
            // SMART SQL QUERY:
            // "Find any vote (v) by this student in this election...
            // ...where the candidate they voted for (existing_cand) ...
            // ...has the SAME POSITION NAME as the candidate they want to vote for now (new_cand)."
            String sql = "SELECT v.vote_ID " +
                         "FROM vote v " +
                         "JOIN candidate existing_cand ON v.cand_ID = existing_cand.cand_ID " +
                         "JOIN candidate new_cand ON new_cand.cand_ID = ? " + 
                         "WHERE v.stud_ID = ? " +
                         "AND v.election_ID = ? " +
                         "AND existing_cand.candidate_Position = new_cand.candidate_Position";

            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, candidateId); // The candidate they WANT to vote for
            pstmt.setInt(2, studId);      // The student ID
            pstmt.setInt(3, electionId);  // The election ID
            
            rs = pstmt.executeQuery();

            if (rs.next()) {
                hasVoted = true; // Found a matching record, so they BLOCKED from voting again
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return hasVoted;
    }

    // 2. INSERT VOTE
    public boolean castVote(int studId, int candidateId, int electionId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = DBConnection.createConnection();
            // Insert the vote with the current timestamp
            String sql = "INSERT INTO vote (vote_Time, cand_ID, stud_ID, election_ID) VALUES (NOW(), ?, ?, ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, candidateId);
            pstmt.setInt(2, studId);
            pstmt.setInt(3, electionId);
            
            int i = pstmt.executeUpdate();
            
            if (i > 0) {
                // OPTIONAL: Update the summary table (electionresult) immediately
                updateElectionResult(candidateId, electionId);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return false;
    }

    // Helper to keep the result table in sync (Optional but recommended)
    private void updateElectionResult(int candidateId, int electionId) {
        try {
            Connection con = DBConnection.createConnection();
            // Try to update existing row
            String update = "UPDATE electionresult SET totalVotes = totalVotes + 1 WHERE cand_ID = ? AND election_ID = ?";
            PreparedStatement pst = con.prepareStatement(update);
            pst.setInt(1, candidateId);
            pst.setInt(2, electionId);
            pst.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}