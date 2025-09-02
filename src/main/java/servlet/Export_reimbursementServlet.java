package servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
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
	            //PaymentDAO dao = new PaymentDAO();
	            //List<PaymentBean> paymentList = dao.reimbursementAll();

	            // Excel作成
	            XSSFWorkbook workbook = new XSSFWorkbook();
	            Sheet sheet = workbook.createSheet("test");
	            Row row0 = sheet.createRow(0);
	            Row row1 = sheet.createRow(1);
	            Row row2 = sheet.createRow(2);

	            Cell cell0 = row0.createCell(0);
	            Cell cell1 = row1.createCell(1);
	            Cell cell2 = row2.createCell(2);

	            cell0.setCellValue("Excelを出力してみた");
	            cell1.setCellValue(100 / 3.14);
	            cell2.setCellValue(12345.9876);

	            // ブラウザに直接ダウンロードさせる
	            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	            resp.setHeader("Content-Disposition", "attachment; filename=\"sampleExcelout.xlsx\"");

	            workbook.write(resp.getOutputStream());
	            workbook.close();

	        } catch (Exception e) {
	            throw new ServletException(e);
	        }
	    }
	}
	
	
	
	
	
	

	