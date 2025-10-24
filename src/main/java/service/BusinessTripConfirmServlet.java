package service;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.BusinessTripBean;
//*出張費申請入力画面を出すためのサーブレット*/

@WebServlet("/businessTripConfirm")
public class BusinessTripConfirmServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("trip") == null) {
            response.sendRedirect(request.getContextPath() + "/businessTripInit");
            return;
        }

        BusinessTripBean trip = (BusinessTripBean) session.getAttribute("trip");
        trip.calculateTotalAmount();
        
        Boolean isEditMode = (Boolean) session.getAttribute("isEditMode");
        if (isEditMode == null) {
            isEditMode = false;
        }

        request.setAttribute("application_type", "出張費");
        request.setAttribute("trip", trip);
        
        if (isEditMode) {
            request.setAttribute("isEditMode", true); 
            request.setAttribute("showBackButton", true);
            request.setAttribute("backActionUrl", "/businessTripStep3");
            request.setAttribute("showSubmitButton", true);
            request.setAttribute("submitActionUrl", "/businessTripUpdate"); 
        } else {
            request.setAttribute("isEditMode", false);
            request.setAttribute("showBackButton", true);
            request.setAttribute("backActionUrl", "/businessTripStep3");
            request.setAttribute("showSubmitButton", true);
            request.setAttribute("submitActionUrl", "/businessTripSubmit");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/confirm/applicationConfirm.jsp").forward(request, response);
    }
}