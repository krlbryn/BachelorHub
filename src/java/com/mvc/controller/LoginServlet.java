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

// This annotation maps the URL from your JSP form (action="LoginServlet")
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the data from the login.jsp form
        String usernameEntered = request.getParameter("username");
        String passwordEntered = request.getParameter("password");

        // 2. Put the data into the Bean
        LoginBean loginBean = new LoginBean();
        loginBean.setUsername(usernameEntered);
        loginBean.setPassword(passwordEntered);

        // 3. Ask the DAO to check the database
        LoginDao loginDao = new LoginDao();
        String userValidate = loginDao.authenticateUser(loginBean);

        // 4. Check the result and redirect
        if (userValidate.equals("SUCCESS")) {
            // LOGIN SUCCESS: Create a session and go to the dashboard
            HttpSession session = request.getSession();
            session.setAttribute("userSession", usernameEntered); // Save user name for later
            
            // Redirect to a success page (You need to create this page!)
            request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
            
        } else {
            // LOGIN FAILED: Send them back to login.jsp with an error message
            request.setAttribute("errMessage", userValidate);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
