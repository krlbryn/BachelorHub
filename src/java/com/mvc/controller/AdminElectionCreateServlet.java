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

@WebServlet("/AdminElectionCreateServlet")
@MultipartConfig // Essential for file uploads
public class AdminElectionCreateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Retrieve Data from Form
        String title = request.getParameter("eName");
        String desc = request.getParameter("eDesc");
        
        // Append time because DB is DATETIME (e.g., 2026-02-01 00:00:00)
        String startDate = request.getParameter("startDate") + " 00:00:00";
        String endDate = request.getParameter("endDate") + " 23:59:59";
        String status = request.getParameter("eStatus");
        
        // 2. Handle Checkboxes (Positions)
        String[] posArray = request.getParameterValues("positions");
        String positions = "";
        if (posArray != null) {
            positions = String.join(",", posArray); // Converts ["President", "VP"] to "President,VP"
        }

        // 3. Handle File Upload
        Part filePart = request.getPart("eImage");
        String fileName = "default_election.jpg"; 
        
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            // Save to 'build/web/images' for immediate viewing
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

        // 4. Save to Database
        try {
            Connection con = DBConnection.createConnection();
            
            // Query uses YOUR table columns
            String sql = "INSERT INTO election (election_Title, election_Desc, election_StartDate, election_EndDate, election_Status, election_Positions, election_Image) VALUES (?, ?, ?, ?, ?, ?, ?)";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, desc);
            ps.setString(3, startDate);
            ps.setString(4, endDate);
            ps.setString(5, status);
            ps.setString(6, positions); // Saves "President,VP,Secretary"
            ps.setString(7, fileName);

            int i = ps.executeUpdate();
            
            if (i > 0) {
                response.sendRedirect("adminElection.jsp?msg=success");
            } else {
                response.sendRedirect("adminElection.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("DB Error: " + e.getMessage()); 
            response.sendRedirect("adminElection.jsp?msg=error_db");
        }
    }
}