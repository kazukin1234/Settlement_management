package servlet;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.Employee;
import dao.EmployeeDAO;


@WebServlet("/employeeRegisterPage")
public class EmployeeRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String editId = (String) session.getAttribute("editEmployeeId");

		if (editId != null) {
			// Nếu có ID từ session, tức là đang edit
			EmployeeDAO dao = new EmployeeDAO();
			Employee emp = dao.findById(editId);

			if (emp != null) {
				request.setAttribute("employeeId", emp.getEmployeeId());
				request.setAttribute("fullName", emp.getFullName());
				request.setAttribute("furigana", emp.getFurigana());
				request.setAttribute("birthDateStr", emp.getBirthDate().toString());
				request.setAttribute("address", emp.getAddress());
				request.setAttribute("joinDateStr", emp.getJoinDate().toString());
				request.setAttribute("departmentId", emp.getDepartmentId());
				request.setAttribute("positionId", emp.getPositionId());
			}
		}
		request.getRequestDispatcher("/WEB-INF/views/employeeRegister.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String action = request.getParameter("action");

		HttpSession session = request.getSession();

		// Lấy dữ liệu
		String employeeId = request.getParameter("employeeId");
		String fullName = request.getParameter("fullName");
		String furigana = request.getParameter("furigana");
		String birthDateStr = request.getParameter("birthDate");
		String address = request.getParameter("address");
		String joinDateStr = request.getParameter("joinDate");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String departmentId = request.getParameter("departmentId");
		String positionId = request.getParameter("positionId");

		if ("confirm".equals(action)) {
			// Kiểm tra xác nhận mật khẩu
			if (!password.equals(confirmPassword)) {
				request.setAttribute("error", "パスワードが一致しません。");
				request.getRequestDispatcher("/WEB-INF/views/employeeRegister.jsp").forward(request, response);
				return;
			}

			// Tạo Employee và lưu session
			Employee emp = new Employee();
			emp.setEmployeeId(employeeId);
			emp.setFullName(fullName);
			emp.setFurigana(furigana);
			emp.setBirthDate(Date.valueOf(birthDateStr));
			emp.setAddress(address);
			emp.setJoinDate(Date.valueOf(joinDateStr));
			emp.setPassword(password);
			emp.setDepartmentId(departmentId);
			emp.setPositionId(positionId);

			session.setAttribute("employeeTemp", emp);
			request.getRequestDispatcher("/WEB-INF/views/employeeConfirm.jsp").forward(request, response);

		} else if ("register".equals(action) || "update".equals(action)) {
		    Employee emp = (Employee) session.getAttribute("employeeTemp");
		    if (emp == null) {
		        response.sendRedirect(request.getContextPath() + "/employeeRegisterPage");
		        return;
		    }

		    EmployeeDAO dao = new EmployeeDAO();
		    boolean result = false;

		    try {
		        if ("update".equals(action)) {
		            String newPassword = emp.getPassword();

		            if (newPassword != null && !newPassword.isEmpty()) {
		                // スワードが入力された場合、ハッシュ化して更新
		                String hashedPassword = Employee.hashPassword(newPassword);
		                emp.setPassword(hashedPassword);
		            } else {
		                // パスワード未入力の場合、DBの既存パスワードを維持
		                String oldPassword = dao.findPasswordById(emp.getEmployeeId());
		                emp.setPassword(oldPassword);
		            }

		            result = dao.updateEmployee(emp);

		        } else {
		            // 新規登録の場合：必ずパスワードをハッシュ化する
		            String hashedPassword = Employee.hashPassword(emp.getPassword());
		            emp.setPassword(hashedPassword);
		            result = dao.insertEmployee(emp);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        request.setAttribute("error", "処理中に予期しないエラーが発生しました。");
		        request.getRequestDispatcher("/WEB-INF/views/employeeConfirm.jsp").forward(request, response);
		        return;
		    }

		    if (result) {
		        session.removeAttribute("employeeTemp");
		        session.removeAttribute("editEmployeeId");
		        session.setAttribute("success", ("update".equals(action)) ? "更新が完了しました。" : "登録が完了しました。");
		        response.sendRedirect(request.getContextPath() + "/employeeControl");
		    } else {
		        request.setAttribute("error", "処理中にエラーが発生しました。");
		        request.getRequestDispatcher("/WEB-INF/views/employeeConfirm.jsp").forward(request, response);
		    }
		}
 else if ("back".equals(action)) {
			Employee emp = (Employee) session.getAttribute("employeeTemp");

			if (emp != null) {
				// リクエストにデータをセットして画面に表示する
				request.setAttribute("employeeId", emp.getEmployeeId());
				request.setAttribute("fullName", emp.getFullName());
				request.setAttribute("furigana", emp.getFurigana());
				request.setAttribute("birthDateStr", emp.getBirthDate().toString());
				request.setAttribute("address", emp.getAddress());
				request.setAttribute("joinDateStr", emp.getJoinDate().toString());
				request.setAttribute("password", "");
				request.setAttribute("confirmPassword", "");
				request.setAttribute("departmentId", emp.getDepartmentId());
				request.setAttribute("positionId", emp.getPositionId());
			}

			request.getRequestDispatcher("/WEB-INF/views/employeeRegister.jsp").forward(request, response);
		} else if ("cancel".equals(action)) {
			session.removeAttribute("employeeTemp");
			session.removeAttribute("editEmployeeId");
			response.sendRedirect(request.getContextPath() + "/employeeControl"); 
		}

	}
}
