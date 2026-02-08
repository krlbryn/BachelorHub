package com.mvc.util;

import com.mvc.bean.ElectionBean;
import com.mvc.dao.ElectionDao;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

public class CheckData {

    public static void main(String[] args) {
        System.out.println("=== DIAGNOSTIC START ===");
        
        // 1. Direct DB Check
        try {
            Connection con = DBConnection.createConnection();
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT count(*) FROM election");
            if (rs.next()) {
                System.out.println("Raw DB Count for 'election' table: " + rs.getInt(1));
            }
            
            rs = stmt.executeQuery("SELECT * FROM election");
            while(rs.next()) {
                System.out.println(" - Found Election: ID=" + rs.getInt("election_ID") + ", Title='" + rs.getString("election_Title") + "'");
            }
            con.close();
        } catch (Exception e) {
             System.out.println("DB Connection Failed: " + e.getMessage());
             e.printStackTrace();
        }

        // 2. DAO Check
        try {
            System.out.println("Testing ElectionDao...");
            ElectionDao dao = new ElectionDao();
            List<ElectionBean> list = dao.getAllElections();
            if (list == null) {
                System.out.println("DAO returned NULL list.");
            } else {
                System.out.println("DAO returned list of size: " + list.size());
                for (ElectionBean b : list) {
                     System.out.println(" - DAO Election: " + b.getElectionTitle());
                }
            }
        } catch (Exception e) {
            System.out.println("DAO Execution Failed: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("=== DIAGNOSTIC END ===");
    }
}
