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
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@WebServlet("/AdminCandidateAddServlet")
@MultipartConfig // Crucial for File Uploads!
public class AdminCandidateAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Form Data
        String eid = request.getParameter("eid");
        String studID = request.getParameter("studID"); // This is the Student ID/Matric
        String posId = request.getParameter("posId");
        String manifesto = request.getParameter("cManifesto");
        
        // 2. Handle Image Upload
        Part filePart = request.getPart("cImage");
        String fileName = "default_user.png"; // Default image if none uploaded
        
        if (filePart != null && filePart.getSize() > 0) {
            // Extract filename and save to "images" folder
            fileName = filePart.getSubmittedFileName();
            // Note: Adjust path if necessary for your server setup
            String path = getServletContext().getRealPath("") + File.separator + "images" + File.separator + fileName;
            
            try {
                FileOutputStream fos = new FileOutputStream(path);
                InputStream is = filePart.getInputStream();
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
                fos.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            Connection con = DBConnection.createConnection();

            // 3. VALIDATION: Does this Student ID exist?
            String checkStudent = "SELECT stud_ID FROM student WHERE stud_ID = ?";
            PreparedStatement psCheck = con.prepareStatement(checkStudent);
            psCheck.setString(1, studID);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // Student Exists! Now check for Duplicates in this election
                // We check if this student is already a candidate in any position for THIS election
                // (Assuming a student can only run for one position per election)
                String checkDup = "SELECT c.cand_ID FROM candidate c " +
                                  "JOIN position p ON c.position_ID = p.position_ID " +
                                  "WHERE c.stud_ID = ? AND p.election_ID = ?";
                                  
                PreparedStatement psDup = con.prepareStatement(checkDup);
                psDup.setString(1, studID);
                psDup.setString(2, eid);
                ResultSet rsDup = psDup.executeQuery();

                if (rsDup.next()) {
                    // ERROR: Student is already a candidate!
                    response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=duplicate");
                } else {
                    // 4. SUCCESS: Insert the new candidate
                    String sql = "INSERT INTO candidate (cand_ManifestoDesc, cand_PhotoPath, stud_ID, position_ID) VALUES (?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, manifesto);
                    ps.setString(2, fileName);
                    ps.setString(3, studID);
                    ps.setString(4, posId);

                    int i = ps.executeUpdate();
                    
                    if (i > 0) {
                        response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=success");
                    } else {
                        response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=error");
                    }
                }
            } else {
                // ERROR: Student ID not found
                response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=notfound");
            }
            
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=error");
        }
    }
}