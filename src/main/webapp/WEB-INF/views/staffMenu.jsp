
<%@ page contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty sessionScope.staffName}">
	<c:redirect url="/LoginServlet" />
</c:if>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>スタッフダッシュボード - ABC株式会社システム</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
<script src="${pageContext.request.contextPath}/static/js/script.js"></script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />

	<div class="page-container">
		<div class="content-container menu_style">
			<p style="text-align: right;">ようこそ、${sessionScope.staffName} さん！</p>
			<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
			<div class="staff-main-content">
				<div class="panel">
					<h4>申請する</h4>
					<div class="btn-section">
						<a href="${pageContext.request.contextPath}/transportationInit">交通費申請</a>
						<a href="${pageContext.request.contextPath}/businessTripInit">出張費申請</a>
						<a href="${pageContext.request.contextPath}/reimbursementInit">立替金申請</a>
					</div>
				</div>

				<div class="panel">
					<h4>申請状況</h4>
					<ul>
						<li><a
							href="${pageContext.request.contextPath}/applicationMain?status=not_submitted">未提出:${countMiteishutsu}
								件</a></li>
						<li><a
							href="${pageContext.request.contextPath}/applicationMain?status=submitted">提出済:${countTeishutsu}
								件</a></li>
						<li><a
							href="${pageContext.request.contextPath}/applicationMain?status=rejected">差戻:${countSashimodoshi}
								件</a></li>
					</ul>
					<div class="status-box"></div>
				</div>
			</div>
		</div>
	</div>

	<div class="footer">&copy; 2025 株式会社khronos - All rights reserved.</div>
</body>
</html>