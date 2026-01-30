package com.election.controller;

import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;

public class VoteDao {

    // Check if student has already voted for the position that the candidate belongs to
    public boolean hasVotedForPosition(int studId, int candidateId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean hasVoted = false;

        try {
            con = DBConnection.createConnection();
            
            // Query to finding if there is any vote by this student for a candidate 
            // who shares the same position_ID as the target candidateId.
            String sql = "SELECT v.vote_ID " +
                         "FROM vote v " +
                         "JOIN candidate c_voted ON v.cand_ID = c_voted.cand_ID " +
                         "WHERE v.stud_ID = ? " +
                         "AND c_voted.position_ID = (SELECT c_target.position_ID FROM candidate c_target WHERE c_target.cand_ID = ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, studId);
            pstmt.setInt(2, candidateId);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                hasVoted = true;
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

    public boolean castVote(int studId, int candidateId, int electionId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            con = DBConnection.createConnection();
            String sql = "INSERT INTO vote (cand_ID, stud_ID, election_ID, vote_Time) VALUES (?, ?, ?, ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, candidateId);
            pstmt.setInt(2, studId);
            pstmt.setInt(3, electionId);
            pstmt.setTimestamp(4, new Timestamp(new Date().getTime()));
            
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return success;
    }
}
