<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
.btn-like-back {
    background: var(--primary-color);
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
    transition: background 0.2s;
    max-width: 100px;
    height:36.8px;
}
</style>
<div class="btn-section">

    <%-- Nút 1: Quay lại --%>
    <c:if test="${showBackButton}">
        <a href="${pageContext.request.contextPath}${backActionUrl}" class="back-btn">戻る</a>
    </c:if>

    <%-- Nút 2: Sửa (Chỉ hiển thị cho nhân viên) --%>
    <c:if test="${showEditButton}">
        <form action="${pageContext.request.contextPath}/editApplication" method="get" style="display:inline;">
            <input type="hidden" name="id" value="${applicationId}">
            <button type="submit" class="edit-btn">編集</button>
        </form>
    </c:if>

    <%-- Nút 3: Gửi / Cập nhật (Ở trang xác nhận) --%>
    <c:if test="${showSubmitButton}">
        <form action="${pageContext.request.contextPath}${submitActionUrl}" method="post" style="display:inline;">
            <button type="submit" class="approve-btn">${isEditMode ? '更新' : '送信'}</button>
        </form>
    </c:if>

    <%-- Nút 4 & 5: Các nút cho Người duyệt --%>
    <c:if test="${showApprovalActionButtons}">
        <%-- Form cho nút "Trả về" (Reject) --%>
        <form action="${pageContext.request.contextPath}/approverApplications" method="post" style="display:inline;">
            <input type="hidden" name="action" value="reject">
            <input type="hidden" name="appIds" value="${applicationId}">
<!--            <button type="submit" class="reject-btn" onclick="return confirm('この申請を差戻します。よろしいですか？')">差戻し</button>-->
        </form>
        <%-- Form cho nút "Duyệt" (Approve) --%>
        <form action="${pageContext.request.contextPath}/approverApplications" method="post" style="display:inline;">
            <input type="hidden" name="action" value="approval">
            <input type="hidden" name="appIds" value="${applicationId}">
            <button type="submit" class="approve-btn2" onclick="return confirm('この申請を承認します。よろしいですか？')">承認</button>
        </form>
    </c:if>

    <%-- Nút 6: Thanh toán (Chỉ hiển thị khi quản lý xem chi tiết) --%>
    <c:if test="${showPaymentActionButton}">
        <form action="${pageContext.request.contextPath}/payment" method="post" style="display:inline;">
            <%-- Sửa lại lỗi cú pháp và đảm bảo gửi đúng ID --%>
            <input type="hidden" name="appIds" value="${applicationId}">
            <button type="submit" class="approve-btn" 
                    onclick="return confirm('この申請を支払済みにします。よろしいですか？')">支払済</button>
        </form>
    </c:if>
    
    
    <c:if test="${showExportButton}">
    <form action="${pageContext.request.contextPath}/Export_reimbursement" method="post" style="display:inline;">
        <input type="hidden" name="applicationId" value="${applicationId}"/>
         <input type="hidden" name="staffName" value="${p.staffName}" />
        <button type="submit" class="approve-btn" onclick="return confirm('excelファイルで出力します。よろしいですか？')">エクスポート(.xlsx)</button>
    </form>
</c:if>
    

</div>
<div class="footer">
  &copy; 2025 - All rights reserved.
</div>