<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%-- 
  File này hiển thị nội dung chi tiết của đơn "Lập替金" (Reimbursement)
  theo cấu trúc hiển thị mới, tách bạch cho từng block.
--%>

<%-- Sử dụng chung bộ style với các trang confirm khác để giao diện nhất quán --%>
<style>
  .confirm-table { width: 100%; border-collapse: collapse; }
  .confirm-table th, .confirm-table td { border: 1px solid #ddd; padding: 10px; text-align: left; vertical-align: middle; }
  .confirm-table th { background-color: #f8f9fa; font-weight: bold; width: 120px; }
  
  .confirm-section { 
    margin-bottom: 20px; 
    padding: 20px; 
    border: 1px solid #e0e0e0; 
    border-radius: 8px; 
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
  }
  .confirm-section h3 { 
    margin-top: 0; 
    padding-bottom: 10px;
    border-bottom: 2px solid var(--primary-color); 
    font-size: 1.2em;
    color: var(--primary-color);
  }
  
  .detail-extra-info { margin-top: 15px; }
  .memo-block { padding: 10px; background-color: #f9f9f9; border-radius: 4px; white-space: pre-wrap; margin-top: 5px; }
  
  .receipt-list { list-style-type: none; padding-left: 0; margin-top: 5px; }
  .receipt-list li { display: flex; align-items: center; margin-bottom: 5px; }
  .receipt-list li::before { content: '📎'; margin-right: 8px; font-size: 1.2em; }
  
  .confirm-page-total { 
    margin-top: 20px; text-align: right; background-color: #e9f5ff; 
    padding: 12px 18px; font-weight: bold; font-size: 1.25em; border-radius: 5px;
  }
</style>

<div class="page-container" style="display: flex; flex-direction: column; gap: 15px;">

  <%-- Bắt đầu vòng lặp qua từng chi tiết của đơn Reimbursement --%>
  <c:forEach var="detail" items="${reimbursementApp.details}" varStatus="loop">
    
    <%-- Khung riêng cho mỗi block --%>
    <div class="confirm-section">
      <h3>精算明細 ${loop.count}</h3> <%-- Tiêu đề: Chi tiết thanh toán 1, 2... --%>

      <%-- 1. Bảng chứa thông tin chính của block --%>
      <table class="confirm-table">
        <tr>
            <th>PJコード</th>
            <td>${detail.projectCode}</td>
        </tr>
        <tr>
            <th>日付</th>
            <td>${detail.date}</td>
        </tr>
        <tr>
            <th>支払先</th>
            <td>${detail.destinations}</td>
        </tr>
        <tr>
            <th>勘定科目</th>
            <td>${detail.accountingItem}</td>
        </tr>
         <tr>
            <th>金額</th>
            <td colspan="3"><fmt:formatNumber value="${detail.amount}" type="number" />円</td>
        </tr>
      </table>

      <%-- Khu vực chứa ghi chú và file của riêng block này --%>
      <div class="detail-extra-info">
        
        <%-- 2. Hiển thị ghi chú (摘要) nếu có --%>
        <c:if test="${not empty detail.abstractNote}">
					<div>
						<strong>摘要(内容や目的):</strong>
					</div>
					<div class="memo-block">${detail.abstractNote}</div>
		</c:if>
        <c:if test="${not empty detail.report}">
          <div><strong>備考:</strong></div>
          <div class="memo-block">${detail.report}</div>
        </c:if>
       

        <%-- 3. Hiển thị file đính kèm nếu có --%>
        <c:if test="${not empty detail.temporaryFiles}">
          <div style="margin-top: 10px;"><strong>領収書ファイル:</strong></div>
          <ul class="receipt-list">
            <c:forEach var="file" items="${detail.temporaryFiles}">
              <li>
                <a href="${pageContext.request.contextPath}${file.temporaryPath}" target="_blank">
                  ${file.originalFileName}
                </a>
              </li>
            </c:forEach>
          </ul>
        </c:if>
      </div>
    </div> <%-- Kết thúc khung của một block --%>

  </c:forEach>
  
  <%-- Tổng số tiền của toàn bộ đơn --%>
  <div class="confirm-page-total">
    総合計金額: <fmt:formatNumber value="${reimbursementApp.totalAmount}" type="number" /> 円
  </div>

</div>