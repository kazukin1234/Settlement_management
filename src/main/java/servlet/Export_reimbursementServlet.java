package servlet;

import java.io.File;
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
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

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
	        		    //エクセルファイルへアクセスするためのオブジェクト
	        		    Workbook excel = WorkbookFactory.create(new File("Sample.xlsx"));

	        		    // シート名がわかっている場合
	        		    Sheet sheet = excel.getSheet("Sheet1");

	        		    //0行目
	        		    Row row = sheet.getRow(0);

	        		    //0番目のセル
	        		    Cell cell = row.getCell(0);

	        		    //文字列の取得
	        		    String value = cell.getStringCellValue();

	        		    //取得した文字列の表示
	        		    System.out.println(value);
	        		  

	        } catch (Exception e) {
	            throw new ServletException(e);
	        }
	    }
	 
	 
	 
	 
	}
	
	
	
	
	
	

	