/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.elections.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.election.utils.DBConnection;

@WebServlet(name = "AddElectionServlets", urlPatterns = {"/AddElectionServlets"})
public class AddElectionServlets extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String start = request.getParameter("start_date");
        String end = request.getParameter("end_date");

        try {
            Connection con = DBConnection.getConnection();
            
            if (con == null) {
                System.out.println("Database connection failed!");
                response.sendRedirect("organizer/create_election.jsp?msg=db_error");
                return;
            }

            String sql = "INSERT INTO elections (title, start_date, end_date, status) VALUES (?, ?, ?, 'Upcoming')";
            PreparedStatement pst = con.prepareStatement(sql);
            
            pst.setString(1, title);
            pst.setString(2, start);
            pst.setString(3, end);

            pst.executeUpdate();
            con.close();

            response.sendRedirect("organizer/create_election.jsp?msg=success");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("organizer/create_election.jsp?msg=error");
        }
    }
}
