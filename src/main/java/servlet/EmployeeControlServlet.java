package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.Employee;
import dao.EmployeeDAO;

@WebServlet("/employeeControl")
public class EmployeeControlServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		EmployeeDAO dao = new EmployeeDAO();
		List<Employee> list = dao.getAllEmployees();

		request.setAttribute("employeeList", list);
		request.getRequestDispatcher("/WEB-INF/views/employeeList.jsp").forward(request, response);
	}


	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");
		String[] selectedIds = request.getParameterValues("employeeID");

		if ("edit".equals(action)) {
			if (selectedIds != null && selectedIds.length == 1) {
				HttpSession session = request.getSession();
				session.setAttribute("editEmployeeId", selectedIds[0]);
				response.sendRedirect(request.getContextPath() + "/employeeRegisterPage");
			} else {
				request.setAttribute("errorMsg", "編集する社員を1名選択してください。");
				doGet(request, response);
			}
		} else if ("delete".equals(action)) {
			if (selectedIds != null && selectedIds.length > 0) {
				EmployeeDAO dao = new EmployeeDAO();
				boolean result = true;
				for (String id : selectedIds) {
					// /物理削除 → 論理削除に変更！
					if (!dao.logicalDeleteEmployee(id)) {
						result = false;
					}
				}
				if (result) {
					request.setAttribute("success", "削除が完了しました。");
				} else {
					request.setAttribute("errorMsg", "削除中にエラーが発生しました。");
				}
			} else {
				request.setAttribute("errorMsg", "削除する社員を選択してください。");
			}
			doGet(request, response);
		} else {
			doGet(request, response); 
		}
	}
}
