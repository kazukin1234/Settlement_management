package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import bean.PaymentBean;
import dao.PaymentDAO;

@WebServlet("/Export_reimbursement")
public class Export_reimbursementServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    try {
	        // DAOから立替金一覧を取得
	        PaymentDAO dao = new PaymentDAO();
	        List<PaymentBean> paymentList = dao.reimbursementAll();
	        req.setAttribute("paymentList", paymentList);

	     
	     // モードを export に設定
	        //String mode = "export";
	        req.setAttribute("mode2", "export");

	        req.setAttribute("showExportButton", true);
	       



	        // JSP にフォワード
	        req.getRequestDispatcher("/WEB-INF/views/serviceJSP/export_tatekaekinn.jsp")
	           .forward(req, resp);

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	    try {
	        // DAOから立替金一覧を取得
	        PaymentDAO dao = new PaymentDAO();
	        List<PaymentBean> paymentList = dao.reimbursementAll();

	        // Excel作成
	        XSSFWorkbook workbook = new XSSFWorkbook();
	        Sheet sheet = workbook.createSheet("立替金一覧");

	        // ヘッダー行
	        Row header = sheet.createRow(0);
	        String[] columns = {"申請ID", "社員ID", "社員名", "申請種別", "申請時間", "金額（税込）", "ステータス"};
	        for (int i = 0; i < columns.length; i++) {
	        	header.createCell(i).setCellValue(columns[i]);
	        }

	        // データ行
	        int rowNum = 1;
	        for (PaymentBean p : paymentList) {
	            Row row = sheet.createRow(rowNum++);
	            row.createCell(0).setCellValue(p.getApplicationId());
	            row.createCell(1).setCellValue(p.getStaffId());
	            row.createCell(2).setCellValue(p.getStaffName());
	            row.createCell(3).setCellValue(p.getApplicationType());
	            row.createCell(4).setCellValue(p.getCreatedAt().toString());
	            row.createCell(5).setCellValue(p.getAmount());
	            row.createCell(6).setCellValue(p.getStatus());
	        }

	        // ブラウザにダウンロード
	        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	        resp.setHeader("Content-Disposition", "attachment; filename=\"reimbursement.xlsx\"");
	        workbook.write(resp.getOutputStream());
	        workbook.close();

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

	 
	 
	}