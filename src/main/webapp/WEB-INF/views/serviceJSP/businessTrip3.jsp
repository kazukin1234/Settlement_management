<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>出張費申請 - 交通費明細</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/style.css">
<script
	src="${pageContext.request.contextPath}/static/js/businessTrip.js"></script>
<style>
.remove-btn {
	position: absolute;
	top: 1px;
	right: 1px;
	background: none;
	border: none;
	font-size: 1.2rem;
	color: #888;
	cursor: pointer;
}

.fileList a {
	color: #0056b3;
	text-decoration: underline;
	cursor: pointer;
}

.file-delete-btn {
	background: none;
	padding: 4px;
	color: red;
	border: none;
	border-radius: 4px;
	text-decoration: none;
	font-size: 1.2rem;
	cursor: pointer;
	transition: background 0.3s;
	height: 36.8px;
}

.file-delete-btn:hover {
	background: none;
	transform: scale(1.2);
	opacity: 0.8;
}
</style>
</head>
<body>
	<div class="page-container">
		<div class="content-container">
			<h2>交通費申請</h2>

			<form action="${pageContext.request.contextPath}/businessTripStep3"
				method="post" enctype="multipart/form-data">
				<input type="hidden" id="filesToDelete" name="filesToDelete"
					value="">
				<div style="display: flex; flex-direction: column; gap: 10px"
					id="trans-container">

					<c:forEach var="detail" items="${trip.step3Details}"
						varStatus="loop">
						<div class="form-section trans-block" style="position: relative;">
							<button type="button" class="remove-btn"
								onclick="removeTransBlock(this)">×</button>

							<%-- Thêm [] vào name và onchange để gọi hàm tính toán mới --%>
							<div class="form-group">
								<label>訪問先</label><input required type="text"
									name="transProject[]" value="${detail.transProject}"
									placeholder="例:株式会社AAA">
							</div>
							<div class="form-group">
								<label>出発</label><input required type="text" name="departure[]"
									value="${detail.departure}" placeholder="例:東京">
							</div>
							<div class="form-group">
								<label>到着</label><input required type="text" name="arrival[]"
									value="${detail.arrival}" placeholder="例:大阪">
							</div>
							<div class="form-group">
								<label>交通機関</label><select required name="transport[]"><option
										value="">選択してください</option>
									<option value="新幹線"
										${detail.transport == '新幹線' ? 'selected' : ''}>新幹線</option>
									<option value="電車"
										${detail.transport == '電車' ? 'selected' : ''}>電車</option>
									<option value="タクシー"
										${detail.transport == 'タクシー' ? 'selected' : ''}>タクシー</option>
									<option value="飛行機"
										${detail.transport == '飛行機' ? 'selected' : ''}>飛行機</option>
									<option value="自家用車"
										${detail.transport == '自家用車' ? 'selected' : ''}>自家用車</option>
									<option value="レンタカー"
										${detail.transport == 'レンタカー' ? 'selected' : ''}>レンタカー</option>
									<option value="他の"
										${detail.transport == '他の' ? 'selected' : ''}>他の</option></select>
							</div>
							<div class="form-group">
								<label>金額（税込）</label><input required type="number"
									name="fareAmount[]"
									oninput="updateTransBlockCalculations(this.closest('.trans-block'))"
									value="${detail.fareAmount}">
							</div>
							<div class="form-group">
								<label>区分</label><select required name="transTripType[]"
									onchange="updateTransBlockCalculations(this.closest('.trans-block'))"><option
										value="">選択してください</option>
									<option value="片道"
										${detail.transTripType == '片道' ? 'selected' : ''}>片道</option>
									<option value="往復"
										${detail.transTripType == '往復' ? 'selected' : ''}>往復</option></select>
							</div>
							<div class="form-group">
								<label>負担者</label><select required name="transBurden[]"
									onchange="updateTransBlockCalculations(this.closest('.trans-block'))"><option
										value="">選択してください</option>
									<option value="会社"
										${detail.transBurden == '会社' ? 'selected' : ''}>会社</option>
									<option value="自己"
										${detail.transBurden == '自己' ? 'selected' : ''}>自己</option></select>
							</div>
							<div class="form-group">
								<label>合計</label><input type="number" name="expenseTotal[]"
									readonly value="${detail.transExpenseTotal}">
							</div>
							<div class="form-group">
								<label>備考</label>
								<textarea  name="transMemo[]" placeholder="備考欄(何もなければスキップ)">${detail.transMemo}</textarea>
							</div>
							<div class="form-group">
								<label>領収書添付（交通費）</label> <input type="file"
									name="receipt_transport_${loop.index}" multiple
									class="fileInput" onchange="handleFileSelection(this)">

								<ul class="fileList">
									
									<c:forEach var="file" items="${detail.temporaryFiles}">
										<li data-file-type="existing"
											data-unique-name="${file.uniqueStoredName}"><a
											href="${pageContext.request.contextPath}/uploads/${file.uniqueStoredName}"
											target="_blank"> ${file.originalFileName} </a>
											<button type="button" class="file-delete-btn"
												onclick="deleteExistingFile(this)">×</button></li>
									</c:forEach>
								</ul>
							</div>
						</div>
					</c:forEach>
				</div>

				<div style="text-align: center; margin-top: 10px;">
					<button type="button" class="plus-btn" onclick="addTransBlock()">＋</button>
				</div>

				<%-- Sửa lại khối nút bấm để hỗ trợ "Save and Go Back" --%>
				<div class="btn-section">
					<button type="submit" name="action" value="go_back"
						class="back-btn" formnovalidate>戻る</button>
					<button type="submit" name="action" value="go_next"
						class="next-btn">確認</button>
				</div>
			</form>
		</div>
		</div>
		<div class="footer">&copy; 2025 ABC株式会社 - All rights reserved.</div>

		<script>
			// Gọi hàm khởi tạo cho Step 3 khi trang tải xong
			window.addEventListener('load', function() {
				initializeTransStep3();
			});
		</script>
</body>
</html>