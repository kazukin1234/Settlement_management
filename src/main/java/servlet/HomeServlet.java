package servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.RoleUtil.UserRole;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false); 

        if (session == null || session.getAttribute("staffId") == null) {
            res.sendRedirect(req.getContextPath() + "/LoginServlet");
            return; 
        }
        UserRole role = (UserRole) session.getAttribute("userRole");
        if (role == null) {
            role = UserRole.UNKNOWN;
        }

       
        switch (role) {
///            
            default:
               
                req.getRequestDispatcher("/WEB-INF/views/staffMenu.jsp").forward(req, res);
                break;
        }
    }
}