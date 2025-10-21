package servlet;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.Employee;
import dao.EmployeeDAO;
import dao.ProjectDAO;
import util.RoleUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String staffId = request.getParameter("staffId");
        String password = request.getParameter("password");

        EmployeeDAO dao = new EmployeeDAO();
        Employee staff = dao.findByIdAndPassword(staffId, password);

        
        if (staff != null) {
            HttpSession session = request.getSession();

            session.setAttribute("staffId", staff.getEmployeeId());
            session.setAttribute("staffName", staff.getFullName());
            session.setAttribute("position_id", staff.getPositionId());
            session.setAttribute("department_id", staff.getDepartmentId());
            
            ProjectDAO proDao = new ProjectDAO();
            Map<String, Integer> statusCount = proDao.countApplicationByStatusByStaff(staffId);

            request.setAttribute("countMiteishutsu", statusCount.getOrDefault("未提出", 0));
            request.setAttribute("countTeishutsu", statusCount.getOrDefault("提出済み", 0));
            request.setAttribute("countSashimodoshi", statusCount.getOrDefault("差戻し", 0));


            RoleUtil.UserRole role = RoleUtil.detectRole(staff.getPositionId(), staff.getDepartmentId());
            session.setAttribute("userRole", role);
            
            System.out.println("Login success for staffId: " + staff.getEmployeeId() + ", Role: " + role);

            request.getRequestDispatcher("/WEB-INF/views/staffMenu.jsp").forward(request, response);
        } else {
            System.out.println("Login failed - user not found or wrong password");
            request.setAttribute("error", "社員IDまたはパスワードが違います"); 
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}






//////////////////////////////////ハッシュ

//package servlet;
//
//import java.io.IOException;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//import bean.Employee;
//import dao.EmployeeDAO;
//import util.RoleUtil;
//
///**
// * ログイン機能を提供するサーブレット。
// */
//@WebServlet("/LoginServlet")
//public class LoginServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//
//    /**
//     * ログイン画面を表示する。
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
//    }
//
//    /**
//     * ログイン認証処理。
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String staffId = request.getParameter("staffId");
//        String password = request.getParameter("password");
//
//        try {
//            String hashedPassword = Employee.hashPassword(password);
//
//            EmployeeDAO dao = new EmployeeDAO();
//            Employee staff = dao.findByIdAndPassword(staffId, hashedPassword);
//
//            if (staff != null) {
//                HttpSession session = request.getSession();
//
//                // === GIỮ NGUYÊN ĐỂ KHÔNG ẢNH HƯỞNG TEAM ===
//                session.setAttribute("staffId", staff.getEmployeeId());
//                session.setAttribute("staffName", staff.getFullName());
//                session.setAttribute("position_id", staff.getPositionId());
//                session.setAttribute("department_id", staff.getDepartmentId());
//
//                RoleUtil.UserRole role = RoleUtil.detectRole(staff.getPositionId(), staff.getDepartmentId());
//                session.setAttribute("userRole", role);
//
//                System.out.println("Login success for staffId: " + staff.getEmployeeId() + ", Role: " + role);
//
//                request.getRequestDispatcher("/WEB-INF/views/staffMenu.jsp").forward(request, response);
//            } else {
//                System.out.println("Login failed - user not found or wrong password");
//                request.setAttribute("error", "社員IDまたはパスワードが違います");
//                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "システムエラーが発生しました");
//            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
//        }
//    }
//}
