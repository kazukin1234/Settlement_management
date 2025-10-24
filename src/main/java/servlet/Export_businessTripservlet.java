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
        
        // 書式
        CellStyle yenStyle = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        yenStyle.setDataFormat(format.getFormat("#,##0\"円\""));
        yenStyle.setAlignment(HorizontalAlignment.LEFT);

        
        // === Step1 ===
        Sheet s1 = workbook.createSheet("出張費申請");
        
        Step1Data step1 = tripBean.getStep1Data();
        Row header1=s1.createRow(0);
        int c=0;
        int row = 1;
        Row header2 = s1.createRow(row);
        
        header1.createCell(c++).setCellValue("社員ID");
        header2.createCell(0).setCellValue(bean.getStaffId());
        header1.createCell(c++).setCellValue("申請者名");
        header2.createCell(1).setCellValue(bean.getStaffName());
        
        header1.createCell(c++).setCellValue("基本情報");
        header1.createCell(c++).setCellValue("出張開始日");
        header1.createCell(c++).setCellValue("出張終了日");
        header1.createCell(c++).setCellValue("PJコード");
        header1.createCell(c++).setCellValue("出張報告");
        header2.createCell(2).setCellValue(step1.getStartDate());
        header2.createCell(3).setCellValue(step1.getEndDate());
        header2.createCell(4).setCellValue(step1.getProjectCode());
        header2.createCell(5).setCellValue(step1.getTripReport());
        
        
        // === Step2 ===
        //Sheet s2 = workbook.createSheet("Step2 宿泊・手当明細");
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
        
        
        List<Step2Detail> step2List = tripBean.getStep2Details();
        
        for (Step2Detail d : step2List) {
        	Row header21 = s1.createRow(row++);
        	
            header21.createCell(7).setCellValue(d.getRegionType());
            header21.createCell(8).setCellValue(d.getTripType());
            header21.createCell(9).setCellValue(d.getBurden());
            header21.createCell(10).setCellValue(d.getHotel());
            header21.createCell(11).setCellValue(d.getDailyAllowance());
            header21.createCell(12).setCellValue(d.getHotelFee());
            header21.createCell(13).setCellValue(d.getDays());
            header21.createCell(14).setCellValue(d.getExpenseTotal());
            header21.createCell(15).setCellValue(d.getMemo());
        }

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // === Step3 ===
        //Sheet s3 = workbook.createSheet("Step3 交通費明細");
        header1.createCell(c++).setCellValue("交通費明細");
        header1.createCell(c++).setCellValue("訪問先");//
        header1.createCell(c++).setCellValue("出発地");
        header1.createCell(c++).setCellValue("到着地");
        header1.createCell(c++).setCellValue("交通機関");
        header1.createCell(c++).setCellValue("金額");
        header1.createCell(c++).setCellValue("区分");
        header1.createCell(c++).setCellValue("負担者");
        //header1.createCell(c++).setCellValue("合計");
        header1.createCell(c++).setCellValue("備考");
        
        List<Step3Detail> step3List = tripBean.getStep3Details();
        int row1 = row;
        for (Step3Detail d : step3List) {
        	Row header22 = s1.createRow(row1++);
        	
        	header22.createCell(17).setCellValue(d.getDeparture());
            header22.createCell(18).setCellValue(d.getDeparture());
            header22.createCell(19).setCellValue(d.getArrival());
            header22.createCell(20).setCellValue(d.getTransport());
            header22.createCell(21).setCellValue(d.getTransExpenseTotal());
            header22.createCell(22).setCellValue(d.getTransTripType());
            header22.createCell(23).setCellValue(d.getTransBurden());
            header22.createCell(24).setCellValue(d.getTransMemo());
        }
        
    
     
        
        header1.createCell(c++).setCellValue("総合計金額");
        Row header_kingaku = s1.createRow(row1++);
        header_kingaku.createCell(25).setCellValue(tripBean.getTotalAmount());

        return workbook;
    }
}