/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

import com.mvc.util.DBConnection;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // REQUIRED for File Upload
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part; // REQUIRED to read parts (text & file)

/**
 * Servlet for updating Student Profile (Supports Image Upload).
 */
@WebServlet("/StudentUpdateServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class StudentUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // A. GET DATA FROM MULTIPART FORM
        // Note: request.getParameter() works for @MultipartConfig in newer Servlet versions, 
        // but using request.getPart() is safer if getParameter fails. 
        // We will try standard getParameter first for text fields.
        
        String idStr = request.getParameter("stud_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String program = request.getParameter("program");
        String yearStr = request.getParameter("year");

        // Validate Text Inputs
        int id = 0;
        int year = 1;
        try {
            id = Integer.parseInt(idStr);
            year = Integer.parseInt(yearStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("studentUpdateProfile.jsp?msg=Invalid ID or Year");
            return;
        }

        // B. HANDLE FILE UPLOAD
        String fileName = null;
        try {
            Part filePart = request.getPart("stu_Image"); // Match the input name="stu_Image"
            if (filePart != null && filePart.getSize() > 0) {
                // 1. Get Filename
                String submittedFileName = filePart.getSubmittedFileName();
                // Clean filename logic (basic)
                fileName = "stu_" + id + "_" + System.currentTimeMillis() + "_" + submittedFileName;

                // 2. Define Save Path (Project > web > images)
                // Note: In real production, save outside webapp. For this project, we save to build folder.
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                // 3. Save File
                String savePath = uploadPath + File.separator + fileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, new File(savePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            // If upload fails, we continue but don't update image column
            fileName = null; 
        }

        // C. UPDATE DATABASE
        try {
            Connection con = DBConnection.createConnection();
            PreparedStatement ps;

            if (fileName != null) {
                // Case 1: Updating Text AND Image
                String sql = "UPDATE student SET stu_Name=?, stu_Email=?, stu_Program=?, stu_Year=?, stu_Image=? WHERE stud_ID=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, program);
                ps.setInt(4, year);
                ps.setString(5, fileName); // Save filename to DB
                ps.setInt(6, id);
            } else {
                // Case 2: Updating Text ONLY (Keep old image)
                String sql = "UPDATE student SET stu_Name=?, stu_Email=?, stu_Program=?, stu_Year=? WHERE stud_ID=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, program);
                ps.setInt(4, year);
                ps.setInt(5, id);
            }

            int i = ps.executeUpdate();
            
            ps.close();
            con.close();

            if (i > 0) {
                // Success
                response.sendRedirect("studentProfile.jsp?status=updated");
            } else {
                // Failure
                response.sendRedirect("studentUpdateProfile.jsp?msg=Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("studentUpdateProfile.jsp?msg=Error: " + e.getMessage());
        }
    }
}