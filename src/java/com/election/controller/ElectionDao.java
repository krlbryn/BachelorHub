/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.election.controller;

import com.mvc.bean.ElectionBean;
import com.mvc.util.DBConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Antigravity
 */
public class ElectionDao {

    public List<ElectionBean> getAllElections() {
        List<ElectionBean> elections = new ArrayList<>();
        Connection con = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            con = DBConnection.createConnection();
            statement = con.createStatement();
            String sql = "SELECT * FROM election ORDER BY election_ID DESC";
            resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
                ElectionBean election = new ElectionBean();
                election.setElectionId(resultSet.getInt("election_ID"));
                election.setElectionTitle(resultSet.getString("election_Title"));
                election.setElectionDesc(resultSet.getString("election_Desc"));
                election.setElectionStartDate(resultSet.getTimestamp("election_StartDate"));
                election.setElectionEndDate(resultSet.getTimestamp("election_EndDate"));
                election.setElectionStatus(resultSet.getString("election_Status"));
                election.setStudId(resultSet.getInt("stud_ID"));
                election.setAdminId(resultSet.getInt("admin_ID"));

                elections.add(election);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // In a real app, close resources here. 
            // DBConnection.createConnection() opens a new one every time in this project's style?
            // Ideally explicit close.
            try { if(resultSet!=null) resultSet.close(); } catch(Exception e){}
            try { if(statement!=null) statement.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return elections;
    }
    
    // Assumption: 'Active' is the status string. Adjust if database uses different convention.
    public List<ElectionBean> getActiveElections() {
        List<ElectionBean> elections = new ArrayList<>();
        Connection con = null;
        Statement statement = null;
        ResultSet resultSet = null;

        try {
            con = DBConnection.createConnection();
            statement = con.createStatement();
            String sql = "SELECT * FROM election WHERE election_Status = 'Active' ORDER BY election_StartDate ASC";
            resultSet = statement.executeQuery(sql);

            while (resultSet.next()) {
                ElectionBean election = new ElectionBean();
                election.setElectionId(resultSet.getInt("election_ID"));
                election.setElectionTitle(resultSet.getString("election_Title"));
                election.setElectionDesc(resultSet.getString("election_Desc"));
                election.setElectionStartDate(resultSet.getTimestamp("election_StartDate"));
                election.setElectionEndDate(resultSet.getTimestamp("election_EndDate"));
                election.setElectionStatus(resultSet.getString("election_Status"));
                
                elections.add(election);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
             try { if(resultSet!=null) resultSet.close(); } catch(Exception e){}
            try { if(statement!=null) statement.close(); } catch(Exception e){}
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
        return elections;
    }
}
