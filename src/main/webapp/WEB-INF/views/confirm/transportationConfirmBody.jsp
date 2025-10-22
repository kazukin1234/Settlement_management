<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


<%-- 
  File này hiển thị nội dung chi tiết của đơn "Chi phí đi lại" (交通費)
  theo cấu trúc hiển thị riêng cho từng block.
--%>

<style>
/* Style chung cho trang confirm */
.confirm-table {
	width: 100%;
	border-collapse: collapse;
}

.confirm-table th, .confirm-table td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: left;
	vertical-align: top;
}

.confirm-table th {
	background-color: #f8f9fa;
	font-weight: bold;
	width: 150px;
}

/* Style cho mỗi block riêng biệt */
.confirm-section {
	margin-bottom: 20px;
	padding: 20px;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	background-color: #fff;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.confirm-section h3 {
	margin-top: 0;
	padding-bottom: 10px;
	border-bottom: 2px solid var(--primary-color);
	font-size: 1.2em;
	color: var(--primary-color);
}

/* Style cho phần ghi chú và file */
.detail-extra-info {
	margin-top: 15px;
}

.memo-block {
	padding: 10px;
	background-color: #f9f9f9;
	border-radius: 4px;
	white-space: pre-wrap;
	margin-top: 5px;
}

.receipt-list {
	list-style-type: none;
	padding-left: 0;
	margin-top: 5px;
}

.receipt-list li {
	display: flex;
	align-items: center;
	margin-bottom: 5px;
}

.receipt-list li::before {
	content: '📎';
	margin-right: 8px;
	font-size: 1.2em;
}

.confirm-page-total {
	margin-top: 20px;
	text-align: right;
	background-color: #e9f5ff;
	padding: 12px 18px;
	font-weight: bold;
	font-size: 1.25em;
	border-radius: 5px;
}
</style>

<div class="page-container"
	style="display: flex; flex-direction: column; gap: 15px;">
	<div class="content-container">

		<c:forEach var="detail" items="${transportationApp.details}"
			varStatus="loop">

			<div class="confirm-section">
				<h3>精算明細 ${loop.count}</h3>

				<table class="confirm-table">
					<tr>
						<th>PJコード</th>
						<td>${detail.projectCode}</td>
					</tr>
					<tr>
						<th>訪問月・日</th>
						<td>${detail.date}</td>
					</tr>
					<tr>
						<th>訪問先</th>
						<td>${detail.destination}</td>
					</tr>
					<tr>
						<th>出発</th>
						<td>${detail.departure}</td>
					</tr>
					<tr>
						<th>到着</th>
						<td>${detail.arrival}</td>
					</tr>
					<tr>
						<th>交通機関</th>
						<td>${detail.transport}</td>
					</tr>
					<tr>
						<th>金額（税込）</th>
						<td><fmt:formatNumber value="${detail.fareAmount}"
								type="number" />円</td>
					</tr>
					<tr>
						<th>区分</th>
						<td>${detail.transTripType}</td>
					</tr>
					<tr>
						<th>負担者</th>
						<td>${detail.burden}</td>
					</tr>
					<tr>
						<th>合計</th>
						<td><fmt:formatNumber value="${detail.expenseTotal}"
								type="number" />円</td>
					</tr>
				</table>
				<div class="detail-extra-info">

					<c:if test="${not empty detail.transMemo}">
						<div>
							<strong>摘要(内容や目的):</strong>
						</div>
						<div class="memo-block">${detail.transMemo}</div>
					</c:if>

					<c:if
						test="${not empty detail.report and fn:trim(detail.report) ne ''}">
						<div>
							<strong>備考:</strong>
						</div>
						<div class="memo-block">${detail.report}</div>
					</c:if>
					
					<c:if test="${not empty detail.temporaryFiles}">
						<div style="margin-top: 10px;">
							<strong>領収書ファイル:</strong>
						</div>
						<ul class="receipt-list">
							<c:forEach var="file" items="${detail.temporaryFiles}">
								<li><a
									href="${pageContext.request.contextPath}${file.temporaryPath}"
									target="_blank"> ${file.originalFileName} </a></li>
							</c:forEach>
						</ul>
					</c:if>
				</div>
			</div>
		</c:forEach>
		
		<div class="confirm-page-total">
			総合計金額:
			<fmt:formatNumber value="${transportationApp.totalAmount}"
				type="number" />
			円
		</div>
	</div>
</div>


