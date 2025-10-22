<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>出張費申請 - 日当・宿泊費明細</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/static/css/style.css">
<script
	src="${pageContext.request.contextPath}/static/js/businessTrip.js"></script>
<style>
/* --- CSS GỐC CỦA BẠN - ĐƯỢC GIỮ NGUYÊN --- */
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

/* --- CSS MỚI - CHỈ DÀNH CHO KHỐI 日当の調整 --- */
.adjustment-group {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 13px;
    background-color: #f9f9f9;
   	display: block;
    margin-bottom: 5px;
}

.adjustment-group legend {
	font-weight:600;
    color: #333;
    padding: 0 8px;
    font-size: 12px;
    margin-left: 8px; /* Thêm để legend không bị dính vào viền */
}

.option-item {
    display: flex;
    align-items: center;
    padding: 3px;
    border-radius: 6px;
    cursor: pointer;
    transition: background-color 0.2s ease-in-out;
    position: relative;
    
}

.option-item:hover {
    background-color: #f0f0f0;
}

.option-item .nitto-option {
    opacity: 0;
    width: 0;
    height: 0;
    position: absolute;
}

.option-item .custom-checkbox {
    width: 15px;
    height: 15px;
    border: 2px solid #aaa;
    border-radius: 4px;
    display: inline-block;
    margin-right: 12px;
    transition: all 0.2s ease-in-out;
    flex-shrink: 0;
}

.option-item .option-label {
    color: #444;
    font-size:10px;
    font-weight:500;
}

.option-item .nitto-option:checked + .custom-checkbox {
    background-color: #007bff;
    border-color: #007bff;
}

.option-item .custom-checkbox::after {
    content: '';
    display: block;
    width: 5px;
    height: 5px;
    border: solid white;
    border-width: 0 3px 3px 0;
    transform: rotate(45deg);
    position: relative;
    left: 6px;
    top: 2px;
    opacity: 0;
    transition: opacity 0.1s ease-in-out;
}

.option-item .nitto-option:checked + .custom-checkbox::after {
    opacity: 1;
}

.option-item .nitto-option:disabled + .custom-checkbox {
    background-color: #e9ecef;
    border-color: #ced4da;
    cursor: not-allowed;
}

.option-item .nitto-option:disabled ~ .option-label {
    color: #999;
    cursor: not-allowed;
}

