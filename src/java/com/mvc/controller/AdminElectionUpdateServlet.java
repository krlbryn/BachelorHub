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
@MultipartConfig // Crucial for file uploads
public class AdminElectionUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get Text Data
        String id = request.getParameter("eId");
        String title = request.getParameter("eName");
        String desc = request.getParameter("eDesc");
        
        // Append time because DB is DATETIME
        String startDate = request.getParameter("startDate") + " 00:00:00";
        String endDate = request.getParameter("endDate") + " 23:59:59";
        String status = request.getParameter("eStatus");
        String oldImage = request.getParameter("oldImage");

        // 2. Handle Positions (Convert Array back to String)
        String[] posArray = request.getParameterValues("positions");
        String positions = "";
        if (posArray != null) {
            positions = String.join(",", posArray);
        }

        // 3. Handle Image Logic
        Part filePart = request.getPart("eImage");
        String finalFileName = oldImage; // Default to old image

        // Only save a new file if the user actually selected one
        if (filePart != null && filePart.getSize() > 0) {
            finalFileName = filePart.getSubmittedFileName();
            String path = getServletContext().getRealPath("") + File.separator + "images" + File.separator + finalFileName;
            
            try {
                FileOutputStream fos = new FileOutputStream(path);
                InputStream is = filePart.getInputStream();
                byte[] data = new byte[is.available()];
                is.read(data);
                fos.write(data);
                fos.close();
            } catch(Exception e) {
                e.printStackTrace();
            }
        }

        // 4. Update Database
        try {
            Connection con = DBConnection.createConnection();
            
            String sql = "UPDATE election SET election_Title=?, election_Desc=?, election_StartDate=?, election_EndDate=?, election_Status=?, election_Positions=?, election_Image=? WHERE election_ID=?";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setString(2, desc);
            ps.setString(3, startDate);
            ps.setString(4, endDate);
            ps.setString(5, status);
            ps.setString(6, positions);
            ps.setString(7, finalFileName);
            ps.setString(8, id); // The WHERE clause

            int i = ps.executeUpdate();
            
            if (i > 0) {
                response.sendRedirect("adminElection.jsp?msg=updated");
            } else {
                response.sendRedirect("adminElection.jsp?msg=error");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Update Error: " + e.getMessage());
        }
    }
}
