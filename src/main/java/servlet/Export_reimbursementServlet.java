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
import org.apache.poi.ss.usermodel.DataFormat;
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
	       
	    	String[] appIds = req.getParameterValues("appIds");
	        
	    	
	        // DAO から 1件分の Bean を取得
	        PaymentDAO dao = new PaymentDAO();
	        
	        
	        int applicationId = Integer.parseInt(req.getParameter("applicationId"));
	        List<ReimbursementDetailBean> details = dao.fetchDetails(applicationId);

	     // 該当申請の PaymentBean を取得
	        PaymentBean targetBean = dao.findById(applicationId);

	        // staffName を取り出す
	        String staffName = (targetBean != null && targetBean.getStaffName() != null) 
	                             ? targetBean.getStaffName() 
	                             : "不明社員";
	        
	        
	        // Excel作成
	        XSSFWorkbook workbook = new XSSFWorkbook();
	        Sheet sheet = workbook.createSheet("立替金申請");

	        // 書式準備
	        CellStyle leftAlign = workbook.createCellStyle();
	        leftAlign.setAlignment(HorizontalAlignment.LEFT);

	        // DAOから立替金一覧を取得
	        PaymentDAO dao2 = new PaymentDAO();
	        List<PaymentBean> paymentList = dao2.reimbursementAll();
	        
	        
	        // 「円」付きの表示形式を定義
	        CellStyle yenStyle = workbook.createCellStyle();
	        DataFormat format = workbook.createDataFormat();
	        yenStyle.setDataFormat(format.getFormat("#,##0\"円\""));
	        yenStyle.setAlignment(HorizontalAlignment.LEFT);
	        
	        
	     // ヘッダー行作成
	        Row headerRow = sheet.createRow(0);
	        headerRow.createCell(0).setCellValue("社員ID");
	        headerRow.createCell(1).setCellValue("申請者名");
	        headerRow.createCell(2).setCellValue("PJコード");
	        headerRow.createCell(3).setCellValue("日付");
	        headerRow.createCell(4).setCellValue("訪問先");
	        headerRow.createCell(5).setCellValue("勘定科目");
	        headerRow.createCell(6).setCellValue("金額");
	        headerRow.createCell(7).setCellValue("摘要");
	       
	        // データ行開始位置
	        int rowNum = 1;
	        
	        
	        // 申請ごとにループ
	        for (ReimbursementDetailBean d : details) {
	            Row dataRow = sheet.createRow(rowNum++);

	            // 左端に社員情報を固定的に出力
	            dataRow.createCell(0).setCellValue(targetBean.getStaffId());
	            dataRow.createCell(1).setCellValue(targetBean.getStaffName());

	            // 明細を横に展開
	            dataRow.createCell(2).setCellValue(d.getProjectCode());
	            dataRow.createCell(3).setCellValue(d.getDate());
	            dataRow.createCell(4).setCellValue(d.getDestinations());
	            dataRow.createCell(5).setCellValue(d.getAccountingItem());

	            Cell amountCell = dataRow.createCell(6);
	            amountCell.setCellValue(d.getAmount());
	            amountCell.setCellStyle(yenStyle);

	            if (d.getAbstractNote() != null && !d.getAbstractNote().isEmpty()) {
	                dataRow.createCell(7).setCellValue(d.getAbstractNote());
	            }

	            if (d.getTemporaryFiles() != null && !d.getTemporaryFiles().isEmpty()) {
	                String fileNames = d.getTemporaryFiles().stream()
	                        .map(f -> f.getOriginalFileName())
	                        .collect(Collectors.joining(", "));
	                dataRow.createCell(8).setCellValue(fileNames);
	            }
	        }
	        int totalAmount1 = details.stream()
	        	    .mapToInt(ReimbursementDetailBean::getAmount)
	        	    .sum();
	        
	     // 総合計行を追加
	        Row totalRow = sheet.createRow(rowNum++);
	        totalRow.createCell(0).setCellValue("総合計金額");
	        totalRow.createCell(1).setCellValue(targetBean.getStaffName());
	        
	    

	        Cell totalAmountCell = totalRow.createCell(6);
	        totalAmountCell.setCellValue(totalAmount1);
	        totalAmountCell.setCellStyle(yenStyle);

	        // 列幅自動調整
	        for (int i = 0; i <= 8; i++) {
	            sheet.autoSizeColumn(i);
	        }

	        
	        
	        // 列幅調整
	        sheet.autoSizeColumn(0);
	        sheet.autoSizeColumn(1);

	        
	        
	        // レスポンス出力
	        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	        String fileName = "立替金申請_申請ID:" +applicationId +"_"+staffName + ".xlsx";
	        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
	        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

	        workbook.write(resp.getOutputStream());
	        workbook.close();

	    } catch (Exception e) {
	        throw new ServletException(e);
	    }
	}

	
	
	
	
	 
	}