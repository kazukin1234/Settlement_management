<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="model.Application"%>
<%@ page import="java.util.List"%>
<%
List<Application> applications = (List<Application>) request.getAttribute("applications");
String mode = (String) request.getAttribute("mode");
if (mode == null)
	mode = "approver"; // default
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>承認一覧</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
@media ( max-width : 768px) {
	.content-container {
		margin-left: 0;
		padding: 0 1rem;
		overflow-x: scroll;
	}
}
</style>
</head>
<body data-mode="<%=mode%>">
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="page-container">
		<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
		<div class="content-container-form">
			<h2><%="approver".equals(mode) ? "承認一覧" : "管理部：承認済み一覧"%></h2>


			<form class="info_table" action="approverApplications" method="post">
				<div class="table-area">
					<table id="applicationTable">
						<thead>
							<tr>
								<th class="th-action-toolbar" colspan="100" style="text-align: right;">
									<div class="action-toolbar">
										<input type="text" id="staffSearchInput" placeholder="社員IDで検索" maxlength="5" style="padding: 6px; border: 1px solid #ccc; border-radius: 4px;">
										<button type="submit" name="action" value="reject" id="rejectBtn" disabled onclick="return confirm('選択した精算を差戻します。よろしいですか？')">差戻</button>
										<button type="submit" name="action" value="approval" id="applovalBtn" disabled onclick="return confirm('選択した精算を承認します。よろしいですか？')">承認</button>
									</div>
								</th>
							</tr>
							<tr>
								<th><div>選択</div> <input type="checkbox" id="selectAll"></th>
								<th>申請ID</th>
								<th>社員ID</th>
								<th>社員名</th>
								<th>申請種別</th>
								<th>申請時間</th>
								<th>金額（税込）</th>
								<th><select id="statusFilter" class="status-filter-button">
										<option value="">申請ステータス</option>
										<option value="提出済み">提出済み</option>
										<option value="差戻し">差戻し</option>
										<option value="承認済み">承認済み</option>
										<!--  <option value="支払済み">支払済み</option>-->
								</select></th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Application app : applications) {
							%>
							<tr class="clickable-row" data-id="<%=app.getApplicationId()%>"
								data-status="<%=app.getStatus()%>"
								data-staff-id="<%=app.getStaffId()%>">
								<td><input type="checkbox" class="row-check" name="appIds"
									value="<%=app.getApplicationId()%>"></td>
								<td><%=app.getApplicationId()%></td>
								<td><%=app.getStaffId()%></td>
								<td><%=app.getStaffName()%></td>
								<td><%=app.getApplicationType()%></td>
								<td><%=app.getCreatedAt().toLocalDateTime().toString().replace('T', ' ')%></td>
								<td><%=String.format("%,d円", app.getAmount())%></td>
								<td><%=app.getStatus()%></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
			</form>

		</div>
	</div>

	<div class="footer">&copy; 2025 ABC株式会社 - All rights reserved.</div>

	<%
	Object errorObj = session.getAttribute("errorMsg");
	Object successObj = session.getAttribute("success");

	String errorMsg = (errorObj != null) ? String.valueOf(errorObj) : null;
	String successMsg = (successObj != null) ? String.valueOf(successObj) : null;

	// セッションから削除（事前に）
	session.removeAttribute("errorMsg");
	session.removeAttribute("success");
	%>

	<script>
	const checkboxes = document.querySelectorAll('.row-check');
    const rejectBtn = document.getElementById('rejectBtn');
    const approvalBtn = document.getElementById('approvalBtn');
	
	document.getElementById('selectAll').addEventListener('change', function () {
	    checkboxes.forEach(cb => cb.checked = this.checked);
	    updateToolbarState();
	  });

	// チェックボックスを常時監視
	checkboxes.forEach(cb => cb.addEventListener('change', updateToolbarState));
    function updateToolbarState() {
        const checked = document.querySelectorAll('.row-check:checked');
        rejectBtn.disabled = (checked.length === 0);
        applovalBtn.disabled = (checked.length === 0);
      }
	  
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
        
        if (mode === 'approver') {
          url += '&context=approval';
        } else if (mode === 'payment') {
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

	//エラー、成功メッセージ受け取り
	<%if (errorMsg != null) {
	String safeError = errorMsg.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");%>
	    alert("<%=safeError%>");
	<%}
if (successMsg != null) {
String safeSuccess = successMsg.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");%>
	    alert("<%=safeSuccess%>");
	<%}%>
  </script>
</body>
</html>
