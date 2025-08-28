package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.ProjectAmountDTOBean;
import bean.ProjectList;
import dao.ProjectDAO;

/**
 * プロジェクト管理画面の表示を行うサーブレット。
 */
@WebServlet("/project_management_view")
public class ProjectManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            ProjectDAO dao = new ProjectDAO();  
            List<ProjectList> projectList_management = dao.getAllProject_management();

            // 各プロジェクトごとにactual金額を取得
            for (ProjectList pj : projectList_management) {
                ProjectAmountDTOBean amount = dao.getTotalAmountByProjectCode(pj.getProject_code());
                pj.setProject_actual(amount.getTotalProjectAmount());
            }

            req.setAttribute("projectList_management", projectList_management);

            // セッションからメッセージ取得
            HttpSession session = req.getSession();
            String successMsg = (String) session.getAttribute("successMsg");
            String errorMsg = (String) session.getAttribute("errorMsg");

            if (successMsg != null) {
                req.setAttribute("successMsg", successMsg);
                session.removeAttribute("successMsg");
            }
            if (errorMsg != null) {
                req.setAttribute("errorMsg", errorMsg);
                session.removeAttribute("errorMsg");
            }

            req.setAttribute("list", projectList_management);

            req.getRequestDispatcher("/WEB-INF/views/projectList.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
