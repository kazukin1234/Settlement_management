package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import bean.PaymentBean;
import bean.ReimbursementDetailBean;
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
	        // パラメータから applicationId を取得
	        int appId = Integer.parseInt(req.getParameter("applicationId"));
	        int staffId = Integer.parseInt(req.getParameter("staffName"));
	        

	        // DAO から 1件分の Bean を取得
	        PaymentDAO dao = new PaymentDAO();
	        List<ReimbursementDetailBean> reimbursementApp = dao.fetchDetails();

	        // Excel作成
	        XSSFWorkbook workbook = new XSSFWorkbook();
	        Sheet sheet = workbook.createSheet("立替金申請");

	        // 書式準備
	        CellStyle rightAlign = workbook.createCellStyle();
	        rightAlign.setAlignment(HorizontalAlignment.RIGHT);

	        // 行番号管理
	        int rowNum = 0;
	        int blockCount = 1;

	        // 明細を1ブロックずつ出力
	        for (ReimbursementDetailBean d : reimbursementApp) {
	            Row titleRow = sheet.createRow(rowNum++);
	            titleRow.createCell(0).setCellValue("精算明細 " + (blockCount++));

	            Row r1 = sheet.createRow(rowNum++);
	            r1.createCell(0).setCellValue("PJコード");
	            r1.createCell(1).setCellValue(d.getProjectCode());

	            Row r2 = sheet.createRow(rowNum++);
	            r2.createCell(0).setCellValue("日付");
	            r2.createCell(1).setCellValue(d.getDate());

	            Row r3 = sheet.createRow(rowNum++);
	            r3.createCell(0).setCellValue("訪問先");
	            r3.createCell(1).setCellValue(d.getDestinations());

	            Row r4 = sheet.createRow(rowNum++);
	            r4.createCell(0).setCellValue("勘定科目");
	            r4.createCell(1).setCellValue(d.getAccountingItem());

	            Row r5 = sheet.createRow(rowNum++);
	            r5.createCell(0).setCellValue("金額");
	            Cell amountCell = r5.createCell(1);
	            amountCell.setCellValue(d.getAmount());
	            amountCell.setCellStyle(rightAlign);

	            if (d.getAbstractNote() != null && !d.getAbstractNote().isEmpty()) {
	                Row r6 = sheet.createRow(rowNum++);
	                r6.createCell(0).setCellValue("摘要");
	                r6.createCell(1).setCellValue(d.getAbstractNote());
	            }

	            if (d.getReport() != null && !d.getReport().isEmpty()) {
	                Row r7 = sheet.createRow(rowNum++);
	                r7.createCell(0).setCellValue("報告書");
	                r7.createCell(1).setCellValue(d.getReport());
	            }

	            if (d.getTemporaryFiles() != null && !d.getTemporaryFiles().isEmpty()) {
	                Row r8 = sheet.createRow(rowNum++);
	                r8.createCell(0).setCellValue("領収書ファイル");
	                String fileNames = d.getTemporaryFiles().stream()
	                        .map(f -> f.getOriginalFileName())
	                        .collect(Collectors.joining(", "));
	                r8.createCell(1).setCellValue(fileNames);
	            }

	            rowNum++;
	        }

	        // 総合計
	        Row totalRow = sheet.createRow(rowNum++);
	        totalRow.createCell(0).setCellValue("総合計金額");
	        Cell totalCell = totalRow.createCell(1);
	        totalCell.setCellValue(reimbursementApp.getAmount());
	        totalCell.setCellStyle(rightAlign);

	        // 列幅調整
	        sheet.autoSizeColumn(0);
	        sheet.autoSizeColumn(1);

	        // レスポンス出力
	        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	        String fileName = "立替金申請_" + staffId + ".xlsx";
	        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
	        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

	        workbook.write(resp.getOutputStream());
	        workbook.close();

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

	
	
	
	
	 
	}