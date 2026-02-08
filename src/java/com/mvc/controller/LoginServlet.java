/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mvc.controller;

/**
 *
 * @author ParaNon
 */
import com.mvc.bean.LoginBean;
import com.mvc.dao.LoginDao;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. CAPTURE INPUT
        // If Student: 'username' parameter contains the Student ID (e.g., "2025123456")
        // If Admin: 'username' parameter contains Admin Name (e.g., "admin")
        String usernameEntered = request.getParameter("username"); 
        String passwordEntered = request.getParameter("password");
        String role = request.getParameter("role");

        LoginBean loginBean = new LoginBean();
        loginBean.setUsername(usernameEntered); // Sets the ID/Name into the bean
        loginBean.setPassword(passwordEntered);

        LoginDao loginDao = new LoginDao();

        // 2. AUTHENTICATE
        // The DAO will now use the correct SQL column (stud_ID vs username) based on 'role'
        String result = loginDao.authenticateUser(loginBean, role);

        if (result.equals("SUCCESS")) {
            HttpSession session = request.getSession();
            
            // IMPORTANT: storing the Student ID in session allows you to identify them later
            session.setAttribute("userSession", usernameEntered); 
            session.setAttribute("userRole", role);

            // 3. REDIRECT
            if (role.equals("admin")) {
                request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/studentDashboard.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("errMessage", result);
            // Redirect back to login with the correct tab selected
            if (role.equals("admin")) {
                request.getRequestDispatcher("/login.jsp?type=admin").forward(request, response);
            } else {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }
}