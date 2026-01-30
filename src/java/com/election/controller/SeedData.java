package com.election.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class SeedData {

    public static void main(String[] args) {
        Connection con = null;
        try {
            System.out.println("Connecting to database...");
            con = DBConnection.createConnection();
            
            if (con == null) {
                System.out.println("Failed to connect to database!");
                return;
            }

            // 2. Create an Active Election
            System.out.println("Creating sample election...");
            String sqlElection = "INSERT INTO election (election_Title, election_Desc, election_StartDate, election_EndDate, election_Status, admin_ID) " +
                                 "VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement pstmtEl = con.prepareStatement(sqlElection, Statement.RETURN_GENERATED_KEYS);
            pstmtEl.setString(1, "Student Council Election 2024");
            pstmtEl.setString(2, "Annual election for student representatives.");
            pstmtEl.setTimestamp(3, new Timestamp(System.currentTimeMillis())); // Start now
            pstmtEl.setTimestamp(4, new Timestamp(System.currentTimeMillis() + 604800000)); // End in 7 days
            pstmtEl.setString(5, "Active");
            pstmtEl.setInt(6, 1);
            try {
                pstmtEl.executeUpdate();
            } catch (Exception e) {
                 Statement stmtExp = con.createStatement();
                 stmtExp.executeUpdate("INSERT IGNORE INTO admin (admin_ID, admin_username, admin_Password) VALUES (1, 'admin', 'admin')");
                 pstmtEl.setInt(6, 1);
                 pstmtEl.executeUpdate();
            }
            
            ResultSet rsEl = pstmtEl.getGeneratedKeys();
            int electionId = 0;
            if (rsEl.next()) {
                electionId = rsEl.getInt(1);
            }
            System.out.println("Created Election ID: " + electionId);

            System.out.println("Creating positions...");
            String[] positions = {"President", "Vice President", "Secretary"};
            List<Integer> positionIds = new ArrayList<>();
            
            String sqlPos = "INSERT INTO position (position_Name, position_Desc, election_ID) VALUES (?, ?, ?)";
            PreparedStatement pstmtPos = con.prepareStatement(sqlPos, Statement.RETURN_GENERATED_KEYS);
            
            for (String pos : positions) {
                pstmtPos.setString(1, pos);
                pstmtPos.setString(2, "Role of " + pos);
                pstmtPos.setInt(3, electionId);
                pstmtPos.executeUpdate();
                
                ResultSet rsPos = pstmtPos.getGeneratedKeys();
                if (rsPos.next()) {
                    positionIds.add(rsPos.getInt(1));
                }
            }

            System.out.println("Checking for students...");
            Statement stmtStud = con.createStatement();
            ResultSet rsStud = stmtStud.executeQuery("SELECT stud_ID FROM student LIMIT 5");
            List<Integer> studentIds = new ArrayList<>();
            while (rsStud.next()) {
                studentIds.add(rsStud.getInt(1));
            }
            
            if (studentIds.size() < 3) {
                System.out.println("Creating dummy students...");
                String sqlStud = "INSERT INTO student (stu_Name, stu_Username, stu_Password, stu_Program, stu_Year, stu_PhoneNum, stu_Gender) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmtStud = con.prepareStatement(sqlStud, Statement.RETURN_GENERATED_KEYS);
                
                for (int i = 1; i <= 5; i++) {
                    pstmtStud.setString(1, "Student " + i);
                    pstmtStud.setString(2, "student" + i);
                    pstmtStud.setString(3, "pass" + i);
                    pstmtStud.setString(4, "CS");
                    pstmtStud.setInt(5, 2);
                    pstmtStud.setString(6, "123456789");
                    pstmtStud.setString(7, "M");
                    pstmtStud.executeUpdate();
                    
                    ResultSet rsS = pstmtStud.getGeneratedKeys();
                    if (rsS.next()) studentIds.add(rsS.getInt(1));
                }
            }

            System.out.println("Creating candidates...");
            String sqlCand = "INSERT INTO candidate (cand_ManifestoDesc, cand_PhotoPath, stud_ID, position_ID) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmtCand = con.prepareStatement(sqlCand);
            
            // Assign students to positions
            int studentIdx = 0;
            for (int posId : positionIds) {
                // Add 1 or 2 candidates per position
                if (studentIdx < studentIds.size()) {
                    pstmtCand.setString(1, "I promise to serve!");
                    pstmtCand.setString(2, "images/candidates/default.jpg"); // Placeholder
                    pstmtCand.setInt(3, studentIds.get(studentIdx++));
                    pstmtCand.setInt(4, posId);
                    pstmtCand.executeUpdate();
                }
                if (studentIdx < studentIds.size()) {
                     pstmtCand.setString(1, "Vote for me!");
                    pstmtCand.setString(2, "images/candidates/default.jpg"); // Placeholder
                    pstmtCand.setInt(3, studentIds.get(studentIdx++));
                    pstmtCand.setInt(4, posId);
                    pstmtCand.executeUpdate();
                }
            }
            
            System.out.println("Database seeded successfully!");
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(con!=null) con.close(); } catch(Exception e){}
        }
    }
}
