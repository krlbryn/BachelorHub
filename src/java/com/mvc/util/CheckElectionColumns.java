package com.mvc.util;


import java.sql.*;
import com.mvc.util.DBConnection;

public class CheckElectionColumns {
    public static void main(String[] args) {
        try {
            Connection con = DBConnection.createConnection();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM election LIMIT 1");
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            System.out.println("--- Election Table Columns ---");
            for (int i = 1; i <= columnCount; i++) {
                String name = rsmd.getColumnName(i);
                String type = rsmd.getColumnTypeName(i);
                System.out.println(name + " (" + type + ")");
            }
            
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
