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
import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AdminCandidateAddServlet")
@MultipartConfig // Required for image upload
public class AdminCandidateAddServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Form Data
        String eid = request.getParameter("eid");
        String studID = request.getParameter("studID");
        String positionName = request.getParameter("positionName"); // "President", "Secretary"
        String manifesto = request.getParameter("cManifesto");
        
        // 2. Handle Image Upload
        Part filePart = request.getPart("cImage");
        String fileName = "default_user.png";
        
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            // Path: web/images/
            String path = getServletContext().getRealPath("") + File.separator + "images" + File.separator + fileName;
            try (FileOutputStream fos = new FileOutputStream(path); InputStream is = filePart.getInputStream()) {
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
            } catch (Exception e) { e.printStackTrace(); }
        }

        try {
            Connection con = DBConnection.createConnection();

            // 3. Validation: Check if Student ID exists in 'student' table
            PreparedStatement psCheck = con.prepareStatement("SELECT stud_ID FROM student WHERE stud_ID = ?");
            psCheck.setString(1, studID);
            
            if (psCheck.executeQuery().next()) {
                
                // 4. Duplicate Check: Is student already a candidate in THIS election?
                String checkDup = "SELECT cand_ID FROM candidate WHERE stud_ID = ? AND election_ID = ?";
                PreparedStatement psDup = con.prepareStatement(checkDup);
                psDup.setString(1, studID);
                psDup.setString(2, eid);
                
                if (psDup.executeQuery().next()) {
                    // Error: Already registered
                    response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=duplicate");
                } else {
                    // 5. Insert New Candidate
                    // Note: Ensure your table columns match these names exactly!
                    String sql = "INSERT INTO candidate (cand_ManifestoDesc, cand_PhotoPath, stud_ID, election_ID, candidate_Position) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setString(1, manifesto);
                    ps.setString(2, fileName);
                    ps.setString(3, studID);
                    ps.setString(4, eid);
                    ps.setString(5, positionName);

                    int i = ps.executeUpdate();
                    if(i > 0) {
                        response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=success");
                    } else {
                        response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=error");
                    }
                }
            } else {
                // Error: Student ID not found
                response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=notfound");
            }
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminViewCandidates.jsp?eid=" + eid + "&msg=error");
        }
    }
}