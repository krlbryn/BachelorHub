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
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/AdminElectionUpdateServlet")
@MultipartConfig
public class AdminElectionUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Data
        String id = request.getParameter("eId");
        String title = request.getParameter("eName");
        String desc = request.getParameter("eDesc");
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");
        String status = request.getParameter("eStatus");
        String oldImage = request.getParameter("oldImage");

        // Handle Positions (Get array from checkboxes)
        String[] posArray = request.getParameterValues("positions");
        String positionsText = "";
        
        if(posArray != null && posArray.length > 0) {
            positionsText = String.join(",", posArray);
        } else {
            // Safety: If user unchecked everything, keep at least one
            positionsText = "President"; 
            posArray = new String[]{"President"};
        }

        // Format Dates
        if(start != null && !start.contains(":")) start += " 08:00:00";
        if(end != null && !end.contains(":")) end += " 17:00:00";

        // Handle Image
        Part filePart = request.getPart("eImage");
        String fileName = oldImage; // Default to old image
        
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
            con.setAutoCommit(false); // Start Transaction

            // 2. UPDATE Election Details
            String sql = "UPDATE election SET election_Title=?, election_Desc=?, election_StartDate=?, election_EndDate=?, election_Status=?, election_Positions=?, election_Image=? WHERE election_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, desc);
            ps.setString(3, start);
            ps.setString(4, end);
            ps.setString(5, status);
            ps.setString(6, positionsText); // Update text column
            ps.setString(7, fileName);
            ps.setString(8, id);

            int i = ps.executeUpdate();

            // 3. SYNCHRONIZE POSITIONS (The Important Part!)
            if (i > 0) {
                // A. Delete ALL old positions for this election
                // (We clear the slate so we don't have duplicates or leftover unchecked ones)
                String sqlDel = "DELETE FROM position WHERE election_ID = ?";
                PreparedStatement psDel = con.prepareStatement(sqlDel);
                psDel.setString(1, id);
                psDel.executeUpdate();

                // B. Insert the NEW list of positions
                if (posArray != null) {
                    String sqlIns = "INSERT INTO position (position_Name, position_Desc, election_ID) VALUES (?, ?, ?)";
                    PreparedStatement psIns = con.prepareStatement(sqlIns);
                    
                    for (String pName : posArray) {
                        psIns.setString(1, pName);
                        psIns.setString(2, "Role for " + title);
                        psIns.setString(3, id); // Link to current ID
                        psIns.addBatch();
                    }
                    psIns.executeBatch();
                }
            }

            con.commit(); // Save changes
            response.sendRedirect("adminElection.jsp?msg=updated");

        } catch (Exception e) {
            try { if(con != null) con.rollback(); } catch(Exception ex){}
            e.printStackTrace();
            response.sendRedirect("adminElection.jsp?msg=error");
        } finally {
            try { if(con != null) con.close(); } catch(Exception e){}
        }
    }
}
