<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>エクスポート(立替金申請)</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
<script src="<%=request.getContextPath()%>/static/js/script.js"></script>
</head>
<body data-mode="${mode}" data-context-path="${pageContext.request.contextPath}">

	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="page-container">
		<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
		<div class="content-container-form">
			<h2>エクスポート <small>立替金</small></h2>

			<form class="info_table" action="<%=request.getContextPath()%>/Export_reimbursement" method="post">

				<div class="table-area">
					<table id="applicationTable">
						<thead>
							<tr>
								<th class="th-action-toolbar" colspan="100" style="text-align: right;">
									<div class="action-toolbar">
										<div class="spacer"></div>
										<input type="text" id="staffSearchInput" placeholder="社員IDで検索" maxlength="5" style="padding: 6px; border: 1px solid #ccc; border-radius: 4px;">
									<button id="paidBtn" type="submit"
    						style="background-color:#FFF ;  color: green; border:1px solid green; padding: 8px 16px; border-radius: 4px;"
    						onclick="return confirm('excelファイルで出力します。よろしいですか？')">エクスポート(.xlsx)
									</button>
									</div>
								</th>
							</tr>
							<tr>
								<th><div>すべて選択</div> <input type="checkbox" id="selectAll"></th>
								<th>申請ID</th>
								<th>社員ID</th>
								<th>社員名</th>								
								<th>申請種別</th>
								<th>申請時間</th>
<!--								<th>更新時間</th>-->
								<th>金額（税込）</th>
								    <!-- <th>領収書</th>-->
								<th><select id="statusFilter" class="status-filter-button">
										<option value="">申請ステータス</option>
<!--										<option value="未提出">未提出</option>-->
<!--										<option value="提出済み">提出済み</option>-->
<!--										<option value="差戻し">差戻し</option>-->
										<option value="承認済み">承認済み</option>
										<option value="支払済み">支払済み</option>
								</select></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="p" items="${paymentList}">
								<tr class="clickable-row" data-id="${p.applicationId}" data-status="${p.status}" data-staff-id="${p.staffId}">
									<td><input type="checkbox" class="row-check" name="appIds"
										value="${p.applicationId}"></td>
									<td>${p.applicationId}</td>
									<td>${p.staffId}</td>
									<td>${p.staffName}</td>
									<td>${p.applicationType}</td>
									<td>${p.createdAt}</td>
<!--									<td>${p.updatedAt}</td>-->
									<td><fmt:formatNumber value="${p.amount}" type="number"
											pattern="#,##0" />円</td>
											
									<td>${p.status}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
<!--				<div class="btn-section">-->
<!--					<button type="button" onclick="history.back()">戻る</button>-->
<!--				</div>-->
			</form>
		</div>
	</div>

	<div class="footer">&copy; 2025 - All rights reserved.</div>

	<script>
	const checkboxes = document.querySelectorAll('.row-check');
	const paidBtn = document.getElementById('paidBtn');

	document.getElementById('selectAll').addEventListener('change', function () {
		checkboxes.forEach(cb => cb.checked = this.checked);
		updateToolbarState();
	});

	checkboxes.forEach(cb => cb.addEventListener('change', updateToolbarState));




	
	function updateToolbarState() {
	    const checked = document.querySelectorAll('.row-check:checked');
	    const hasChecked = checked.length>0;   // trueならチェックあり

	    // チェックが無ければ無効化
	    paidBtn.disabled = !hasChecked;

	    // 色切り替え
	    paidBtn.style.backgroundColor = hasChecked ? "#388E3C" : "#FFF";
	    paidBtn.style.color = hasChecked ? "white" : "green";
	    paidBtn.style.border= hasChecked? "none":"1px solid green";
	}
	// 初回ロード時に呼び出し
	updateToolbarState(); // ←ここを追加


	document.getElementById('statusFilter').addEventListener('change', function () {
	    const selected = this.value;
	    const rows = document.querySelectorAll('#applicationTable tbody tr');
	    rows.forEach(row => {
	      const status = row.getAttribute('data-status');
	      row.style.display = (!selected || selected === status) ? '' : 'none';
	    });
	  });
	
	document.querySelectorAll('.clickable-row').forEach(row => {
	  row.addEventListener('click', function (e) {
	    if (e.target.closest('td')?.cellIndex === 0) {
	        return;
	    }
	    
	    const id = this.dataset.id;
	    const mode = document.body.dataset.mode; 
	    
	    let url = 'applicationDetail?id=' + id;
	    
	    if (mode == 'export') {
	      url += '&context=exportReimbursement';

	    } else if (mode == 'payment') {
	      url += '&context=payment';
	    }
	  
	    
	    window.location.href = url;
	  });
	});

	// 社員IDでの検索用
	document.getElementById('staffSearchInput').addEventListener('input', function () {
	    const keyword = this.value.trim();
	    document.querySelectorAll('#applicationTable tbody tr').forEach(row => {
	      const staffId = row.getAttribute('data-staff-id');
	      row.style.display = (!keyword || staffId.includes(keyword)) ? '' : 'none';
	    });
	  });
	</script>
</body>
</html>
