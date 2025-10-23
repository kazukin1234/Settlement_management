<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="model.Application"%>
<%@ page import="java.util.List"%>
<%
List<Application> applications = (List<Application>) request.getAttribute("applications");
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>申請一覧 - ABC株式会社</title>

<link rel="stylesheet"
	href="<%= request.getContextPath() %>/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
<style>
@media ( max-width : 768px) {
	.content-container {
		overflow-x: scroll;
		margin-left: 0;
		padding: 0 1rem;
	}
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="page-container">
		<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
		<div class="content-container-form">
			<h2>申請一覧</h2>
			<form class="info_table" action="submitApplication" method="post" id="submitForm">

				<div class="table-area">
					<table id="applicationTable">
						<thead>
							<tr>
								<th class="th-action-toolbar" colspan="100" style="text-align: right;">
									<div class="action-toolbar">
										<button type="submit" name="action" value="post" id="postBtn"
											disabled onclick="return confirmSubmit()">提出</button>
										<button type="submit" name="action" value="edit" id="editBtn"
											disabled>編集</button>
										<button type="submit" name="action" value="delete" id="deleteBtn"
											disabled onclick="return confirm('本当に削除しますか？')">削除</button>
									</div>
								</th>
							</tr>
							<tr>
								<th><div>選択</div>
									<input type="checkbox" id="selectAll"></th>
								<th>申請ID</th>
								<th>申請種別</th>
								<th>申請時間</th>
								<th>金額（税込）</th>
								<th><select id="statusFilter" class="status-filter-button">
										<option value="">申請ステータス</option>
										<option value="未提出">未提出</option>
										<option value="提出済み">提出済み</option>
										<option value="差戻し">差戻し</option>
										<option value="承認済み">承認済み</option>
										<option value="支払い済">支払い済</option>
								</select></th>
							</tr>
						</thead>
						<tbody>
							<%
							for (Application app : applications) {
							%>
							<tr class="clickable-row" data-id="<%=app.getApplicationId()%>"
								data-status="<%=app.getStatus()%>">
								<td><input type="checkbox" class="row-check" name="appIds"
									value="<%=app.getApplicationId()%>"></td>
								<td><%=app.getApplicationId()%></td>
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
				<!-- 提出確認モーダル -->
				<div id="submitModal" class="modal hidden">
					<div class="modal-content">
						<p>選択された申請を提出しますか？</p>
						<div class="modal-buttons">
							<button type="button" onclick="closeModal()">キャンセル</button>
							<button type="submit" name="action" value="post">提出</button>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<%
	if (session.getAttribute("submitSuccess") != null) {
	%>
	<script>alert('申請を提出しました。');</script>
	<%
	session.removeAttribute("submitSuccess");
	%>
	<%
	}
	%>

	<%
	String msg = (String) session.getAttribute("message");
	%>
	<%
	if (msg != null) {
	%>
	<div class="custom-message error"><%=msg%></div>
	<%
	session.removeAttribute("message");
	%>
	<%
	}
	%>

	<div class="footer">&copy; 2025  - All rights reserved.</div>

	<script>
    const checkboxes = document.querySelectorAll('.row-check');
    const postBtn = document.getElementById('postBtn');
    const editBtn = document.getElementById('editBtn');
    const deleteBtn = document.getElementById('deleteBtn');
    const modal = document.getElementById('submitModal');

    document.getElementById('selectAll').addEventListener('change', function () {
      checkboxes.forEach(cb => cb.checked = this.checked);
      updateToolbarState();
    });

    checkboxes.forEach(cb => cb.addEventListener('change', updateToolbarState)); 
    

    function updateToolbarState() {
      const checked = document.querySelectorAll('.row-check:checked');
      postBtn.disabled = (checked.length !== 1);
      editBtn.disabled = (checked.length !== 1);
      deleteBtn.disabled = (checked.length === 0);
    }

    document.getElementById('statusFilter').addEventListener('change', function () {
      const selected = this.value;
      document.querySelectorAll('#applicationTable tbody tr').forEach(row => {
        const status = row.getAttribute('data-status');
        row.style.display = (!selected || selected === status) ? '' : 'none';
      });
    });

    document.querySelectorAll('.clickable-row').forEach(row => {
      row.addEventListener('click', function (e) {
        if (e.target.closest('td')?.cellIndex === 0) return;
        window.location.href = 'applicationDetail?id=' + this.dataset.id;
      });
    });

    function confirmSubmit() {
      const checked = document.querySelectorAll('.row-check:checked');
      if (checked.length === 0) {
        alert('提出する申請を選択してください。');
        return false;
      }

      for (const cb of checked) {
        const status = cb.closest('tr').getAttribute('data-status');
        if (status !== '未提出' && status !== '差戻し') {
          alert('未提出または差戻しの申請のみ提出可能です。');
          return false;
        }
      }

      modal.classList.remove('hidden');
      return false;
    }

    function closeModal() {
      modal.classList.add('hidden');
    }

    function submitForm(action) {
      document.getElementById('modalActionInput').value = action;
      document.getElementById('submitForm').submit();
    }

    // URLクエリパラメータでフィルターを自動適用
    window.addEventListener("DOMContentLoaded", function () {
      const urlParams = new URLSearchParams(window.location.search);
      const filter = urlParams.get("status");
      const map = {
        "not_submitted": "未提出",
        "submitted": "提出済み",
        "rejected": "差戻し",
        "approved": "承認済",
        "paid": "支払い済"
      };
      if (filter && map[filter]) {
        const statusSelect = document.getElementById("statusFilter");
        statusSelect.value = map[filter];
        statusSelect.dispatchEvent(new Event('change'));
      }
    });

    function goToEditPage() {
        const checked = document.querySelectorAll('.row-check:checked');
        const appId = checked[0].value;
        window.location.href = 'applicationDetail?id=' + appId + '&action=edit';
      }
  </script>

</body>
</html>
