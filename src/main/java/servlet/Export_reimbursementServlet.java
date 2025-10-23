package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

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

	     
	     // モードを export に設定＿
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
        PaymentDAO dao = new PaymentDAO();

        // 複数選択された場合
        String[] appIds = req.getParameterValues("applicationId");
        if (appIds != null && appIds.length > 1) {
            // ZIP出力
            resp.setContentType("application/zip");
            String zipFileName = "立替金申請まとめ.zip";
            String encoded = URLEncoder.encode(zipFileName, StandardCharsets.UTF_8).replace("+", "%20");
            resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

            try (ZipOutputStream zos = new ZipOutputStream(resp.getOutputStream())) {
                for (String appIdStr : appIds) {
                    int appId = Integer.parseInt(appIdStr);
                    PaymentBean targetBean = dao.findById(appId);
                    List<ReimbursementDetailBean> details = dao.fetchDetails(appId);

                    // Excel作成
                    XSSFWorkbook workbook = createExcel(targetBean, details);

                    // ZIPエントリ追加
                    String excelFileName = "立替金申請_" + appId + "_" + targetBean.getStaffName() + ".xlsx";
                    zos.putNextEntry(new ZipEntry(excelFileName));
                    workbook.write(zos);
                    zos.closeEntry();
                    workbook.close();
                }
            }
            return; // ZIP出力完了 → 処理終了
        }

        // 1件のみの場合（既存処理）
        int applicationId = Integer.parseInt(req.getParameter("applicationId"));
        PaymentBean targetBean = dao.findById(applicationId);
        List<ReimbursementDetailBean> details = dao.fetchDetails(applicationId);

        XSSFWorkbook workbook = createExcel(targetBean, details);

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        String fileName = "立替金申請_" + applicationId + "_" + targetBean.getStaffName() + ".xlsx";
        String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

        workbook.write(resp.getOutputStream());
        workbook.close();

    } catch (Exception e) {
        throw new ServletException(e);
    }
}

/**
 * 共通Excel作成メソッド
 */
private XSSFWorkbook createExcel(PaymentBean targetBean, List<ReimbursementDetailBean> details) {
    XSSFWorkbook workbook = new XSSFWorkbook();
    Sheet sheet = workbook.createSheet("立替金申請");

    // 書式
    CellStyle yenStyle = workbook.createCellStyle();
    DataFormat format = workbook.createDataFormat();
    yenStyle.setDataFormat(format.getFormat("#,##0\"円\""));
    yenStyle.setAlignment(HorizontalAlignment.LEFT);

    // ヘッダー行
    Row headerRow = sheet.createRow(0);
    headerRow.createCell(0).setCellValue("社員ID");
    headerRow.createCell(1).setCellValue("申請者名");
    headerRow.createCell(2).setCellValue("PJコード");
    headerRow.createCell(3).setCellValue("日付");
    headerRow.createCell(4).setCellValue("支払先");
    headerRow.createCell(5).setCellValue("勘定科目");
    headerRow.createCell(6).setCellValue("金額");
    headerRow.createCell(7).setCellValue("摘要");
    headerRow.createCell(8).setCellValue("備考"); //
    //headerRow.createCell(9).setCellValue("ファイル名");
    headerRow.createCell(9).setCellValue("総合計金額");

    int rowNum = 1;
    for (ReimbursementDetailBean d : details) {
        Row dataRow = sheet.createRow(rowNum++);
        dataRow.createCell(0).setCellValue(targetBean.getStaffId());
        dataRow.createCell(1).setCellValue(targetBean.getStaffName());
        dataRow.createCell(2).setCellValue(d.getProjectCode());
        dataRow.createCell(3).setCellValue(d.getDate());
        dataRow.createCell(4).setCellValue(d.getDestinations());
        dataRow.createCell(5).setCellValue(d.getAccountingItem());

        // 金額
        Cell amountCell = dataRow.createCell(6);
        amountCell.setCellValue(d.getAmount());
        amountCell.setCellStyle(yenStyle);

        // 摘要
        if (d.getAbstractNote() != null) {
            dataRow.createCell(7).setCellValue(d.getAbstractNote());
        }

        // 🔹 報告(備考)をExcelに追加
        if (d.getReport() != null) {
            dataRow.createCell(8).setCellValue(d.getReport());
        }

        // 添付ファイル(出力はされない)
        if (d.getTemporaryFiles() != null && !d.getTemporaryFiles().isEmpty()) {
            String fileNames = d.getTemporaryFiles().stream()
                .map(f -> f.getOriginalFileName())
                .collect(Collectors.joining(", "));
            dataRow.createCell(9).setCellValue(fileNames);
        }
    }

    // 合計行
    int totalAmount = details.stream().mapToInt(ReimbursementDetailBean::getAmount).sum();
    Row totalRow = sheet.createRow(rowNum);
    Cell totalAmountCell = totalRow.createCell(9);
    totalAmountCell.setCellValue(totalAmount);
    totalAmountCell.setCellStyle(yenStyle);

    // 自動列幅調整
    for (int i = 0; i <= 10; i++) {
        sheet.autoSizeColumn(i);
    }

    return workbook;
}



}