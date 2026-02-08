package com.mvc.dao;

import com.mvc.bean.CandidateBean;
import com.mvc.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CandidateDao {

    public List<CandidateBean> getCandidatesByElectionId(int electionId) {
        List<CandidateBean> candidates = new ArrayList<>();
        // Note: Joining with student table to get the name based on stud_ID
        String sql = "SELECT c.*, s.stu_Name FROM candidate c "
                + "JOIN student s ON c.stud_ID = s.stud_ID "
                + "WHERE c.election_ID = ?";

        try (Connection con = DBConnection.createConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CandidateBean candidate = new CandidateBean();
                candidate.setCandId(rs.getInt("cand_ID")); // From database
                candidate.setStudName(rs.getString("stu_Name"));
                candidate.setPositionName(rs.getString("candidate_Position")); // From database
                candidate.setManifesto(rs.getString("cand_ManifestoDesc")); // From database
                candidate.setPhotoPath(rs.getString("cand_PhotoPath")); // From database
                candidate.setElectionId(rs.getInt("election_ID"));
                candidates.add(candidate);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return candidates;
    }
}
