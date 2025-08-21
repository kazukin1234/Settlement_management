package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import bean.PaymentBean;
import dao.PaymentDAO;


@WebServlet("/paymentList")
public class PaymentListServlet extends HttpServlet {
	/**
     * 
     */
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    try {
	        PaymentDAO dao = new PaymentDAO();
	        List<PaymentBean> paymentList = dao.findAll();
	        req.setAttribute("paymentList", paymentList);

	        // THEM DONG NAY ?? ?ANH D?U CONTEXT
	        req.setAttribute("mode", "payment"); 

	        req.getRequestDispatcher("payment.jsp").forward(req, resp);
	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}
}