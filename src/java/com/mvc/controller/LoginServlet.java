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

        String usernameEntered = request.getParameter("username");
        String passwordEntered = request.getParameter("password");

        // 1. GET THE HIDDEN ROLE FROM JSP
        String role = request.getParameter("role");

        LoginBean loginBean = new LoginBean();
        loginBean.setUsername(usernameEntered);
        loginBean.setPassword(passwordEntered);

        LoginDao loginDao = new LoginDao();

        // 2. PASS THE ROLE TO DAO
        String result = loginDao.authenticateUser(loginBean, role);

        if (result.equals("SUCCESS")) {
            HttpSession session = request.getSession();
            session.setAttribute("userSession", usernameEntered);
            session.setAttribute("userRole", role);

            // 3. REDIRECT BASED ON ROLE
            if (role.equals("admin")) {
                request.getRequestDispatcher("/adminDashboard.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/studentDashboard.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("errMessage", result);
            // If login fails, keep them on the correct page type!
            if (role.equals("admin")) {
                request.getRequestDispatcher("/login.jsp?type=admin").forward(request, response);
            } else {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }
    }
}
