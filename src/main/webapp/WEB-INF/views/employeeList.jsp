<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="bean.Employee"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>社員一覧 - 管理画面</title>
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/static/css/style.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" />
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
<body>
	<jsp:include page="/WEB-INF/views/common/header.jsp" />
	<div class="page-container">
		<!-- Sidebar -->
		<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
		<div class="content-container-form">
			<h2>社員一覧</h2>
			<form class="info_table" method="post" action="employeeControl">
				<table>
					<thead>
						<tr>
							<th class="th-action-toolbar" colspan="100" style="text-align: right;">
								<div class="action-toolbar">
								
				
				<button type="button"
        onclick="location.href='<%=request.getContextPath()%>/employeeRegisterPage?mode=new'">
    ＋ 新規追加
</button>
				<button type="submit" name="action" value="edit" id="editBtn"
										disabled>編集</button>
									<button type="submit" name="action" value="delete" id="deleteBtn"
										disabled onclick="return confirm('本当に削除しますか？')">削除</button>
								</div>
							</th>
						</tr>
					<tr>
							<th>選択</th>
							<th>社員ID</th>
							<th>氏名</th>
							<th>ふりがな</th>
							<!--  <th>生年月日</th>
							<th>住所</th>-->
							<th>入社日</th>
							<th>部署</th>
							<th>役職</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="emp" items="${employeeList}">
							<tr>
								<td><input type="checkbox" name="employeeID"
									value="${emp.employeeId}" class="row-check"></td>
								<td>${emp.employeeId}</td>
								<td>${emp.fullName}</td>
								<td>${emp.furigana}</td>
								<!--  <td>${emp.birthDate}</td>
								<td>${emp.address}</td>-->
								<td>${emp.joinDate}</td>
								<td>${emp.departmentName}</td>
								<td>${emp.positionName}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</form>
		</div>
	</div>
	<script type="text/javascript">
	const checkboxes = document.querySelectorAll('.row-check');
  	const editBtn = document.getElementById('editBtn');
  	const deleteBtn = document.getElementById('deleteBtn');

	document.querySelectorAll('.row-check').forEach(cb => {
	  	cb.addEventListener('change', () => {
		    // チェックが変更された瞬間に処理が走る
		    console.log('チェック変更トリガー', cb.checked);
		    const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
		 	// 編集ボタン：1つだけ選択されている時だけ活性
		    editBtn.disabled = checkedCount !== 1;

		    // 削除ボタン：1つ以上選択されていれば活性
		    deleteBtn.disabled = checkedCount === 0;
	  });
	});
	function goToRegister() {
	    location.href = '<%=request.getContextPath()%>/employeeRegisterPage';
	}
	</script>

	<c:if test="${not empty success}">
		<script>alert("${success}");</script>
	</c:if>

	<c:if test="${not empty errorMsg}">
		<script>alert("${errorMsg}");</script>
	</c:if>

</body>
</html>