.option-item:has(.nitto-option:disabled):hover {
    background-color: transparent;
}
</style>
</head>
<body>
	<div class="page-container">
		<div class="content-container">
			<h2>日当・宿泊費申請</h2>
			<form action="${pageContext.request.contextPath}/businessTripStep2"
				method="post" enctype="multipart/form-data">
				<input type="hidden" id="filesToDelete" name="filesToDelete"
					value="">
				<div style="display: flex; flex-direction: column; gap: 10px"
					id="allowance-container">
					<c:forEach var="detail" items="${trip.step2Details}"
						varStatus="loop">
						<div class="form-section allowance-block"
							style="position: relative;">
							<button type="button" class="remove-btn"
								onclick="removeAllowanceBlock(this)">×</button>
							<div class="form-group">
								<label>宿泊先</label><input required type="text" name="hotel[]"
									placeholder="例:APAホテル" value="${detail.hotel}">
							</div>
							<div class="form-group">
								<label >地域区分</label><select required name="regionType[]"
									onchange="calculateHotelFee(this)"><option value="">選択してください</option>
									<option value="東京"
										${detail.regionType == '東京' ? 'selected' : ''}>東京</option>
									<option value="東京以外"
										${detail.regionType == '東京以外' ? 'selected' : ''}>東京以外</option>
									<option value="会社施設・縁故先宿泊"
										${detail.regionType == '会社施設・縁故先宿泊' ? 'selected' : ''}>会社施設・縁故先宿泊</option></select>
							</div>
							<div class="form-group">
								<label>出張区分</label><select name="tripType[]" required
									onchange="calculateHotelFee(this)"><option value="">選択してください</option>
									<option value="短期出張"
										${detail.tripType == '短期出張' ? 'selected' : ''}>短期出張</option>
									<option value="長期出張"
										${detail.tripType == '長期出張' ? 'selected' : ''}>長期出張</option>
									<option value="研修出張"
										${detail.tripType == '研修出張' ? 'selected' : ''}>研修出張</option></select>
							</div>
							<div class="form-group">
								<label>負担者</label><select required name="burden[]"
									onchange="calculateHotelFee(this)"><option value="">選択してください</option>
									<option value="会社" ${detail.burden == '会社' ? 'selected' : ''}>会社</option>
									<option value="自己" ${detail.burden == '自己' ? 'selected' : ''}>自己</option></select>
							</div>
							<div class="form-group">
								<label>宿泊費</label><input required type="number"
									name="hotelFee[]" readonly value="${detail.hotelFee}">
							</div>
							
						<fieldset class="adjustment-group">
						    <legend>日当の調整</legend>
						
						    <%-- Option 1: Nửa ngày --%>
						    <label for="option_half_day_${loop.index}" class="option-item">
						        <input type="checkbox" 
						               id="option_half_day_${loop.index}" 
						               name="adjustmentOptions[${loop.index}]" 
						               value="half_day" 
						               class="nitto-option" 
						               data-option="half_day"
						               ${detail.adjustmentOptions.contains('half_day') ? 'checked' : ''}
						               onchange="handleAdjustmentChange(this)">
						        <span class="custom-checkbox"></span>
						        <span class="option-label">午後の出発・午前の到着 (日当 1/2)</span>
						    </label>
						
						    <%-- Option 2: Bonus --%>
						    <label for="option_bonus_${loop.index}" class="option-item">
						        <input type="checkbox" 
						               id="option_bonus_${loop.index}" 
						               name="adjustmentOptions[${loop.index}]" 
						               value="bonus" 
						               class="nitto-option" 
						               data-option="bonus"
						               ${detail.adjustmentOptions.contains('bonus') ? 'checked' : ''}
						               onchange="handleAdjustmentChange(this)">
						        <span class="custom-checkbox"></span>
						        <span class="option-label">午前6時前出発・午後9時以降到着 (+1,500円)</span>
						    </label>
						
						    <%-- Option 3: Không có phụ cấp --%>
						    <label for="option_none_${loop.index}" class="option-item">
						        <input type="checkbox" 
						               id="option_none_${loop.index}" 
						               name="adjustmentOptions[${loop.index}]" 
						               value="none" 
						               class="nitto-option" 
						               data-option="none"
						               ${detail.adjustmentOptions.contains('none') ? 'checked' : ''}
						               onchange="handleAdjustmentChange(this)">
						        <span class="custom-checkbox"></span>
						        <span class="option-label">業務活動なし (日当なし)</span>
						    </label>
						</fieldset>
							<div class="form-group">
								<label>日当</label><input required type="number"
									name="dailyAllowance[]" readonly
									value="${detail.dailyAllowance}">
							</div>
							<div class="form-group">
								<label>日数</label><input required type="number" name="days[]"
									min="1" value="${detail.days}">
							</div>
							<div class="form-group">
								<label>合計</label><input required type="number"
									name="expenseTotal[]" readonly value="${detail.expenseTotal}">
							</div>
							<div class="form-group">
								<label>備考</label>
								<textarea  name="memo[]" placeholder="備考欄(何もなければスキップ)">${detail.memo}</textarea>
							</div>
							<div class="form-group">
								<label>領収書添付（日当・宿泊費）</label> <input type="file"
									name="receipt_allowance_${loop.index}" multiple
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
				<%-- ★★★ KHÔI PHỤC NÚT ADD BLOCK ★★★ --%>
				<div style="text-align: center; margin-top: 10px;">
					<button type="button" class="plus-btn"
						onclick="addAllowanceBlock()">＋</button>
				</div>

				<%-- ★★★ KHỐI NÚT BẤM ĐÚNG CHUẨN ★★★ --%>
				<div class="btn-section">
					<button type="submit" name="action" value="go_back"
						class="back-btn" formnovalidate>戻る</button>
					<button type="submit" name="action" value="go_next"
						class="next-btn">次へ</button>
				</div>
			</form>
		</div>
	</div>
	<div class="footer">&copy; 2025  - All rights reserved.</div>

	<script>
		const startDateStr = "${trip.step1Data.startDate}";
		const endDateStr = "${trip.step1Data.endDate}";
		const positionId = "${sessionScope.position_id}";
		let diffDays = 1;
		if (startDateStr && endDateStr) {
			const start = new Date(startDateStr);
			const end = new Date(endDateStr);
			if (end >= start) {
				diffDays = Math.floor((end - start) / (1000 * 60 * 60 * 24)) + 1;
			}
		}
		window.addEventListener('load', function() {
			initializeStep2(diffDays, positionId);
		});
	</script>
</body>
</html>

