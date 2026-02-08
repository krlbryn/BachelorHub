/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

/**
 *
 * @author user
 */



import com.mvc.util.DBConnection;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AdminElectionCreateServlet")
@MultipartConfig
public class AdminElectionCreateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Data
        String title = request.getParameter("eName");
        String desc = request.getParameter("eDesc");
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");
        String status = request.getParameter("eStatus");
        
        // Handle Positions (Get the array of checkboxes)
        String[] posArray = request.getParameterValues("positions");
        String positionsText = "";
        if(posArray != null && posArray.length > 0) {
            positionsText = String.join(",", posArray); // For display column
        } else {
            positionsText = "President,Secretary,Treasurer"; // Default
            posArray = new String[]{"President", "Secretary", "Treasurer"};
        }

        // Date Formatting
        if(start != null) start += " 08:00:00";
        if(end != null) end += " 17:00:00";

        // Image Upload
        Part filePart = request.getPart("eImage");
        String fileName = "default_election.jpg";
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            String path = getServletContext().getRealPath("") + File.separator + "images" + File.separator + fileName;
            try (FileOutputStream fos = new FileOutputStream(path); InputStream is = filePart.getInputStream()) {
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
            } catch (Exception e) {}
        }

        Connection con = null;
        try {
            con = DBConnection.createConnection();
            con.setAutoCommit(false); // Enable transaction for safety

            // 2. INSERT ELECTION (and request the Generated Key/ID)
            String sql = "INSERT INTO election (election_Title, election_Desc, election_StartDate, election_EndDate, election_Status, election_Positions, election_Image, admin_ID) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            // Note the Statement.RETURN_GENERATED_KEYS flag!
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, title);
            ps.setString(2, desc);
            ps.setString(3, start);
            ps.setString(4, end);
            ps.setString(5, status);
            ps.setString(6, positionsText); // Saves text for simple display
            ps.setString(7, fileName);
            ps.setInt(8, 1); 

            int i = ps.executeUpdate();
            
            // 3. GET THE NEW ELECTION ID
            int newElectionID = 0;
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) {
                newElectionID = rs.getInt(1); // Use this ID to link positions
            }

            // 4. SYNCHRONIZE: Insert selected positions into 'position' table
            if (i > 0 && newElectionID > 0 && posArray != null) {
                String sqlPos = "INSERT INTO position (position_Name, position_Desc, election_ID) VALUES (?, ?, ?)";
                PreparedStatement psPos = con.prepareStatement(sqlPos);
                
                for (String pName : posArray) {
                    psPos.setString(1, pName);
                    psPos.setString(2, "Role for " + title); // Simple description
                    psPos.setInt(3, newElectionID); // LINK TO THIS ELECTION
                    psPos.addBatch(); // Add to batch queue
                }
                psPos.executeBatch(); // Run all inserts at once
            }

            con.commit(); // Save everything
            response.sendRedirect("adminElection.jsp?msg=success");

        } catch (Exception e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            response.sendRedirect("adminElection.jsp?msg=error");
        } finally {
            try { if(con != null) con.close(); } catch(Exception e){}
        }
    }
}