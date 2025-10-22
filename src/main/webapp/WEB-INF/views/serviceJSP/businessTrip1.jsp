<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>出張費申請 - Step 1</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/style.css">
<script
	src="${pageContext.request.contextPath}/static/js/businessTrip.js"></script>
</head>
<body>
	<div class="page-container">
		<div class="content-container">
			<h2>出張情報</h2>

			<form action="${pageContext.request.contextPath}/businessTripStep1"
				method="post">



				<div class="form-section">
					<div class="form-group">
						<label>出張期間</label>
						<div style="display: flex; gap: 1rem;">
							<input type="date" name="startDate" id="startDate"
								value="${trip.step1Data.startDate}" required> <span>～</span>
							<input type="date" name="endDate" id="endDate"
								value="${trip.step1Data.endDate}" required>
						</div>
					</div>

					<div class="form-group">
						<label>PJコード</label> <select name="projectCode">
							<option value="">選択してください</option>
							<c:forEach var="p" items="${projectList}">
								<option value="${p.id}"
									${p.id == trip.step1Data.projectCode ? 'selected' : ''}>
									${p.id}：${p.name}</option>
							</c:forEach>
						</select>
					</div>

					<div class="form-group">
						<label>出張報告</label>
						<textarea required name="tripReport" class="hokoku-text"
							placeholder="業務内容や目的を入力してください">${trip.step1Data.tripReport}</textarea>
					</div>
				</div>

				<div class="btn-section">
					<button type="button"
						onclick="window.location.href='${pageContext.request.contextPath}/home'">戻る</button>
					<button type="submit">次へ</button>
				</div>
			</form>
		</div>
	</div>
	<div class="footer">&copy; 2025  - All rights reserved.</div>
	<script>
		window.addEventListener('load', function() {
			// Có thể gọi hàm initializeTransBlock nếu bạn có logic khởi tạo cho Step 3
			// initializeTransBlock(); 
		});
	</script>
</body>
</html>