package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
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

import bean.BusinessTripBean;
import bean.PaymentBean;
import bean.Step1Data;
import bean.Step2Detail;
import bean.Step3Detail;
import dao.BusinessTripApplicationDAO;
import dao.PaymentDAO;



/**
 * 出張費申請データをExcelまたはZIPとしてエクスポートするサーブレット。
 */
@WebServlet("/Export_businesstrip")
public class Export_businessTripservlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // DAOから出張費一覧を取得
            PaymentDAO dao = new PaymentDAO();
            List<PaymentBean> paymentList = dao.businesstripAll();
            req.setAttribute("paymentList2", paymentList);

            
         // モードを export に設定＿
            //String mode = "export";
            req.setAttribute("mode2", "exportbusinesstrip");

            req.setAttribute("showExportButton2", true);
           



            // JSP にフォワード
            req.getRequestDispatcher("/WEB-INF/views/serviceJSP/export_businesstrip.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    
    }
    
    
    

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            PaymentDAO paymentDao = new PaymentDAO();
            BusinessTripApplicationDAO tripDao = new BusinessTripApplicationDAO();

            String[] appIds = req.getParameterValues("applicationId");

            // === 複数選択 → ZIP出力 ===
            if (appIds != null && appIds.length > 1) {
                resp.setContentType("application/zip");
                String zipFileName = "出張費申請まとめ.zip";
                String encodedZip = URLEncoder.encode(zipFileName, StandardCharsets.UTF_8).replace("+", "%20");
                resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedZip);

                try (ZipOutputStream zos = new ZipOutputStream(resp.getOutputStream())) {
                    for (String idStr : appIds) {
                        int appId = Integer.parseInt(idStr);
                        PaymentBean bean = paymentDao.findById(appId);
                        BusinessTripBean tripBean = tripDao.loadBusinessTripByApplicationId(appId);

                        if (tripBean == null) continue;

                        XSSFWorkbook wb = createExcel(bean, tripBean);
                        String excelName = "出張費申請_" + appId + "_" + bean.getStaffName() + ".xlsx";

                        zos.putNextEntry(new ZipEntry(excelName));
                        wb.write(zos);
                        zos.closeEntry();
                        wb.close();
                    }
                }
                return;
            }

            // === 単体出力 ===
            int appId = Integer.parseInt(req.getParameter("applicationId"));
            PaymentBean bean = paymentDao.findById(appId);
            BusinessTripBean tripBean = tripDao.loadBusinessTripByApplicationId(appId);

            if (tripBean == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "該当する出張申請データが見つかりません。");
                return;
            }

            XSSFWorkbook workbook = createExcel(bean, tripBean);

            String fileName = "出張費申請_" + appId + "_" + bean.getStaffName() + ".xlsx";
            String encoded = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");

            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encoded);

            workbook.write(resp.getOutputStream());
            workbook.close();

        } catch (Exception e) {
            throw new ServletException("エクスポート処理中にエラーが発生しました", e);
        }
    }

    /**
     * 出張申請データをExcel形式で作成する。メソッド
     * beanのデータを入れるよ
     */
  private XSSFWorkbook createExcel(PaymentBean bean, BusinessTripBean tripBean) {

    XSSFWorkbook workbook = new XSSFWorkbook();
    Sheet s1 = workbook.createSheet("出張費申請");

    // === 書式設定 ===
    CellStyle yenStyle = workbook.createCellStyle();
    DataFormat format = workbook.createDataFormat();
    yenStyle.setDataFormat(format.getFormat("#,##0\"円\""));
    yenStyle.setAlignment(HorizontalAlignment.LEFT);

    int row = 0;
    int c = 0;

    // === Step1 ===
    Step1Data step1 = tripBean.getStep1Data();
    Row header1 = s1.createRow(row++);
    Row data1 = s1.createRow(row++);

    header1.createCell(c).setCellValue("社員ID");
    data1.createCell(c++).setCellValue(bean.getStaffId());

    header1.createCell(c).setCellValue("申請者名");
    data1.createCell(c++).setCellValue(bean.getStaffName());

    header1.createCell(c).setCellValue("出張開始日");
    data1.createCell(c++).setCellValue(step1.getStartDate());

    header1.createCell(c).setCellValue("出張終了日");
    data1.createCell(c++).setCellValue(step1.getEndDate());

    header1.createCell(c).setCellValue("PJコード");
    data1.createCell(c++).setCellValue(step1.getProjectCode());

    header1.createCell(c).setCellValue("出張報告");
    data1.createCell(c++).setCellValue(step1.getTripReport());

    // === Step2 ===
    List<Step2Detail> step2List = tripBean.getStep2Details();
    header1.createCell(c++).setCellValue("日当・宿泊費明細");
    header1.createCell(c++).setCellValue("地域区分");
    header1.createCell(c++).setCellValue("出張区分");
    header1.createCell(c++).setCellValue("負担者");
    header1.createCell(c++).setCellValue("宿泊先");
    header1.createCell(c++).setCellValue("日当");
    header1.createCell(c++).setCellValue("宿泊費");
    header1.createCell(c++).setCellValue("日数");
    header1.createCell(c++).setCellValue("合計");
    header1.createCell(c++).setCellValue("備考");

    int startStep2Col = 7; // Step2開始列
    int step2RowIndex = 1; // データ行
    for (Step2Detail d : step2List) {
        Row r = s1.getRow(step2RowIndex);
        if (r == null) r = s1.createRow(step2RowIndex);
        int col = startStep2Col;
        
        r.createCell(col++).setCellValue(d.getRegionType());
        r.createCell(col++).setCellValue(d.getTripType());
        r.createCell(col++).setCellValue(d.getBurden());
        r.createCell(col++).setCellValue(d.getHotel());
        Cell cell1 = r.createCell(col++);
        cell1.setCellValue(d.getDailyAllowance());
        cell1.setCellStyle(yenStyle);

        Cell cell2 = r.createCell(col++);
        cell2.setCellValue(d.getHotelFee());
        cell2.setCellStyle(yenStyle);

        r.createCell(col++).setCellValue(d.getDays());
        
        Cell cell3 = r.createCell(col++);
        cell3.setCellValue(d.getExpenseTotal());
        cell3.setCellStyle(yenStyle);
        r.createCell(col++).setCellValue(d.getMemo());
        step2RowIndex++;
    }

    // === Step3 ===
    List<Step3Detail> step3List = tripBean.getStep3Details();

    int startStep3Col = 16; // Step3開始列（横方向）
    int step3RowIndex = 1;
    header1.createCell(startStep3Col).setCellValue("交通費明細");
    header1.createCell(startStep3Col+ 1).setCellValue("訪問先");
    header1.createCell(startStep3Col + 2).setCellValue("出発地");
    header1.createCell(startStep3Col + 3).setCellValue("到着地");
    header1.createCell(startStep3Col + 4).setCellValue("交通機関");
    header1.createCell(startStep3Col + 5).setCellValue("金額");
    header1.createCell(startStep3Col + 6).setCellValue("区分");
    header1.createCell(startStep3Col + 7).setCellValue("負担者");
    header1.createCell(startStep3Col + 8).setCellValue("備考");

    
    for (Step3Detail d : step3List) {
        Row r = s1.getRow(step3RowIndex);
        if (r == null) r = s1.createRow(step3RowIndex);
        int col = 17;
        
        r.createCell(col++).setCellValue(d.getTransProject());
        r.createCell(col++).setCellValue(d.getDeparture());
        r.createCell(col++).setCellValue(d.getArrival());
        r.createCell(col++).setCellValue(d.getTransport());
        
        Cell cell4 = r.createCell(col++);
        cell4.setCellValue(d.getTransExpenseTotal());
        cell4.setCellStyle(yenStyle);

        r.createCell(col++).setCellValue(d.getTransTripType());
        r.createCell(col++).setCellValue(d.getTransBurden());
        r.createCell(col++).setCellValue(d.getTransMemo());
        step3RowIndex++;
    }

    // === 総合計 ===
    int totalCol = startStep3Col + 8;
    Row totalRow = s1.createRow(step3RowIndex);
    header1.createCell(startStep3Col + 9).setCellValue("総合計金額");
    
    Cell cell5 = totalRow.createCell(totalCol + 1);
    cell5.setCellValue(tripBean.getTotalAmount());
    cell5.setCellStyle(yenStyle);
    
    // 自動列幅調整
    for (int i = 0; i <= 13; i++) {
        s1.autoSizeColumn(i);
    }

    
    
    return workbook;
}
}