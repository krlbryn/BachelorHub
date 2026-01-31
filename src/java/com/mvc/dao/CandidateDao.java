package com.mvc.dao;

import com.mvc.bean.CandidateBean;
import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CandidateDao {

    public List<CandidateBean> getCandidatesByElectionId(int electionId) {
        List<CandidateBean> candidates = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = DBConnection.createConnection();
            
            // --- FIXED SQL QUERY ---
            // 1. We join on 'candidate_Position' = 'position_Name' because your DB uses text.
            // 2. We also check 'election_ID' to make sure we don't mix up elections.
            String sql = "SELECT c.cand_ID, c.cand_ManifestoDesc, c.cand_PhotoPath, c.stud_ID, " +
                         "s.stu_Name, s.stu_Program, s.stu_Year, " +
                         "p.position_Name, p.position_ID " +  // Get ID from Position table, not Candidate table
                         "FROM candidate c " +
                         "JOIN student s ON c.stud_ID = s.stud_ID " +
                         "JOIN position p ON (c.candidate_Position = p.position_Name AND c.election_ID = p.election_ID) " +
                         "WHERE c.election_ID = ? " +
                         "ORDER BY p.position_ID, s.stu_Name";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, electionId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                CandidateBean candidate = new CandidateBean();
                candidate.setCandId(rs.getInt("cand_ID"));
                candidate.setManifesto(rs.getString("cand_ManifestoDesc"));
                candidate.setPhotoPath(rs.getString("cand_PhotoPath"));
                candidate.setStudId(rs.getInt("stud_ID"));
                
                // FIXED: Get position_ID from the Position table (p.position_ID)
                candidate.setPositionId(rs.getInt("position_ID"));
                
                // Set joined fields
                candidate.setStudName(rs.getString("stu_Name"));
                candidate.setStudProgram(rs.getString("stu_Program"));
                candidate.setStudYear(rs.getInt("stu_Year"));
                candidate.setPositionName(rs.getString("position_Name"));

                candidates.add(candidate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs!=null) rs.close(); } catch(Exception e){}
            try { if(pstmt!=null) pstmt.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return candidates;
    }
}