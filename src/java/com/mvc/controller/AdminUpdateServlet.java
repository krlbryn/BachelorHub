/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


/**
 *
 * @author ParaNon
 */
package com.mvc.controller;

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

// 1. Map the URL so the form can find it
@WebServlet("/AdminUpdateServlet")
// 2. This annotation IS MANDATORY for file uploads
@MultipartConfig
public class AdminUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // A. Get Text Data
        String id = request.getParameter("admin_id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String oldImage = request.getParameter("oldImage"); // In case they don't upload a new one

        String finalFileName = oldImage;

        // B. Handle File Upload
        Part filePart = request.getPart("imageFile"); // Matches name="imageFile" in JSP
        
        // If the user actually selected a file (size > 0)
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            
            // Generate a unique name to prevent duplicates (optional, but good practice)
            // e.g., "admin_1_profile.jpg"
            finalFileName = fileName; 

            // C. Save the file to the "images" folder
            // NOTE: This saves to the build directory. If you "Clean & Build", it might vanish!
            String path = getServletContext().getRealPath("") + File.separator + "images" + File.separator + finalFileName;
            
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

        // D. Update Database
        try {
            Connection con = DBConnection.createConnection();
            String sql = "UPDATE admin SET admin_Name=?, admin_Email=?, admin_Phone=?, admin_Address=?, admin_Image=? WHERE admin_ID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, address);
            ps.setString(5, finalFileName); // Save the filename (e.g., "photo.jpg")
            ps.setString(6, id);

            int i = ps.executeUpdate();
            
            if (i > 0) {
                response.sendRedirect("adminProfile.jsp?status=updated");
            } else {
                response.sendRedirect("adminUpdateProfile.jsp?msg=Update Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}