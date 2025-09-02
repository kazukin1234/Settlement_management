package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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

	    

	        
	        int rowNum = 0;
	        for (PaymentBean p : paymentList) {
	            Row row1 = sheet.createRow(rowNum++);
	            row1.createCell(0).setCellValue("立替金申請: ");
	            row1.createCell(1).setCellValue(p.getApplicationId());

	            Row row2 = sheet.createRow(rowNum++);
	            row2.createCell(0).setCellValue("年月: " + p.getCreatedAt());

	            Row row3 = sheet.createRow(rowNum++);
	            row3.createCell(0).setCellValue("名前: " + p.getStaffName());

	            rowNum++; // 空行を入れる場合
	        }


	        // ブラウザにダウンロード
	        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	        
	  
	        // ファイル名を作成
	        PaymentBean p = paymentList.get(0);
	        LocalDateTime createdAt = p.getCreatedAt().toLocalDateTime();
	        DateTimeFormatter formatter1 = DateTimeFormatter.ofPattern("yyyyMMdd_HHmm");
	        String rawFileName = "立替金申請_" + createdAt.format(formatter1) + "_" + p.getStaffName() + ".xlsx";

	        // URLエンコードしてヘッダにセット
	        String encodedFileName = URLEncoder.encode(rawFileName, StandardCharsets.UTF_8.toString());
	        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);

	        workbook.write(resp.getOutputStream());
	        workbook.close();

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

	 
	 
	}